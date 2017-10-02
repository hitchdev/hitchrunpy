Is equal matches:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code("x = 5").is_equal("x", "5").run()
  scenario:
  - Run code


Is equal should not run if error in setup:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code("x = 5")\
              .with_setup_code('raise Exception("equality test will not happen")')\
              .is_equal("x", "5").run()
  scenario:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.UnexpectedException
      message: "Unexpected exception 'builtins.Exception' raised. Stacktrace:\n\n\
        [0]: function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'\n  examplepythoncode.py\n\
        \n    \n        55 : \n        56 : try:\n    --> [[ BRIGHT ]]57[[ RESET ALL\
        \ ]] :     from hitchrunpy import ExamplePythonCode\n        58 :     import\
        \ hitchbuild\n    \n    \n\n[[ RED ]][[ BRIGHT ]]builtins.Exception[[ RESET\
        \ ALL ]]\n  [[ DIM ]][[ RED ]]Common base class for all non-exit exceptions.[[\
        \ RESET ALL ]]\n[[ RED ]]equality test will not happen[[ RESET FORE ]]"

Is equal does not match:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code('''
      x = 4
      y = 5
      ''').is_equal("x", "y").run()
  scenario:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.NotEqual
      message: |
        'x' is not equal to 'y'.

        'x' is:
        4

        'y' is:
        5DIFF:
        - 4+ 5
