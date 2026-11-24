package visualizer.server

import java.nio.{ByteBuffer, ByteOrder}

object Protocol {

  val RequestSize = 10
  val ResponseSize = 20

  object Operation {
    val READ = 0
    val WRITE = 1
  }

  object Status {
    val HIT           = 1 << 0
    val MISS          = 1 << 1
    val WRITE_BACK    = 1 << 2
    val WRITE_THROUGH = 1 << 3
    val IS_WRITE      = 1 << 4
    val EVICT         = 1 << 5
    val EVICT_DIRTY   = 1 << 6
  }

  case class Request(
    addr: Long,
    data: Long,
    mask: Int,
    operation: Int
  )

  case class Response(
    status: Int,
    way: Int,
    data: Long,
    latency: Int,
    timestamp: Long,
    evictAddr: Long
  )

  def decodeRequest(bytes: Array[Byte]): Request = {
    val b = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)

    Request(
      Integer.toUnsignedLong(b.getInt()),
      Integer.toUnsignedLong(b.getInt()),
      b.get() & 0xff,
      b.get() & 0xff
    )
  }

  def encodeResponse(r: Response): Array[Byte] = {
    val b = ByteBuffer.allocate(ResponseSize)
      .order(ByteOrder.LITTLE_ENDIAN)

    b.put(r.status.toByte)
    b.put(r.way.toByte)
    b.putInt(r.data.toInt)
    b.putShort(r.latency.toShort)
    b.putLong(r.timestamp)
    b.putInt(r.evictAddr.toInt)

    b.array()
  }
}
