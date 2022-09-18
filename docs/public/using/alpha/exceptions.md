
---
title: Exceptions
---



When python code snippets raise exceptions, those
can be expected by the code or unexpected.

If unexpected they will raise an exception.





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




Occurs as expected:




```python
result = pyrunner.with_code("""

class CustomException(Exception):
    pass

raise CustomException('This should hâppen')

""").expect_exceptions().run()

result.exception_was_raised("__main__.CustomException")

assert result.exception.message == "This should hâppen"
assert result.exception.exception_type == "__main__.CustomException"

```






Different to expected exception:




```python
result = pyrunner.with_code("""

class AnotherCustomException(Exception):
    pass

raise AnotherCustomException('This should happen')

""").expect_exceptions().run()

result.exception_was_raised("__main__.CustomException")

```


```python
hitchrunpy.exceptions.ExpectedExceptionWasDifferent:
Expected exception '__main__.CustomException', instead '__main__.AnotherCustomException' was raised:

[0]: function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'
  /path/to/working/examplepythoncode.py


        67 :
        68 :
    --> [[ BRIGHT ]]69[[ RESET ALL ]] :     run_example_code()
        70 : except Exception as error:



[1]: function '[[ BRIGHT ]]run_example_code[[ RESET ALL ]]'
  /path/to/working/examplepythoncode.py


        63 :
        64 :
    --> [[ BRIGHT ]]65[[ RESET ALL ]] :         runcode()
        66 :



[2]: function '[[ BRIGHT ]]runcode[[ RESET ALL ]]'
  /path/to/working/examplepythoncode.py


        58 :                             pass
        59 :
    --> [[ BRIGHT ]]60[[ RESET ALL ]] :                         raise AnotherCustomException('This should happen')
        61 :



[[ RED ]][[ BRIGHT ]]__main__.AnotherCustomException[[ RESET ALL ]]
  [[ DIM ]][[ RED ]]None[[ RESET ALL ]]
[[ RED ]]This should happen[[ RESET FORE ]]
```






Expect any kind of exception:




```python
result = pyrunner.with_code("""

raise Exception(u"ân exception")

""").expect_exceptions().run()

result.exception_was_raised()

```






No exception occurs when expected:




```python
result = pyrunner.with_code("pass").expect_exceptions().run()

result.exception_was_raised("__main__.CustomException")

```


```python
hitchrunpy.exceptions.ExpectedExceptionButNoExceptionOccurred:
Expected exception '__main__.CustomException', but no exception occurred.

```






Expected raised but with different message:




```python
result = pyrunner.with_code("""

class CustomException(Exception):
    pass

raise CustomException('This was not\\nthe expected messâge.')

""").expect_exceptions().run()

result.exception_was_raised("__main__.CustomException", 'This was\nthe expected messâge')

```


```python
hitchrunpy.exceptions.ExpectedExceptionMessageWasDifferent:
Expected exception '__main__.CustomException' was raised, but message was different.

ACTUAL:
This was not
the expected messâge.

EXPECTED:
This was
the expected messâge
DIFF:
- This was not
?         ----
+ This was
- the expected messâge.?                     -
+ the expected messâge
```











!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchrunpy/blob/master/hitch/story/exception.story">exception.story</a>
    storytests.

