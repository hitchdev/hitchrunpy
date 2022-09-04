
---
title: Error occurred
---








```python
from hitchrunpy import ExamplePythonCode
from ensure import Ensure
import hitchbuildpy
import hitchbuild

virtualenv = hitchbuildpy.VirtualenvBuild(
    name="py3.7",
    base_python=hitchbuildpy.PyenvBuild("3.7").with_build_path(
        '/path/to/share_dir/'
    ),
).with_build_path("/path/to/build_dir/")

virtualenv.ensure_built()

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

  File "/path/to/code/working/examplepythoncode.py", line 56
    x =
      ^
SyntaxError: invalid syntax
```










!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/basic.story">basic.story</a>
    storytests.
