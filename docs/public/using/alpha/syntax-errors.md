
---
title: Error occurred
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
pyrunner.with_code('''x =''').run()

```


```python
hitchrunpy.exceptions.ErrorRunningCode:
Error running code. Output:

  File "/path/to/working/examplepythoncode.py", line 56
    x =
      ^
SyntaxError: invalid syntax
```










!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/basic.story">basic.story</a>
    storytests.

