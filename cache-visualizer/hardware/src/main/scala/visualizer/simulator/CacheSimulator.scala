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

  private case class TickResult(
    requestAccepted: Boolean,
    response: Option[Long],
    hit: Boolean,
    miss: Boolean,
    writeback: Boolean,
    writeThrough: Boolean,
    way: Int,
    evict: Boolean,
    evictDirty: Boolean,
    evictAddr: Long
  )

  // ------------------------------------------------------------
  // Backing memory
  // ------------------------------------------------------------

  private val memory = mutable.Map.empty[Long, Int]

  private def readByte(addr: Long): Int =
    memory.getOrElse(addr, 0)

  private def readBeat(addr: Long): BigInt = {
    (0 until cfg.memBeatBytes).foldLeft(BigInt(0)) {
      case (value, i) =>
        value | (BigInt(readByte(addr + i)) << (8 * i))
    }
  }

  private def writeBeat(
    addr: Long,
    data: BigInt,
    mask: BigInt
  ): Unit = {

    for (i <- 0 until cfg.memBeatBytes) {
      if (mask.testBit(i)) {
        val byte = ((data >> (8 * i)) & 0xff).toInt
        memory(addr + i) = byte
      }
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

    dut.io.resp.ready.poke(true.B)

    dut.io.memReq.ready.poke(true.B)

    dut.io.memResp.valid.poke(false.B)
    dut.io.memResp.bits.data.poke(0.U)

    dut.io.memWriteReq.ready.poke(true.B)

    dut.io.memWriteData.ready.poke(true.B)

    dut.io.memWriteResp.valid.poke(false.B)
    dut.io.memWriteResp.bits.ack.poke(true.B)
  }

  initialize()

  // ------------------------------------------------------------
  // One simulation clock cycle
  // ------------------------------------------------------------

  private def tick(
    request: Option[Request] = None
  ): TickResult = {

    // CPU request.
    dut.io.req.valid.poke(request.isDefined.B)

    request.foreach { r =>
      dut.io.req.bits.addr.poke(r.addr.U)
      dut.io.req.bits.isWrite.poke(
        (r.operation == Operation.WRITE).B
      )
      dut.io.req.bits.writeData.poke(r.data.U)
      dut.io.req.bits.writeMask.poke(r.mask.U)
    }

    // CPU response.
    dut.io.resp.ready.poke(true.B)

    // Memory refill response.
    val refillValid = refillQueue.nonEmpty

    dut.io.memResp.valid.poke(refillValid.B)

    if (refillValid) {
      dut.io.memResp.bits.data.poke(refillQueue.front.U)
    }

    // Memory read request.
    dut.io.memReq.ready.poke(true.B)

    // Memory write request/data.
    dut.io.memWriteReq.ready.poke(true.B)
    dut.io.memWriteData.ready.poke(true.B)

    // Memory write completion.
    dut.io.memWriteResp.valid.poke(writeAckPending.B)
    dut.io.memWriteResp.bits.ack.poke(true.B)

    // ----------------------------------------------------------
    // Observe handshakes BEFORE advancing the clock.
    // ----------------------------------------------------------

    val requestAccepted =
      request.isDefined && dut.io.req.ready.peek().litToBoolean

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

    val response =
      if (dut.io.resp.valid.peek().litToBoolean)
        Some(dut.io.resp.bits.data.peek().litValue.toLong)
      else
        None

    // Statistics.
    val stats = dut.io.stat

    val hit = stats.hit.peek().litToBoolean
    val miss = stats.miss.peek().litToBoolean
    val writeback = stats.writeback.peek().litToBoolean
    val writeThrough = stats.writeThrough.peek().litToBoolean

    val way = stats.way.peek().litValue.toInt
    val evict = stats.evict.peek().litToBoolean
    val evictDirty = stats.evictDirty.peek().litToBoolean
    val evictAddr = stats.evictAddr.peek().litValue.toLong

    // Capture memory addresses before advancing the clock.
    val readAddress =
      if (memReqFire)
        dut.io.memReq.bits.addr.peek().litValue.toLong
      else 0L

    val writeAddress =
      if (memWriteReqFire)
        dut.io.memWriteReq.bits.addr.peek().litValue.toLong
      else 0L

    val writeData =
      if (memWriteDataFire)
        dut.io.memWriteData.bits.data.peek().litValue
      else BigInt(0)

    val writeMask =
      if (memWriteDataFire)
        dut.io.memWriteData.bits.mask.peek().litValue
      else BigInt(0)

    // ----------------------------------------------------------
    // Advance hardware.
    // ----------------------------------------------------------

    dut.clock.step()
    cycle += 1

    // ----------------------------------------------------------
    // Process memory handshakes.
    // ----------------------------------------------------------

    if (memRespFire) {
      refillQueue.dequeue()
    }

    if (memReqFire) {
      for (i <- 0 until cfg.beatsPerLine) {
        val addr = readAddress + i * cfg.memBeatBytes
        refillQueue.enqueue(readBeat(addr))
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
        transaction.receivedBeats * cfg.memBeatBytes

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

    TickResult(
      requestAccepted,
      response,
      hit,
      miss,
      writeback,
      writeThrough,
      way,
      evict,
      evictDirty,
      evictAddr
    )
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

    var accepted = false

    var hit = false
    var miss = false
    var writeback = false
    var writeThrough = false

    var way = 0
    var evict = false
    var evictDirty = false
    var evictAddr = 0L

    def collect(t: TickResult): Unit = {
      hit ||= t.hit
      miss ||= t.miss
      writeback ||= t.writeback
      writeThrough ||= t.writeThrough

      if (t.hit || t.miss) {
        way = t.way
        evict = t.evict
        evictDirty = t.evictDirty
        evictAddr = t.evictAddr
      }
    }

    // ----------------------------------------------------------
    // Submit request.
    // ----------------------------------------------------------

    var attempts = 0

    while (!accepted) {
      val t = tick(Some(request))
      collect(t)

      accepted = t.requestAccepted

      attempts += 1
      require(attempts < 100000, "CPU request handshake timeout")
    }

    // ----------------------------------------------------------
    // Wait for CPU response.
    // ----------------------------------------------------------

    var result: Option[Long] = None

    while (result.isEmpty) {
      val t = tick()
      collect(t)

      result = t.response

      attempts += 1
      require(attempts < 100000, "Cache response timeout")
    }

    // ----------------------------------------------------------
    // Construct binary response.
    // ----------------------------------------------------------

    var status = 0

    if (hit) status |= Status.HIT
    if (miss) status |= Status.MISS

    if (writeback) status |= Status.WRITE_BACK
    if (writeThrough) status |= Status.WRITE_THROUGH

    if (request.operation == Operation.WRITE)
      status |= Status.IS_WRITE

    if (evict) status |= Status.EVICT
    if (evictDirty) status |= Status.EVICT_DIRTY

    val latency = (cycle - startCycle).min(65535L).toInt

    Response(
      status = status,
      way = way,
      data = result.get,
      latency = latency,
      timestamp = cycle,
      evictAddr = evictAddr
    )
  }

  def currentCycle: Long = cycle
}

