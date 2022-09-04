Error occurred:
  docs: syntax-errors
  based on: hitchrunpy
  steps:
  - Run:
      code: |
        pyrunner.with_code('''x =''').run()
      raises:
        type: hitchrunpy.exceptions.ErrorRunningCode
        message: |-
          Error running code. Output:

            File "/path/to/working/examplepythoncode.py", line 56
              x =
                ^
          SyntaxError: invalid syntax
Unexpected exception:
  based on: hitchrunpy
  steps:
  - Run:
      code: |
        pyrunner.with_code("""

        print('This is ân explanation for what happened printed to stdout')

        raise Exception('This should not hâppen')

        """).run()
      raises:
        type: hitchrunpy.exceptions.UnexpectedException
        message: |-
          Unexpected exception 'builtins.Exception' raised.

          This is ân explanation for what happened printed to stdout

          Stacktrace:

          [0]: function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'
            /path/to/working/examplepythoncode.py


                  66 :
                  67 :
              --> [[ BRIGHT ]]68[[ RESET ALL ]] :     run_example_code()
                  69 : except Exception as error:



          [1]: function '[[ BRIGHT ]]run_example_code[[ RESET ALL ]]'
            /path/to/working/examplepythoncode.py


                  62 :
                  63 :
              --> [[ BRIGHT ]]64[[ RESET ALL ]] :         runcode()
                  65 :



          [2]: function '[[ BRIGHT ]]runcode[[ RESET ALL ]]'
            /path/to/working/examplepythoncode.py


                  57 :                         print('This is ân explanation for what happened printed to stdout')
                  58 :
              --> [[ BRIGHT ]]59[[ RESET ALL ]] :                         raise Exception('This should not hâppen')
                  60 :



          [[ RED ]][[ BRIGHT ]]builtins.Exception[[ RESET ALL ]]
            [[ DIM ]][[ RED ]]Common base class for all non-exit exceptions.[[ RESET ALL ]]
          [[ RED ]]This should not hâppen[[ RESET FORE ]]
Setup code:
  docs: setup-code
  based on: hitchrunpy
  steps:
  - Run:
      code: |
        pyrunner.with_code((
            'with open("examplefile", "w") as handle:'
            '     handle.write(exampletext)'
        )).with_setup_code("exampletext = 'exampletext'")\
          .run()
  - File in working dir contains:
      filename: examplefile
      contents: exampletext
