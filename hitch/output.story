Print message appears:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode('''print("hello")''').expect_output('hello').run(working_dir, python)
  scenario:
    - Run code

Print message appears differently:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode('''print("goodbye")''').expect_output('hello').run(working_dir, python)
  scenario:
    - Raises Exception:
        exception type: hitchrunpy.exceptions.OutputAppearsDifferent
        message: |
          EXPECTED:
          hello
          
          ACTUAL:
          goodbye
