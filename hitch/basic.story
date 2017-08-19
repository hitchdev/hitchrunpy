Run code:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode('''
      with open("examplefile", "w") as handle:
          handle.write("exampletext")
      ''').run(working_dir, python)
  scenario:
    - Run code
    - File contains:
        filename: examplefile
        contents: exampletext


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
