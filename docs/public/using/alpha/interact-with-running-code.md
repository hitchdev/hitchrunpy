
---
title: Interact with running code
---



If you need to test code asynchronously or interact
with it in a terminal window, you can use .running_code()
to get a RunningCode object.

From the RunningCode object you can use .iprocess to
get an [icommandlib iprocess object](https://github.com/crdoconnor/icommandlib).


"long_string" is set to:

```
import sys
import time

answer = input("favorite color:")

with open("color.txt", "w") as handle:
    handle.write(answer)

answer = input("favorite movie:")

with open("movie.txt", "w") as handle:
    handle.write(answer)

time.sleep(0.5)
sys.exit(0)

```



```python
from hitchrunpy import ExamplePythonCode
from ensure import Ensure
import hitchbuildpy
import hitchbuild

BUILD_DIR = "/path/to/build_dir/.."

virtualenv = hitchbuildpy.VirtualenvBuild(
    "/path/to/build_dir/../py3.7",
    base_python=hitchbuildpy.PyenvBuild(
        '/path/to/share_dir/../pyenv3.7',
        "3.7",
    ),
)

virtualenv.verify()

pyrunner = ExamplePythonCode(
    virtualenv.bin.python,
    '/path/to/working_dir',
)

```






```python
running_code = pyrunner.with_code(long_string).with_terminal_size(10, 10).running_code()

assert not running_code.finished

running_code.iprocess.wait_until_output_contains("favorite color:")
running_code.iprocess.send_keys("red\n")
running_code.iprocess.wait_until_output_contains("favorite movie:")
running_code.iprocess.send_keys("the usual suspects\n")
running_code.iprocess.wait_for_finish()

with open("screenshot.txt", 'w') as handle:
    handle.write(running_code.iprocess.stripshot())

assert running_code.finished

```






Then the file "screenshot.txt" written by the code will contain:

```
favorite c
olor:red
favorite m
ovie:the u
sual suspe
cts
```








!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/running-code.story">running-code.story</a>
    storytests.

