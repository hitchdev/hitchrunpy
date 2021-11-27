
---
title: Run with environment variables
type: using
---



Environment variables within the running python
snippets can be overridden or set by using .with_env.





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
pyrunner.with_env(MYVAR="myenvironmentvar").with_code((
    'import os\n'
    '\n'
    'with open("examplefile", "w") as handle:\n'
    '     handle.write(os.environ["MYVAR"])\n'
)).run()

```






Then the file "working/examplefile" in the working dir will contain:

```
myenvironmentvar
```







{{< note title="Executable specification" >}}
Page automatically generated from <a href="https://github.com/hitchdev/hitchstory/blob/master/hitch/environment-vars.story">environment-vars.story</a>.
{{< /note >}}
