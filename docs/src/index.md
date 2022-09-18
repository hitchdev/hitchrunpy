{% if readme -%}
# HitchRunPy

[![Main branch status](https://github.com/hitchdev/hitchrunpy/actions/workflows/regression.yml/badge.svg)](https://github.com/hitchdev/hitchrunpy/actions/workflows/regression.yml)
{%- else -%}
---
title: HitchRunPy
---

{% raw %}
<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/hitchdev/hitchrunpy?style=social"> 
<img alt="PyPI - Downloads" src="https://img.shields.io/pypi/dm/hitchrunpy">
{% endraw %}

{% endif %}

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

{% for dirfile in (subdir("using/alpha/").ext("md") - subdir("using/alpha/").named("index.md"))|sort() -%}
- [{{ title(dirfile) }}](using/alpha/{{ dirfile.name.splitext()[0] }})
{% endfor %}


## Why use HitchRunPy?

HitchRunPy combined with HitchStory serves as an effective replacement for unit tests
in the situation where unit tests are most effective.
