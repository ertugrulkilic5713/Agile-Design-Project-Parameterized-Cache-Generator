package visualizer

import chiseltest.RawTester

import cache._

import visualizer.server.CacheServer
import visualizer.simulator.CacheSimulator

object Main {

  def main(args: Array[String]): Unit = {
    val options = args
      .grouped(2)
      .collect {
        case Array(key, value) => key -> value
      }
      .toMap

    val port = options.getOrElse("--port", "9000").toInt

    val config = CacheConfig(
      capacityBytes = options.getOrElse("--cache-size", "4096").toInt,
      addrWidth = options.getOrElse("--addr-width", "32").toInt,
      lineBytes = options.getOrElse("--line-bytes", "16").toInt,
      wordBytes = options.getOrElse("--word-bytes", "4").toInt,
      memBeatBytes = options.getOrElse("--mem-beat-bytes", "4").toInt,
      numWays = options.getOrElse("--associativity", "4").toInt,
      // replacement = options.getOrElse("--replacement", "lru"), // todo
      writePolicy = options.getOrElse("--write-policy", "write-back") match {
        case "write-through" => WriteThrough
        case "write-back"    => WriteBack
        case other => throw new IllegalArgumentException(
          s"Unknown write policy: $other"
        )
      }
    )

    println(s"Starting cache simulator on port $port")

    println("========================================")
    println("       CACHE HARDWARE SIMULATOR")
    println("========================================")

    println(s"[Config] Capacity: ${config.capacityBytes} bytes")
    println(s"[Config] Line size: ${config.lineBytes} bytes")
    println(s"[Config] Sets: ${config.numSets}")
    println(s"[Config] Ways: ${config.numWays}")
    println(s"[Config] Write policy: ${config.writePolicy}")
    println(s"[Config] Port: $port")

    // Keep the Chisel simulation alive for the
    // entire lifetime of the TCP server.
    RawTester.test(new SetAssociativeCache(config)) { dut =>

      println("[Hardware] Cache initialized")

      val simulator = new CacheSimulator(dut, config)

      val server = new CacheServer(
        port = port,
        simulator = simulator
      )

      Runtime.getRuntime.addShutdownHook(
        new Thread(() => {
          println("\n[Main] Shutdown requested")
          server.stop()
        })
      )

      server.start()
    }
  }
}
