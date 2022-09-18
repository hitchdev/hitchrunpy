# HitchRunPy

[![Main branch status](https://github.com/hitchdev/hitchrunpy/actions/workflows/regression.yml/badge.svg)](https://github.com/hitchdev/hitchrunpy/actions/workflows/regression.yml)

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

```sh
$ pip install hitchstory
```

## Using HitchRunPy

- [CProfile](https://hitchdev.com/hitchrunpy/using/alpha/cprofile)
- [Run with environment variables](https://hitchdev.com/hitchrunpy/using/alpha/environment-vars)
- [Exceptions](https://hitchdev.com/hitchrunpy/using/alpha/exceptions)
- [Include files](https://hitchdev.com/hitchrunpy/using/alpha/include-files)
- [Interact with running code](https://hitchdev.com/hitchrunpy/using/alpha/interact-with-running-code)
- [Setup code](https://hitchdev.com/hitchrunpy/using/alpha/setup-code)
- [Error occurred](https://hitchdev.com/hitchrunpy/using/alpha/syntax-errors)
- [Timeout](https://hitchdev.com/hitchrunpy/using/alpha/timeout)
- [Use modules](https://hitchdev.com/hitchrunpy/using/alpha/variables)



## Why use HitchRunPy?

HitchRunPy combined with HitchStory serves as an effective replacement for unit tests
in the situation where unit tests are most effective.