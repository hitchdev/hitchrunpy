Is equal matches:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode("x = 5").is_equal("x", "5").run(working_dir, python)
  scenario:
    - Run code

Is equal does not match:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode('''
      x = 4
      y = 5
      ''').is_equal("x", "y").run(working_dir, python)
  scenario:
    - Raises Exception:
        exception type: hitchrunpy.exceptions.NotEqual
        message: |
          'x' is not equal to 'y'.

          'x' is:
          4

          'y' is:
          5DIFF:
          - 4+ 5
