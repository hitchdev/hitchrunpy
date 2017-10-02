Print message appears the same:
  based on: hitchrunpy
  preconditions:
    code: |
      result = pyrunner.with_code('''print("hello")''').run()

      result.final_output_was('hello')
  scenario:
  - Run code

Print message appears differently:
  based on: hitchrunpy
  preconditions:
    code: |
      result = pyrunner.with_code('''print("goodbye")''').run()

      result.final_output_was('hello')
  scenario:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.OutputAppearsDifferent
      message: |
        EXPECTED:
        hello

        ACTUAL:
        goodbye
