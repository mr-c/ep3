# Ep3: Extremely Pluggable Pipeline Processor

[![Actions Status](https://badgen.net/github/checks/tom-tan/ep3/master?icon=commonwl)](https://github.com/tom-tan/ep3/actions)
[![license](https://badgen.net/github/license/tom-tan/ep3)](https://github.com/tom-tan/ep3/blob/master/LICENSE)

This is a workflow engine for the [Common Workflow Language](https://www.commonwl.org) which aims to have a pluggable architecture.

## Conformance tests for CWL v1.0
ep3 version: ![commit](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/commit.json)
### Classes
[![CommandLineTool](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/command_line_tool.json?icon=commonwl)](https://www.commonwl.org/v1.0/CommandLineTool.html) [![ExpressionTool](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/expression_tool.json?icon=commonwl)](https://www.commonwl.org/v1.0/Workflow.html#ExpressionTool) [![Workflow](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/workflow.json?icon=commonwl)](https://www.commonwl.org/v1.0/Workflow.html)

### Required features
[![Required](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/required.json?icon=commonwl)](https://www.commonwl.org/v1.0/)

### Optional features
[![DockerRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/docker.json?icon=commonwl)](https://www.commonwl.org/v1.0/CommandLineTool.html#DockerRequirement) [![EnvVarRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/env_var.json?icon=commonwl)](https://www.commonwl.org/v1.0/CommandLineTool.html#EnvVarRequirement) [![InitialWorkDirRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/initial_work_dir.json?icon=commonwl)](https://www.commonwl.org/v1.0/CommandLineTool.html#InitialWorkDirRequirement) [![InlineJavascriptRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/inline_javascript.json?icon=commonwl)](https://www.commonwl.org/v1.0/CommandLineTool.html#InlineJavascriptRequirement) [![MultipleInputFeatureRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/multiple_input.json?icon=commonwl)](https://www.commonwl.org/v1.0/Workflow.html#MultipleInputFeatureRequirement) [![ResourceRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/resource.json?icon=commonwl)](https://www.commonwl.org/v1.0/CommandLineTool.html#ResourceRequirement) [![ScatterFeatureRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/scatter.json?icon=commonwl)](https://www.commonwl.org/v1.0/Workflow.html#ScatterFeatureRequirement) [![SchemaDefRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/schema_def.json?icon=commonwl)](https://www.commonwl.org/v1.0/CommandLineTool.html#SchemaDefRequirement) [![ShellCommandRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/shell_command.json?icon=commonwl)](https://www.commonwl.org/v1.0/CommandLineTool.html#ShellCommandRequirement) [![StepInputExpressionRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/step_input.json?icon=commonwl)](https://www.commonwl.org/v1.0/Workflow.html#StepInputExpressionRequirement) [![SubworkflowFeatureRequirement](https://badgen.net/https/raw.githubusercontent.com/tom-tan/conformance/master/conformance/ep3/cwl_v1.0/ep3_latest/subworkflow.json?icon=commonwl)](https://www.commonwl.org/v1.0/Workflow.html#SubworkflowFeatureRequirement)

Notes:
- ep3 will not pass the test #61 with `required` and `command_line_tool` tags due to [common-workflow-language#761](https://github.com/common-workflow-language/common-workflow-language/issues/761).
- The conformance badge for [SoftwareRequirement](https://www.commonwl.org/v1.0/CommandLineTool.html#SoftwareRequirement) is not available because there are no conformance tests for this feature.
- Currently `ScatterFeatureRequirement` (`scatter` tag) and `StepInputExpressionRequirement` (`step_input` tag) are not supported.
  - It affects the result of the tests of `Workflow` (`workflow` tag), `InlineJavascriptRequirement` (`inline_javascript` tag), `MultipleInputFeatureRequirement` (`multiple_input` tag) and `SubworkflowFeatureRequirement` (`subworkflow` tag).

## Requirements
- [medal](https://github.com/tom-tan/medal)
- [Ruby](https://www.ruby-lang.org) 2.5.1 or later
- [Fluentd](https://www.fluentd.org) 1.3.3 or later
- [jq](https://stedolan.github.io/jq/)
- [nodejs](https://nodejs.org) for `InlineJavascriptRequirement`

## How to install
- Install `medal`, `jq`, `ruby`, `nodejs`, and `fluentd`
- Execute the following commands and add `/path/to/ep3` to `$PATH`.
```console
$ git clone --recursive https://github.com/tom-tan/ep3.git
```

## Usage
See `ep3-runner --help` for details.
```console
$ ep3-runner <cwl> [job]
```
It prints the log and debug outputs to stderr and prints the output object to stdout. Both types of outputs are printed in [JSON Lines](http://jsonlines.org) format.

Here is an example:
```console
$ ep3-runner --quiet /path/to/ep3/examples/workflow.cwl /path/to/ep3/examples/inputs.yml | jq .
{
  "output": {
    "class": "File",
    "location": "file:///current/directory/output",
    "path": "/current/directory/output",
    "basename": "output",
    "dirname": "/current/directory",
    "nameroot": "output",
    "nameext": "",
    "checksum": "sha1$c28e458d4e943c743b9b3c46fdab10688a6d68b6",
    "size": 687
  }
}
```

## For developers
### How to test
```console
$ git clone --recursive https://github.com/tom-tan/ep3.git
$ cd ep3
$ cwltest --tool $PWD/ep3-runner --test test.yml
Test [1/1] Workflow example
All tests passed
```

### ep3 internals
The `ep3-runner` command consists of the following internal commands:
- `ep3 init`
  - Generates shell scripts that calls `entr`s for the given CWL
- `ep3 run`
  - Executes generated scripts and start processing a workflow
- `ep3 list`
  - Shows the output object for execution result
- `ep3 resume` (Unimplemented)
- `ep3 stop` (Unimplemented)

### About `checks` badge
The `checks` badge represents the CI result of the latest commit in master branch.

- ![success](https://badgen.net/badge/checks/success/green?icon=commonwl)
  - It passes the basic test. The CI runner also runs the conformance test for this commit. The [section of conformance test](#conformance-test-for-cwl-v10) will show the result of the conformance test with the latest successful commit of ep3.
- ![failure](https://badgen.net/badge/checks/failure/red?icon=commonwl)
  - It does not pass the basic test. The CI runner skips the conformance test for this commit because it does not work with the most or all the CWL documents.
