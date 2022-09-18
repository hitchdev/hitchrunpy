
---
title: Include files
---



This example shows how to include files which can be
used as e.g. modules to import or text files to read accessible
in the working directory.





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
CODE = """
from write_file import write_to_file

write_to_file()
"""

pyrunner.with_code(CODE).include_files("../differentdirectory/write_file.py").run()

```






Then the file "examplefile" in the working dir will contain:

```
â string of some kind
```








!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/include-files.story">include-files.story</a>
    storytests.

