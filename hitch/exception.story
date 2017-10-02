Exception occurs as expected:
  based on: hitchrunpy
  preconditions:
    code: |
      result = pyrunner.with_code("""

      class CustomException(Exception):
          pass

      raise CustomException('This should hâppen')

      """).expect_exceptions().run()

      result.exception_was_raised("__main__.CustomException", "This should hâppen")
  scenario:
  - Run code

Expected exception was different:
  based on: hitchrunpy
  preconditions:
    code: |
      result = pyrunner.with_code("""

      class AnotherCustomException(Exception):
          pass

      raise AnotherCustomException('This should happen')

      """).expect_exceptions().run()

      result.exception_was_raised("__main__.CustomException", "This should hâppen")
  scenario:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.ExpectedExceptionWasDifferent
      message: "Expected exception '__main__.CustomException', instead '__main__.AnotherCustomException'\
        \ was raised:\n\n[0]: function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'\n  examplepythoncode.py\n\
        \n    \n        62 :         hitchbuild.BuildPath(build=\"/path/to/code\"\
        , share=\"/path/to/share\"),\n        63 :     )\n    --> [[ BRIGHT ]]64[[\
        \ RESET ALL ]] :     \n        65 :     bundle['python3.5.0'] = hitchbuildpy.PythonBuild(\"\
        3.5.0\")\n    \n    \n\n[[ RED ]][[ BRIGHT ]]__main__.AnotherCustomException[[\
        \ RESET ALL ]]\n  [[ DIM ]][[ RED ]]None[[ RESET ALL ]]\n[[ RED ]]This should\
        \ happen[[ RESET FORE ]]"

Expect exception with no details:
  based on: hitchrunpy
  preconditions:
    code: |
      result = pyrunner.with_code("""

      raise Exception(u"ân exception")

      """).expect_exceptions().run()

      result.exception_was_raised()
  scenario:
  - Run code


Expected exception but no exception occurred:
  based on: hitchrunpy
  preconditions:
    code: |
      result = pyrunner.with_code("""

      pass

      """).expect_exceptions().run()

      result.exception_was_raised("__main__.CustomException", "This should hâppen")
  scenario:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.ExpectedExceptionButNoExceptionOccurred
      message: |
        Expected exception '__main__.CustomException', but no exception occurred.


Expected exception has different message:
  based on: hitchrunpy
  preconditions:
    code: |
      result = pyrunner.with_code("""

      class CustomException(Exception):
          pass

      raise CustomException('This was not\\nthe expected messâge.')

      """).expect_exceptions().run()

      result.exception_was_raised("__main__.CustomException", 'This was\nthe expected messâge')
  scenario:
  - Raises Exception:
      exception_type: hitchrunpy.exceptions.ExpectedExceptionMessageWasDifferent
      message: |-
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




