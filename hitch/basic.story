Run code:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode((
          'with open("examplefile", "w") as handle:'
          '     handle.write("exampletext")'
      )).run(working_dir, python)
  scenario:
    - Run code
    - File contains:
        filename: examplefile
        contents: exampletext


Error running code:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode('''x =''').run(working_dir, python)
  scenario:
    - Raises exception:
        exception type: hitchrunpy.exceptions.ErrorRunningCode
        message: |
          Error running code. Output:

            File "example_python_code.py", line 22
              x =
                ^
          SyntaxError: invalid syntax
          



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
    - Raises exception:
        exception type: hitchrunpy.exceptions.UnexpectedException
        message: |
          Unexpected exception 'builtins.Exception' raised. Message:
          This should not happen


Setup code:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
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
