Run code:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode((
          'with open("examplefile", "w") as handle:'
          '     handle.write("exampletext")'
      )).run(working_dir, python)
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: exampletext


Run code with long strings:
  based on: hitchrunpy
  preconditions:
    code: |
      long_string = u"â long string"

      ExamplePythonCode((
          'with open("examplefile", "w") as handle:'
          '     handle.write(long_string)'
      )).with_long_strings(long_string=long_string).run(working_dir, python)
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: â long string


Error running code:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode('''x =''').run(working_dir, python)
  scenario:
  - Raises exception:
      exception type: hitchrunpy.exceptions.ErrorRunningCode
      message: |
        Error running code. Output:

          File "example_python_code.py", line 60
            x =
              ^
        SyntaxError: invalid syntax

Unexpected exception:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode("""

      raise Exception('This should not happen')

      """).run(working_dir, python)
  scenario:
  - Raises exception:
      exception type: hitchrunpy.exceptions.UnexpectedException
      message: |
        Unexpected exception 'builtins.Exception' raised. Message:
        This should not happen


Setup code:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode((
          'with open("examplefile", "w") as handle:'
          '     handle.write(exampletext)'
      )).with_setup_code("exampletext = 'exampletext'")\
          .run(working_dir, python)
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: exampletext
