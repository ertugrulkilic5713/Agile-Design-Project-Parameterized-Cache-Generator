package visualizer.simulator

import chisel3._
import chiseltest._

import cache._
import visualizer.server.Protocol

import scala.collection.mutable

class CacheSimulator(
  dut: SetAssociativeCache,
  cfg: CacheConfig
) {

  import Protocol._

  private case class WriteTransaction(
    addr: Long,
    expectedBeats: Int,
    var receivedBeats: Int = 0
  )

  // Accumulates events across cycles for one CPU request.
  // Reused instead of allocating a TickResult on every cycle.
  private final class TickState {
    var requestAccepted = false
    var responseValid = false
    var responseData = 0L

    var hit = false
    var miss = false
    var writeback = false
    var writeThrough = false

    var way = 0
    var evict = false
    var evictDirty = false
    var evictAddr = 0L

    def resetCycle(): Unit = {
      requestAccepted = false
      responseValid = false
      responseData = 0L
    }
  }

  // ------------------------------------------------------------
  // Backing memory
  // ------------------------------------------------------------

  private val memory = mutable.Map.empty[Long, Int]

  private def readByte(addr: Long): Int =
    memory.getOrElse(addr, 0)

  // Fast path for the usual 32-bit memory interface.
  // Retains support for larger memory beats.
  private def readBeat(addr: Long): BigInt = {

    if (cfg.memBeatBytes <= 4) {
      var value = 0

      var i = 0
      while (i < cfg.memBeatBytes) {
        value |= (readByte(addr + i) & 0xff) << (i * 8)
        i += 1
      }

      BigInt(value & 0xffffffffL)
    } else {
      var value = BigInt(0)

      var i = 0
      while (i < cfg.memBeatBytes) {
        value |= BigInt(readByte(addr + i)) << (i * 8)
        i += 1
      }

      value
    }
  }

  private def writeBeat(
    addr: Long,
    data: BigInt,
    mask: BigInt
  ): Unit = {

    val dataLong = data.toLong
    val maskLong = mask.toLong

    var i = 0

    while (i < cfg.memBeatBytes) {

      if ((maskLong & (1L << i)) != 0) {
        memory(addr + i) =
          ((dataLong >>> (i * 8)) & 0xffL).toInt
      }

      i += 1
    }
  }

  // ------------------------------------------------------------
  // Memory transaction state
  // ------------------------------------------------------------

  private val refillQueue = mutable.Queue.empty[BigInt]

  private var writeTransaction: Option[WriteTransaction] = None

  private var writeAckPending = false

  // ------------------------------------------------------------
  // Simulation state
  // ------------------------------------------------------------

  private var cycle = 0L

  private def initialize(): Unit = {

    dut.io.req.valid.poke(false.B)
    dut.io.req.bits.addr.poke(0.U)
    dut.io.req.bits.isWrite.poke(false.B)
    dut.io.req.bits.writeData.poke(0.U)
    dut.io.req.bits.writeMask.poke(0.U)

    // These signals never change during simulation.
    dut.io.resp.ready.poke(true.B)

    dut.io.memReq.ready.poke(true.B)

    dut.io.memWriteReq.ready.poke(true.B)
    dut.io.memWriteData.ready.poke(true.B)

    dut.io.memResp.valid.poke(false.B)
    dut.io.memResp.bits.data.poke(0.U)

    dut.io.memWriteResp.valid.poke(false.B)
    dut.io.memWriteResp.bits.ack.poke(true.B)
  }

  initialize()

  // ------------------------------------------------------------
  // One simulation clock cycle
  // ------------------------------------------------------------

  // request == null means no CPU request this cycle.
  private def tick(
    state: TickState,
    request: Request = null
  ): Unit = {

    state.resetCycle()

    val hasRequest = request != null

    // ----------------------------------------------------------
    // CPU request
    // ----------------------------------------------------------

    dut.io.req.valid.poke(hasRequest.B)

    if (hasRequest) {
      dut.io.req.bits.addr.poke(request.addr.U)

      dut.io.req.bits.isWrite.poke(
        (request.operation == Operation.WRITE).B
      )

      dut.io.req.bits.writeData.poke(request.data.U)
      dut.io.req.bits.writeMask.poke(request.mask.U)
    }

    // ----------------------------------------------------------
    // Memory refill response
    // ----------------------------------------------------------

    val refillValid = refillQueue.nonEmpty

    dut.io.memResp.valid.poke(refillValid.B)

    if (refillValid) {
      dut.io.memResp.bits.data.poke(refillQueue.front.U)
    }

    // ----------------------------------------------------------
    // Memory write completion
    // ----------------------------------------------------------

    dut.io.memWriteResp.valid.poke(writeAckPending.B)

    // ----------------------------------------------------------
    // Observe handshakes BEFORE advancing the clock.
    // ----------------------------------------------------------

    state.requestAccepted =
      hasRequest && dut.io.req.ready.peek().litToBoolean

    val memReqFire =
      dut.io.memReq.valid.peek().litToBoolean

    val memRespFire =
      refillValid && dut.io.memResp.ready.peek().litToBoolean

    val memWriteReqFire =
      dut.io.memWriteReq.valid.peek().litToBoolean

    val memWriteDataFire =
      dut.io.memWriteData.valid.peek().litToBoolean

    val memWriteRespFire =
      writeAckPending &&
      dut.io.memWriteResp.ready.peek().litToBoolean

    // CPU response
    if (dut.io.resp.valid.peek().litToBoolean) {
      state.responseValid = true

      state.responseData =
        dut.io.resp.bits.data.peek().litValue.toLong
    }

    // ----------------------------------------------------------
    // Statistics
    // ----------------------------------------------------------

    val stats = dut.io.stat

    val hit = stats.hit.peek().litToBoolean
    val miss = stats.miss.peek().litToBoolean

    state.hit ||= hit
    state.miss ||= miss

    // These can be independent event signals, so keep observing
    // them every cycle, as in the original implementation.
    state.writeback ||=
      stats.writeback.peek().litToBoolean

    state.writeThrough ||=
      stats.writeThrough.peek().litToBoolean

    // Only inspect eviction details on a hit/miss event.
    if (hit || miss) {
      state.way = stats.way.peek().litValue.toInt
      state.evict = stats.evict.peek().litToBoolean

      state.evictDirty =
        stats.evictDirty.peek().litToBoolean

      state.evictAddr =
        stats.evictAddr.peek().litValue.toLong
    }

    // ----------------------------------------------------------
    // Capture memory request data before advancing the clock.
    // ----------------------------------------------------------

    val readAddress =
      if (memReqFire)
        dut.io.memReq.bits.addr.peek().litValue.toLong
      else
        0L

    val writeAddress =
      if (memWriteReqFire)
        dut.io.memWriteReq.bits.addr.peek().litValue.toLong
      else
        0L

    val writeData =
      if (memWriteDataFire)
        dut.io.memWriteData.bits.data.peek().litValue
      else
        BigInt(0)

    val writeMask =
      if (memWriteDataFire)
        dut.io.memWriteData.bits.mask.peek().litValue
      else
        BigInt(0)

    // ----------------------------------------------------------
    // Advance hardware
    // ----------------------------------------------------------

    dut.clock.step()
    cycle += 1

    // ----------------------------------------------------------
    // Process memory handshakes
    // ----------------------------------------------------------

    if (memRespFire) {
      refillQueue.dequeue()
    }

    if (memReqFire) {

      var i = 0

      while (i < cfg.beatsPerLine) {

        val addr =
          readAddress + i.toLong * cfg.memBeatBytes

        refillQueue.enqueue(readBeat(addr))

        i += 1
      }
    }

    if (memWriteReqFire) {

      require(
        writeTransaction.isEmpty,
        "New memory write while previous write is active"
      )

      val expected =
        if (cfg.isWriteThrough) 1
        else cfg.beatsPerLine

      writeTransaction = Some(
        WriteTransaction(writeAddress, expected)
      )
    }

    if (memWriteDataFire) {

      val transaction = writeTransaction.getOrElse {
        throw new IllegalStateException(
          "Received memory write data without a write request"
        )
      }

      val addr =
        transaction.addr +
        transaction.receivedBeats.toLong * cfg.memBeatBytes

      writeBeat(addr, writeData, writeMask)

      transaction.receivedBeats += 1

      if (transaction.receivedBeats == transaction.expectedBeats) {
        writeAckPending = true
      }
    }

    if (memWriteRespFire) {
      writeAckPending = false
      writeTransaction = None
    }
  }

  // ------------------------------------------------------------
  // Process one CPU request
  // ------------------------------------------------------------

  def process(request: Request): Response = synchronized {

    require(request.addr >= 0 && request.addr <= 0xffffffffL)
    require(request.data >= 0 && request.data <= 0xffffffffL)
    require(request.mask >= 0 && request.mask <= 0xff)

    require(
      request.operation == Operation.READ ||
      request.operation == Operation.WRITE
    )

    val startCycle = cycle

    val state = new TickState

    // ----------------------------------------------------------
    // Submit request
    // ----------------------------------------------------------

    var accepted = false
    var attempts = 0

    while (!accepted) {

      tick(state, request)

      accepted = state.requestAccepted

      attempts += 1

      require(
        attempts < 100000,
        "CPU request handshake timeout"
      )
    }

    // ----------------------------------------------------------
    // Wait for CPU response
    // ----------------------------------------------------------

    while (!state.responseValid) {

      tick(state)

      attempts += 1

      require(
        attempts < 100000,
        "Cache response timeout"
      )
    }

    // ----------------------------------------------------------
    // Construct binary response
    // ----------------------------------------------------------

    var status = 0

    if (state.hit) status |= Status.HIT
    if (state.miss) status |= Status.MISS

    if (state.writeback) status |= Status.WRITE_BACK
    if (state.writeThrough) status |= Status.WRITE_THROUGH

    if (request.operation == Operation.WRITE)
      status |= Status.IS_WRITE

    if (state.evict) status |= Status.EVICT
    if (state.evictDirty) status |= Status.EVICT_DIRTY

    val latency =
      (cycle - startCycle).min(65535L).toInt

    Response(
      status = status,
      way = state.way,
      data = state.responseData,
      latency = latency,
      timestamp = cycle,
      evictAddr = state.evictAddr
    )
  }

  def currentCycle: Long = cycle
}

