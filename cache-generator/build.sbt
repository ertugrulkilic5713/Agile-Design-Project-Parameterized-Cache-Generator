ThisBuild / scalaVersion := "2.13.16"

val chiselVersion = "6.7.0"

scalacOptions ++= Seq(
  "-deprecation",
  "-feature",
  "-unchecked",
  "-language:reflectiveCalls"
  // "-Xfatal-warnings"
)

addCompilerPlugin(
  "org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full
)

libraryDependencies ++= Seq(
  "org.chipsalliance" %% "chisel" % chiselVersion,
  "edu.berkeley.cs" %% "chiseltest" % "6.0.0" % Test,
  "org.scalatestplus" %% "scalacheck-1-18" % "3.2.19.0" % Test
)

// Causes include issues, compilation runs into errors because of 
// version 2.something, best to just copy the files over which from the
// license is permitted under BSD-2
// libraryDependencies += ("io.github.t-crest" % "soc-comm" % "0.1.5")
//   .excludeAll(ExclusionRule(organization = "edu.berkeley.cs"))
//   .excludeAll(ExclusionRule(organization = "org.scalatest"))
