package visualizer.server

import java.net.{ServerSocket, Socket, SocketException}
import java.io.{DataInputStream, DataOutputStream, EOFException}

import visualizer.simulator.CacheSimulator

class CacheServer(
  port: Int,
  simulator: CacheSimulator
) {

  @volatile private var running = true
  @volatile private var activeClient: Socket = _

  private var server: ServerSocket = _

  def start(): Unit = {
    server = new ServerSocket(port)

    println(s"[Server] Listening on port $port")

    while (running) {
      try {
        val client = server.accept()
        activeClient = client

        println(s"[Server] Connected: ${client.getInetAddress}")

        handleClient(client)

      } catch {
        case _: SocketException if !running =>
          // Expected when shutting down.

        case e: Exception =>
          println(s"[Server] Error: ${e.getMessage}")
      } finally {
        activeClient = null
      }
    }

    println("[Server] Stopped")
  }

  private def handleClient(socket: Socket): Unit = {
    socket.setTcpNoDelay(true)

    val input = new DataInputStream(socket.getInputStream)
    val output = new DataOutputStream(socket.getOutputStream)

    try {
      while (running && !socket.isClosed) {

        val requestBytes = new Array[Byte](Protocol.RequestSize)

        try {
          input.readFully(requestBytes)
        } catch {
          case _: EOFException =>
            return
        }

        val request = Protocol.decodeRequest(requestBytes)

        val response = simulator.process(request)

        output.write(Protocol.encodeResponse(response))
        output.flush()

      }

    } catch {
      case e: Exception if running =>
        println(s"[Server] Client error: ${e.getMessage}")

    } finally {
      socket.close()
      println("[Server] Client disconnected")
    }
  }

  def stop(): Unit = {
    running = false

    if (activeClient != null) {
      try activeClient.close()
      catch {
        case _: Exception =>
      }
    }

    if (server != null && !server.isClosed) {
      server.close()
    }
  }
}
