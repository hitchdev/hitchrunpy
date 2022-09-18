
---
title: Run with environment variables
---



Environment variables within the running python
snippets can be overridden or set by using .with_env.





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
pyrunner.with_env(MYVAR="myenvironmentvar").with_code((
    'import os\n'
    '\n'
    'with open("examplefile", "w") as handle:\n'
    '     handle.write(os.environ["MYVAR"])\n'
)).run()

```






Then the file "examplefile" in the working dir will contain:

```
myenvironmentvar
```








!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/environment-vars.story">environment-vars.story</a>
    storytests.

