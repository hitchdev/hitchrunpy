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
            message: |-
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




