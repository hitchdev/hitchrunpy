Is equal:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode("x = 5").is_equal("x", "5").run(working_dir, python)
  scenario:
    - Run code
