
---
title: Setup code
type: using
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
pyrunner.with_code((
    'with open("examplefile", "w") as handle:'
    '     handle.write(exampletext)'
)).with_setup_code("exampletext = 'exampletext'")\
  .run()

```






Then the file "working/examplefile" in the working dir will contain:

```
exampletext
```







{{< note title="Executable specification" >}}
Page automatically generated from <a href="https://github.com/hitchdev/hitchstory/blob/master/hitch/basic.story">basic.story</a>.
{{< /note >}}
