
scalacOptions ++= Seq(
  "-feature",
  "-language:reflectiveCalls",
)

Compile / unmanagedSourceDirectories ++= Seq(baseDirectory.value / "soc-comm/src/main/scala",baseDirectory.value / "ip-contributions/src/main/scala")

// Chisel 3.5
/*
scalaVersion := "2.13.10"
addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.5.6" cross CrossVersion.full)
libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.5.6"
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.5.6"
libraryDependencies += "edu.berkeley.cs" % "ip-contributions" % "0.5.4"
*/


scalaVersion := "2.13.16"
val chiselVersion = "6.7.0"
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
libraryDependencies ++= Seq("org.chipsalliance" %% "chisel" % chiselVersion, "edu.berkeley.cs" %% "chiseltest" % "6.0.0")

/*
libraryDependencies += "edu.berkeley.cs" % "ip-contributions" % "0.6.1"
*/

/*
scalaVersion := "2.13.14"
val chiselVersion = "5.3.0"
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "5.0.2"
*/

/*
scalaVersion := "2.13.14"
val chiselVersion = "6.7.0"
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "6.0.0"
*/

/*
scalaVersion := "2.13.16"
val chiselVersion = "7.13.0"
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion
// libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "6.0.0"
*/

libraryDependencies += "net.fornwall" % "jelf" % "0.9.0"
libraryDependencies += "com.fazecast" % "jSerialComm" % "[2.0.0,3.0.0)"

lazy val cacheGenerator = RootProject(file("../cache-generator").toURI)

lazy val wildcat = (project in file(".")).dependsOn(cacheGenerator)

// because I am reusing a.out -- should go with a change in compilation
Test / parallelExecution := false

// library name
name := "wildcat"

// Enable colors in the terminal
fork := true
connectInput := true
