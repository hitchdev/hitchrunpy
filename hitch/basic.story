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

            File "examplepythoncode.py", line 56
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
        message: "Unexpected exception 'builtins.Exception' raised.\n\nThis is ân\
          \ explanation for what happened printed to stdout\n\nStacktrace:\n\n[0]:\
          \ function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'\n  /path/to/code/working/examplepythoncode.py\n\
          \n\n        66 :\n        67 :\n    --> [[ BRIGHT ]]68[[ RESET ALL ]] :\
          \     run_example_code()\n        69 : except Exception as error:\n\n\n\n\
          [1]: function '[[ BRIGHT ]]run_example_code[[ RESET ALL ]]'\n  /path/to/code/working/examplepythoncode.py\n\
          \n\n        62 :\n        63 :\n    --> [[ BRIGHT ]]64[[ RESET ALL ]] :\
          \         runcode()\n        65 :\n\n\n\n[2]: function '[[ BRIGHT ]]runcode[[\
          \ RESET ALL ]]'\n  /path/to/code/working/examplepythoncode.py\n\n\n    \
          \    57 :                         print('This is ân explanation for what\
          \ happened printed to stdout')\n        58 :\n    --> [[ BRIGHT ]]59[[ RESET\
          \ ALL ]] :                         raise Exception('This should not hâppen')\n\
          \        60 :\n\n\n\n[[ RED ]][[ BRIGHT ]]builtins.Exception[[ RESET ALL\
          \ ]]\n  [[ DIM ]][[ RED ]]Common base class for all non-exit exceptions.[[\
          \ RESET ALL ]]\n[[ RED ]]This should not hâppen[[ RESET FORE ]]"
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
      filename: working/examplefile
      contents: exampletext
