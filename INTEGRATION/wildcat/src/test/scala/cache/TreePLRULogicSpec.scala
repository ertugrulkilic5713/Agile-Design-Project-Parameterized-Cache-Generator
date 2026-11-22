package cache

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

// Expose the combinational helper as testable hardware. Tests supply the current
// state explicitly, so they can check every bit pattern without clocking it in.
class TreePLRUHarness(numWays: Int) extends Module {
  val io = IO(new Bundle {
    val state = Input(UInt((numWays - 1).W))
    val touchedWay = Input(UInt(log2Ceil(numWays).W))
    val victim = Output(UInt(log2Ceil(numWays).W))
    val nextState = Output(UInt((numWays - 1).W))
  })
  private val tree = new TreePLRULogic(numWays)
  io.victim := tree.victim(io.state)
  io.nextState := tree.touch(io.state, io.touchedWay)
}

class TreePLRULogicSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "TreePLRULogic"

  // The software oracle walks one path iteratively, unlike the recursive hardware.
  private def victim(state: Int, ways: Int): Int = {
    var node = 0
    // In heap order, internal nodes occupy 0 .. ways-2. Leaves follow them.
    while (node < ways - 1) {
      node = 2 * node + 1 + ((state >> node) & 1)
    }
    node - (ways - 1) // Convert the leaf's tree index to a zero-based way index.
  }

  private def touch(state: Int, way: Int, ways: Int): Int = {
    var result = state
    // Start at the accessed leaf and climb toward the root. This independent
    // formulation helps catch mistakes in the hardware's subtree range checks.
    var child = ways - 1 + way
    while (child > 0) {
      val parent = (child - 1) / 2
      val accessedLeft = child == 2 * parent + 1
      // A left access sets the parent's bit; a right access clears it.
      if (accessedLeft) result |= 1 << parent
      else result &= ~(1 << parent)
      child = parent
    }
    result
  }

  for (ways <- Seq(2, 4, 8)) {
    it should s"match the software tree for every state and access with $ways ways" in {
      test(new TreePLRUHarness(ways)) { dut =>
        // N-1 bits give 2^(N-1) possible states. Try every state with every way,
        // including combinations that a short example sequence might miss.
        for (state <- 0 until (1 << (ways - 1)); way <- 0 until ways) {
          dut.io.state.poke(state.U)
          dut.io.touchedWay.poke(way.U)
          dut.io.victim.expect(victim(state, ways).U)
          val updated = touch(state, way, ways)
          dut.io.nextState.expect(updated.U)
          // Reading the updated tree must also agree, and protect the touched way.
          dut.io.state.poke(updated.U)
          dut.io.victim.expect(victim(updated, ways).U)
          assert(victim(updated, ways) != way)
        }
      }
    }
  }

  it should "follow the four-way teaching example" in {
    test(new TreePLRUHarness(4)) { dut =>
      var state = 0
      dut.io.state.poke(state.U)
      dut.io.touchedWay.poke(0.U)
      dut.io.victim.expect(0.U)
      // States are printed as [node2 node1 node0], with the root at bit zero.
      // Fill ways 0,1,2,3, then touch 0 again: PLRU chooses 2, whereas exact
      // LRU would choose 1. The expected states below are hand-calculated.
      for ((way, expected) <- Seq(0 -> 3, 1 -> 1, 2 -> 4, 3 -> 0, 0 -> 3)) {
        dut.io.touchedWay.poke(way.U)
        dut.io.nextState.expect(expected.U)
        state = dut.io.nextState.peekInt().toInt
        dut.io.state.poke(state.U)
      }
      dut.io.victim.expect(2.U)
    }
  }

  it should "reject shapes that are not multi-way binary trees" in {
    for (ways <- Seq(0, 1, 3, 6)) {
      intercept[IllegalArgumentException] { new TreePLRULogic(ways) }
    }
  }
}
