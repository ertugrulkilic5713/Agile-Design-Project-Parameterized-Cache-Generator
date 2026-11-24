ThisBuild / scalaVersion := "2.13.16"   // match the library
ThisBuild / organization := "io.github.berspitze"
ThisBuild / version      := "0.1.0-SNAPSHOT"

lazy val root = (project in file("."))
  .settings(
    name := "cache-visualizer-hardware",

    resolvers += Resolver.defaultLocal,

    libraryDependencies ++= Seq(
      "io.github.berspitze" %% "parameterized-cache-generator" % "0.1.0-SNAPSHOT"
    ),

    Compile / run / fork := true
  )
