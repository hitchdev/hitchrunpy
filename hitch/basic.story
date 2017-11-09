Run code:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code((
          'with open("examplefile", "w") as handle:'
          '     handle.write("exampletext")'
      )).run()
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: exampletext


Long strings:
  based on: hitchrunpy
  preconditions:
    code: |
      long_string = u"â long string"

      pyrunner.with_code((
          'with open("examplefile", "w") as handle:'
          '     handle.write(long_string)'
      )).with_long_strings(long_string=long_string).run()
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: â long string

Error occurred:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code('''x =''').run()
  scenario:
  - Raises exception:
      exception type: hitchrunpy.exceptions.ErrorRunningCode
      message: |-
        Error running code. Output:

          File "examplepythoncode.py", line 56
            x =
              ^
        SyntaxError: invalid syntax

Unexpected exception:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code("""

      raise Exception('This should not hâppen')

      """).run()
  scenario:
  - Raises exception:
      exception type: hitchrunpy.exceptions.UnexpectedException
      message: |-
        Unexpected exception 'builtins.Exception' raised. Stacktrace:

        [0]: function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'
          /home/colm/.hitch/mdkgjt/working/examplepythoncode.py


                64 :
                65 :
            --> [[ BRIGHT ]]66[[ RESET ALL ]] :     run_example_code()
                67 : except Exception as error:



        [1]: function '[[ BRIGHT ]]run_example_code[[ RESET ALL ]]'
          /home/colm/.hitch/mdkgjt/working/examplepythoncode.py


                60 :
                61 :
            --> [[ BRIGHT ]]62[[ RESET ALL ]] :         runcode()
                63 :



        [2]: function '[[ BRIGHT ]]runcode[[ RESET ALL ]]'
          /home/colm/.hitch/mdkgjt/working/examplepythoncode.py


                55 :
                56 :
            --> [[ BRIGHT ]]57[[ RESET ALL ]] :                 raise Exception('This should not hâppen')
                58 :



        [[ RED ]][[ BRIGHT ]]builtins.Exception[[ RESET ALL ]]
          [[ DIM ]][[ RED ]]Common base class for all non-exit exceptions.[[ RESET ALL ]]
        [[ RED ]]This should not hâppen[[ RESET FORE ]]

Setup code:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code((
          'with open("examplefile", "w") as handle:'
          '     handle.write(exampletext)'
      )).with_setup_code("exampletext = 'exampletext'")\
        .run()
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: exampletext
