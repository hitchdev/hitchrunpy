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
