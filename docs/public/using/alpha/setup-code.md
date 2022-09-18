
---
title: Setup code
---








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
pyrunner.with_code((
    'with open("examplefile", "w") as handle:'
    '     handle.write(exampletext)'
)).with_setup_code("exampletext = 'exampletext'")\
  .run()

```






Then the file "examplefile" in the working dir will contain:

```
exampletext
```








!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/basic.story">basic.story</a>
    storytests.

