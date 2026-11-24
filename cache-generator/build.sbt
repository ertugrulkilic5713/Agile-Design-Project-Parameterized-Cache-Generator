ThisBuild / scalaVersion := "2.13.16"

// for local publishing, required for visualizer
ThisBuild / organization := "io.github.berspitze"
ThisBuild / version := "0.1.0-SNAPSHOT"
name := "parameterized-cache-generator"

val chiselVersion = "6.7.0"

scalacOptions ++= Seq(
  "-deprecation",
  "-feature",
  "-unchecked",
  "-language:reflectiveCalls"
  // "-Xfatal-warnings"
)

addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)

libraryDependencies ++= Seq(
  "org.chipsalliance" %% "chisel" % chiselVersion,
  // chiseltest is used by the TCP cache server (RawTester) as well as by the tests,
  // so it lives in the compile scope instead of the test scope.
  "edu.berkeley.cs" %% "chiseltest" % "6.0.0",
  "org.scalatestplus" %% "scalacheck-1-18" % "3.2.19.0" % Test
)

// `sbt run` starts the TCP cache server by default. Verilog generation is still
// available through `sbt "runMain cache.GenerateCache [ways] [output-dir]"`.
Compile / run / mainClass := Some("cache.server.CacheServer")
