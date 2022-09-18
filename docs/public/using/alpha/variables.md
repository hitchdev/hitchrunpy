
---
title: Use modules
---



This example shows how to feed variables containing
strings to your running code.





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
some_string = u"â string of some kind"

pyrunner.with_code((
    "from write_to_file import write_text\n"
    "write_text()"
)).with_modules(f"{BUILD_DIR}/state/write_to_file.py").run()

```






Then the file "examplefile" in the working dir will contain:

```
â string of some kind
```








!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/with-modules.story">with-modules.story</a>
    storytests.

