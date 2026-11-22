package cache

import chisel3._
import chisel3.util._

/** Combinational tree operations; the cache will own the per-set registers.
  * Nodes use heap order: root 0, left child 2*i+1, right child 2*i+2.
  * A zero bit prefers the left subtree for eviction; a one prefers the right.
  *
  * Four-way example (only internal nodes store bits):
  *                 node 0
  *                /      \
  *            node 1    node 2
  *             /  \      /  \
  *          way 0 way 1 way 2 way 3
  *
  * state(i) is node i's bit, so a printed UInt is [node2 node1 node0].
  * Scala recursion builds the hardware during elaboration; these operations
  * do not take one clock per tree level and do not store state themselves.
  */
class TreePLRULogic(numWays: Int) {
  // Equal-sized halves at every level require a power of two. A one-way cache
  // needs no replacement decision and will bypass this helper entirely.
  require(numWays >= 2 && isPow2(numWays), "tree PLRU requires a power-of-two number of ways >= 2")
  // A full binary tree with N leaves has N-1 internal nodes.
  val stateBits: Int = numWays - 1

  /** Follow the eviction preferences in the current state to a leaf (way). */
  def victim(state: UInt): UInt = {
    require(state.getWidth == stateBits)
    // This subtree covers ways [firstWay, firstWay + ways).
    def descend(node: Int, firstWay: Int, ways: Int): UInt = {
      // A single remaining way is a leaf: return its index, not a tree node index.
      if (ways == 1) firstWay.U(log2Ceil(numWays).W)
      // Chisel Mux takes (condition, value if true, value if false):
      // bit 1 chooses the right half; bit 0 chooses the left half.
      else Mux(state(node),
        descend(2 * node + 2, firstWay + ways / 2, ways / 2),
        descend(2 * node + 1, firstWay, ways / 2))
    }
    descend(0, 0, numWays) // Start at the root, covering all ways.
  }

  /** Return the state after an access; the caller must save it in a register. */
  def touch(state: UInt, touchedWay: UInt): UInt = {
    require(state.getWidth == stateBits)
    require(touchedWay.getWidth == log2Ceil(numWays))
    // Turn the packed state into writable bits. Unchanged nodes keep their
    // original values; WireInit creates combinational wires, not registers.
    val next = WireInit(VecInit(state.asBools))
    def update(node: Int, firstWay: Int, ways: Int): Unit = {
      if (ways > 1) {
        // Only ancestors of the touched way change. Nodes in other subtrees
        // retain their bits, preserving the history of accesses within them.
        when(touchedWay >= firstWay.U && touchedWay < (firstWay + ways).U) {
          // Access left => store 1 (evict right); access right => store 0.
          // This records a preference between halves, not an exact LRU order.
          next(node) := touchedWay < (firstWay + ways / 2).U
        }
        // Generate update logic for both halves. The range checks above ensure
        // only the nodes on the accessed way's path actually change.
        update(2 * node + 1, firstWay, ways / 2)
        update(2 * node + 2, firstWay + ways / 2, ways / 2)
      }
    }
    update(0, 0, numWays)
    next.asUInt // Pack the bits back, keeping node 0 at bit 0.
  }
}
