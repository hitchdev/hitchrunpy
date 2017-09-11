Print message appears:
  based on: hitchrunpy
  preconditions:
    code: |
      result = ExamplePythonCode('''print("hello")''').run(working_dir, python)
      
      result.final_output_was('hello')
  scenario:
    - Run code

Print message appears differently:
  based on: hitchrunpy
  preconditions:
    code: |
      result = ExamplePythonCode('''print("goodbye")''').run(working_dir, python)
      
      result.final_output_was('hello')
  scenario:
    - Raises Exception:
        exception type: hitchrunpy.exceptions.OutputAppearsDifferent
        message: |
          EXPECTED:
          hello
          
          ACTUAL:
          goodbye
