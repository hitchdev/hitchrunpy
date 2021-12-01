
---
title: Timeout
---



If the python code snippets you are running
encounter a very very long loop or infinite, you
can get it to time out.


"long_string" is set to:

```
import time
time.sleep(3)

```



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
pyrunner.with_code(long_string).with_timeout(1.0).run()
```


```python
hitchrunpy.exceptions.PythonTimeout:
Timed out waiting for exit.
```










!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/timeout.story">timeout.story</a>
    storytests.

