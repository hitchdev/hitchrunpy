Exception occurs as expected:
  based on: hitchrunpy
  preconditions:
    code: |
      result = ExamplePythonCode("""

      class CustomException(Exception):
          pass

      raise CustomException('This should happen')

      """).expect_exceptions().run(working_dir, python)

      result.exception_was_raised("__main__.CustomException", "This should happen")
  scenario:
  - Run code

#Exception matches lambda:
  #based on: hitchrunpy
  #preconditions:
    #code: |
      #ExamplePythonCode("""
      #class CustomException(Exception):
          #pass

      #raise CustomException('This should happen')
      #""").expect_exception(
          #exception_type="__main__.CustomException",
          #match_function=lambda exception: exception.message == "This should happen"
      #)\
          #.run(working_dir, python)
  #scenario:
    #- Run code


#Exception does not match lambda:
  #based on: hitchrunpy
  #preconditions:
    #code: |
      #ExamplePythonCode("""
      #class CustomException(Exception):
          #pass

      #raise CustomException('This should happen')
      #""").expect_exception(
          #exception_type="__main__.CustomException",
          #match_function=lambda exception: exception.message == "Message is different"
      #)\
          #.run(working_dir, python)
  #scenario:
    #- Raises Exception:
        #exception type: hitchrunpy.exceptions.ExceptionDoesNotMatchFunction
        #message: |
          #Exception '__main__.CustomException' did not match function supplied. Message:
          #This should happen



Expected exception was different:
  based on: hitchrunpy
  preconditions:
    code: |
      result = ExamplePythonCode("""

      class AnotherCustomException(Exception):
          pass

      raise AnotherCustomException('This should happen')

      """).expect_exceptions().run(working_dir, python)

      result.exception_was_raised("__main__.CustomException", "This should happen")
  scenario:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.ExpectedExceptionWasDifferent
      message: |
        Expected exception '__main__.CustomException', instead '__main__.AnotherCustomException' was raised:
        This should happen


Expect exception with no details:
  based on: hitchrunpy
  preconditions:
    code: |
      result = ExamplePythonCode("""

      raise Exception()

      """).expect_exceptions().run(working_dir, python)

      result.exception_was_raised()
  scenario:
  - Run code


Expected exception but no exception occurred:
  based on: hitchrunpy
  preconditions:
    code: |
      result = ExamplePythonCode("""

      pass

      """).expect_exceptions().run(working_dir, python)

      result.exception_was_raised("__main__.CustomException", "This should happen")
  scenario:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.ExpectedExceptionButNoExceptionOccurred
      message: |
        Expected exception '__main__.CustomException', but no exception occurred.


Expected exception has different message:
  based on: hitchrunpy
  preconditions:
    code: |
      result = ExamplePythonCode("""

      class CustomException(Exception):
          pass

      raise CustomException('This was not\\nthe expected message.')

      """).expect_exceptions().run(working_dir, python)

      result.exception_was_raised("__main__.CustomException", 'This was\nthe expected message')
  scenario:
  - Raises Exception:
      exception_type: hitchrunpy.exceptions.ExpectedExceptionMessageWasDifferent
      message: |
        Expected exception '__main__.CustomException' was raised, but message was different.

        ACTUAL:
        This was not
        the expected message.

        EXPECTED:
        This was
        the expected message
        DIFF:
        - This was not
        ?         ----
        + This was
        - the expected message.?                     -
        + the expected message




