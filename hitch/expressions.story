Is equal matches:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode("x = 5").is_equal("x", "5").run(working_dir, python)
  scenario:
    - Run code

Is equal does not match:
  based on: hitchrunpy
  preconditions:
    code: |
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
