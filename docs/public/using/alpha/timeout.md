
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

