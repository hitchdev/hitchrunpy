Unexpected exception:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode("""

      raise Exception('This should not happen')
      
      """).run(working_dir, python)
  scenario:
    - Raises exception: This should not happen

Exception occurs as expected:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode("""
      
      class CustomException(Exception):
          pass

      raise CustomException('This should happen')
      
      """).expect_exception("__main__.CustomException", "This should happen").run(working_dir, python)
  scenario:
    - Run code


Expected exception was different:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode("""
      
      class AnotherCustomException(Exception):
          pass

      raise AnotherCustomException('This should happen')
      
      """).expect_exception("__main__.CustomException", "This should happen").run(working_dir, python)
  scenario:
    - Raises Exception: |
        Expected exception '__main__.CustomException', instead '__main__.AnotherCustomException' was raised.

        

Expected exception has different message:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode("""
      
      class CustomException(Exception):
          pass

      raise CustomException('This was not\\nthe expected message.')
      
      """).expect_exception("__main__.CustomException", 'This was\nthe expected message').run(working_dir, python)
  scenario:
    - Raises Exception: |
        Expected exception '__main__.CustomException' was raised, but message was different.
        
        ACTUAL:
        This was not
        the expected message.
        
        EXPECTED:
        This was
        the expected message
        
