
---
title: CProfile
---



Code snippets run by hitchrunpy can be
profiled with cprofile.


"long_string" is set to:

```
def do_calculation(number):
    x = i^i

for i in range(0, 5000 * 1000):
    do_calculation(i)

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
pyrunner.with_cprofile("profiledata.dat").with_code(long_string).run()

import pstats

data = pstats.Stats("profiledata.dat").sort_stats('cumulative')
data.calc_callees()

```










!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/cprofile.story">cprofile.story</a>
    storytests.

