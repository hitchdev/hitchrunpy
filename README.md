# HitchRunPy

HitchRunPy is a tool to run, test and profile snippets of python code.

HitchRunPy was developed to run executable specifications
using [HitchStory](https://hitchdev.com/hitchstory) that define
Python APIs.

As such it can be used with HitchStory to build effective replacements
for unit tests and integration tests where the 'spec' is a python API.

HitchRunPy is used to run the executable specifications for all libraries
on [HitchDev](https://hitchdev.com/).

## Example


```python
from hitchrunpy import ExamplePythonCode

ExamplePythonCode(
    '/path/to/bin/python',
    '/path/to/working_directory',
).with_code((
    'with open("examplefile", "w") as handle:'
    '     handle.write("exampletext")'
)).run()
```


## Install

Hitchstory is designed to be used mainly with hitchkey and hitchstory. [ TODO set up ]

However, hitchrunpy can also be installed directly from pypi using pip.

```sh
$ pip install hitchstory
```

## Using HitchRunPy

- [Error occurred](https://hitchdev.com/hitchrunpy/using/alpha/syntax-errors)
- [Exceptions](https://hitchdev.com/hitchrunpy/using/alpha/exceptions)
- [Run with environment variables](https://hitchdev.com/hitchrunpy/using/alpha/environment-vars)
- [Feed string variables to code](https://hitchdev.com/hitchrunpy/using/alpha/variables)
- [CProfile](https://hitchdev.com/hitchrunpy/using/alpha/cprofile)
- [Timeout](https://hitchdev.com/hitchrunpy/using/alpha/timeout)
- [Interact with running code](https://hitchdev.com/hitchrunpy/using/alpha/interact-with-running-code)
- [Setup code](https://hitchdev.com/hitchrunpy/using/alpha/setup-code)



## Why use HitchRunPy?

HitchRunPy combined with HitchStory serves as an effective replacement for unit tests
in the situation where unit tests are most effective.