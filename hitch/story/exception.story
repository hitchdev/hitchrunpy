Exceptions:
  about: |
    When python code snippets raise exceptions, those
    can be expected by the code or unexpected.

    If unexpected they will raise an exception.
  docs: exceptions
  based on: hitchrunpy
  variations:
    Occurs as expected:
      steps:
      - Run:
          code: |
            result = pyrunner.with_code("""

            class CustomException(Exception):
                pass

            raise CustomException('This should hâppen')

            """).expect_exceptions().run()

            result.exception_was_raised("__main__.CustomException")

            assert result.exception.message == "This should hâppen"
            assert result.exception.exception_type == "__main__.CustomException"

    Different to expected exception:
      steps:
      - Run:
          code: |
            result = pyrunner.with_code("""

            class AnotherCustomException(Exception):
                pass

            raise AnotherCustomException('This should happen')

            """).expect_exceptions().run()

            result.exception_was_raised("__main__.CustomException")
          raises:
            type: hitchrunpy.exceptions.ExpectedExceptionWasDifferent
            message: "Expected exception '__main__.CustomException', instead '__main__.AnotherCustomException'\
              \ was raised:\n\n[0]: function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'\n\
              \  /path/to/code/working/examplepythoncode.py\n\n\n        67 :\n  \
              \      68 :\n    --> [[ BRIGHT ]]69[[ RESET ALL ]] :     run_example_code()\n\
              \        70 : except Exception as error:\n\n\n\n[1]: function '[[ BRIGHT\
              \ ]]run_example_code[[ RESET ALL ]]'\n  /path/to/code/working/examplepythoncode.py\n\
              \n\n        63 :\n        64 :\n    --> [[ BRIGHT ]]65[[ RESET ALL ]]\
              \ :         runcode()\n        66 :\n\n\n\n[2]: function '[[ BRIGHT\
              \ ]]runcode[[ RESET ALL ]]'\n  /path/to/code/working/examplepythoncode.py\n\
              \n\n        58 :                             pass\n        59 :\n  \
              \  --> [[ BRIGHT ]]60[[ RESET ALL ]] :                         raise\
              \ AnotherCustomException('This should happen')\n        61 :\n\n\n\n\
              [[ RED ]][[ BRIGHT ]]__main__.AnotherCustomException[[ RESET ALL ]]\n\
              \  [[ DIM ]][[ RED ]]None[[ RESET ALL ]]\n[[ RED ]]This should happen[[\
              \ RESET FORE ]]"
    Expect any kind of exception:
      steps:
      - Run:
          code: |
            result = pyrunner.with_code("""

            raise Exception(u"ân exception")

            """).expect_exceptions().run()

            result.exception_was_raised()


    No exception occurs when expected:
      steps:
      - Run:
          code: |
            result = pyrunner.with_code("pass").expect_exceptions().run()

            result.exception_was_raised("__main__.CustomException")
          raises:
            type: hitchrunpy.exceptions.ExpectedExceptionButNoExceptionOccurred
            message: |
              Expected exception '__main__.CustomException', but no exception occurred.


    Expected raised but with different message:
      steps:
      - Run:
          code: |
            result = pyrunner.with_code("""

            class CustomException(Exception):
                pass

            raise CustomException('This was not\\nthe expected messâge.')

            """).expect_exceptions().run()

            result.exception_was_raised("__main__.CustomException", 'This was\nthe expected messâge')
          raises:
            type: hitchrunpy.exceptions.ExpectedExceptionMessageWasDifferent
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




