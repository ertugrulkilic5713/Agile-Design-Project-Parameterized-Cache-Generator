scalaVersion := "2.13.16"
val chiselVersion = "6.7.0"
scalacOptions ++= Seq("-feature", "-language:reflectiveCalls")
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
libraryDependencies ++= Seq(
  "org.chipsalliance" %% "chisel" % chiselVersion,
  // SerialSpiDriver includes a simulation driver in its main sources.
  "edu.berkeley.cs" %% "chiseltest" % "6.0.0",
  "net.fornwall" % "jelf" % "0.9.0",
  "com.fazecast" % "jSerialComm" % "[2.0.0,3.0.0)"
)

Compile / unmanagedSourceDirectories ++= Seq(
  baseDirectory.value / "soc-comm/src/main/scala",
  baseDirectory.value / "ip-contributions/src/main/scala"
)

lazy val cacheGenerator = RootProject(file("../../cache-generator").toURI)
lazy val wildcat = (project in file(".")).dependsOn(cacheGenerator)

Test / parallelExecution := false
name := "wildcat"
fork := true
connectInput := true
