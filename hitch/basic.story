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
      message: "Error running code. Output:\n\n  File \"examplepythoncode.py\", line\
        \ 60                                          \n    x =                  \
        \                                                       \n      ^        \
        \                                                                 \nSyntaxError:\
        \ invalid syntax"

Unexpected exception:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode("""

      raise Exception('This should not hâppen')

      """).run(working_dir, python)
  scenario:
  - Raises exception:
      exception type: hitchrunpy.exceptions.UnexpectedException
      message: "Unexpected exception 'builtins.Exception' raised. Stacktrace:\n\n\
        [0]: function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'\n  examplepythoncode.py\n\
        \n    \n        59 :     import hitchbuildpy\n        60 :     \n    --> [[\
        \ BRIGHT ]]61[[ RESET ALL ]] :     bundle = hitchbuild.BuildBundle(\n    \
        \    62 :         hitchbuild.BuildPath(build=\"/path/to/code\", share=\"/path/to/share\"\
        ),\n    \n    \n\n[[ RED ]][[ BRIGHT ]]builtins.Exception[[ RESET ALL ]]\n\
        \  [[ DIM ]][[ RED ]]Common base class for all non-exit exceptions.[[ RESET\
        \ ALL ]]\n[[ RED ]]This should not hâppen[[ RESET FORE ]]"

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
