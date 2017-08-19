Print message appears:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode('''print("hello")''').expect_output('hello').run(working_dir, python)
  scenario:
    - Run code

Print message appears differently:
  preconditions:
    code: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python
      
      working_dir = '{{ working_dir }}'
      
      ExamplePythonCode('''print("goodbye")''').expect_output('hello').run(working_dir, python)
  scenario:
    - Raises Exception: |
        EXPECTED:
        hello
        
        ACTUAL:
        goodbye
