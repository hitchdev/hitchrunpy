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
      message: "Unexpected exception 'builtins.Exception' raised. Stacktrace:\n\n\
        [0]: function '\e[1m<module>\e[0m'\n  /home/colm/.hitch/mdkgjt/working/examplepythoncode.py\n\
        \n    \n        59 :     \n        60 :         \n    --> \e[1m61\e[0m : \
        \        raise Exception('This should not happen')\n        62 :         \n\
        \    \n    \n\n\e[31m\e[1mbuiltins.Exception\e[0m\n  \e[2m\e[31mCommon base\
        \ class for all non-exit exceptions.\e[0m\n\e[31mThis should not happen\e\
        [39m"

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
