---
title: HitchRunPy
---


<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/hitchdev/hitchrunpy?style=social"> 
<img alt="PyPI - Downloads" src="https://img.shields.io/pypi/dm/hitchrunpy">




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

- [CProfile](using/alpha/cprofile)
- [Run with environment variables](using/alpha/environment-vars)
- [Exceptions](using/alpha/exceptions)
- [Interact with running code](using/alpha/interact-with-running-code)
- [Setup code](using/alpha/setup-code)
- [Error occurred](using/alpha/syntax-errors)
- [Timeout](using/alpha/timeout)
- [Use modules](using/alpha/variables)



## Why use HitchRunPy?

HitchRunPy combined with HitchStory serves as an effective replacement for unit tests
in the situation where unit tests are most effective.