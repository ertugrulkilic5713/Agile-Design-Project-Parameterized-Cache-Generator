# Agile-Design-Project-Parameterized-Cache-Generator
This project implements a parameterizable optimized set associative cache using generic types in Chisel design software.

## Tests and continuous integration

Run the complete standalone cache suite from the repository root:

```bash
cd cache-generator
sbt -batch test
```

Run the self-contained CPU suites from the repository root:

```bash
cd wildcat
sbt -batch "testOnly wildcat.RegisterFileTest wildcat.DataMemoryStallTest"
```

Wildcat depends on the shared `cache-generator` project. Its compilation uses
that implementation, but sbt does not run dependency projects' tests automatically.
The [GitHub Actions workflow](.github/workflows/test.yml) therefore runs both
commands in separate jobs on every push and pull request, using Java 17 and
sbt 1.10.7. Dependencies are cached between runs.
You can also start it manually using **Actions → Cache and CPU tests → Run workflow**
once the workflow is on the default branch.

Commit and push the workflow together with the shared-cache build changes.
Local commits trigger CI only after they are pushed to GitHub.
Check results in the repository's **Actions** tab or the pull request's checks;
test reports are available as the `test-reports` and `cpu-test-reports` artifacts.
To require passing tests before merging, require both **Scala / Chisel tests**
and **CPU unit tests** in your branch protection rule or ruleset.

The CPU job covers all three register-file variants and ThreeCats waiting for a
delayed data-memory acknowledgement. It does not yet cover the CPU connected to
the write-back cache: `CacheAdapterSpec` awaits the adapter's updated interface.
The assembly/simulator suites that need `risc-v-lab` and RISC-V tools are also
outside this job. A green workflow verifies these documented suites, not the
complete hardware integration.

<p align="center">
  <img src="images/FSM/CH_CONTROLLER_FSM_V1.drawio.svg" width="600" alt="Cache Controller High-Level FSM Diagram."
</p>

<p align="center">
  <img src="images/ASM/CH_CONTROLLER_ASM_V1.drawio.svg" width="600" alt="Cache Controller High-Level ASM Diagram."
</p>
