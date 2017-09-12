Is equal matches:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode("x = 5").is_equal("x", "5").run(working_dir, python)
  scenario:
  - Run code


Is equal should not run if error in setup:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode("x = 5").with_setup_code('raise Exception("equality test will not happen")')\
                                .is_equal("x", "5").run(working_dir, python)
  scenario:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.UnexpectedException
      message: "Unexpected exception 'builtins.Exception' raised. Stacktrace:\n\n\
        [0]: function '\e[1m<module>\e[0m'\n  /home/colm/.hitch/mdkgjt/working/examplepythoncode.py\n\
        \n    \n        55 : \n        56 : try:\n    --> \e[1m57\e[0m :     raise\
        \ Exception(\"equality test will not happen\")\n        58 : \n    \n    \n\
        \n\e[31m\e[1mbuiltins.Exception\e[0m\n  \e[2m\e[31mCommon base class for all\
        \ non-exit exceptions.\e[0m\n\e[31mequality test will not happen\e[39m"

Is equal does not match:
  based on: hitchrunpy
  preconditions:
    code: |
      ExamplePythonCode('''
      x = 4
      y = 5
      ''').is_equal("x", "y").run(working_dir, python)
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
