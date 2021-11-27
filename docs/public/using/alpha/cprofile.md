
---
title: CProfile
type: using
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
pyrunner.with_cprofile("profiledata.dat").with_code(long_string).run()

import pstats

data = pstats.Stats("profiledata.dat").sort_stats('cumulative')
data.calc_callees()

```









{{< note title="Executable specification" >}}
Page automatically generated from <a href="https://github.com/hitchdev/hitchstory/blob/master/hitch/cprofile.story">cprofile.story</a>.
{{< /note >}}
