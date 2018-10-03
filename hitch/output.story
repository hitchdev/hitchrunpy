Print message appears the same:
  based on: hitchrunpy
  given:
    code: |
      result = pyrunner.with_code('''print("hello")''').run()

      result.final_output_was('hello')
  steps:
  - Run code

Print message appears differently:
  based on: hitchrunpy
  given:
    code: |
      result = pyrunner.with_code('''print("goodbye")''').run()

      result.final_output_was('hello')
  steps:
  - Raises Exception:
      exception type: hitchrunpy.exceptions.OutputAppearsDifferent
      message: |
        EXPECTED:
        hello

        ACTUAL:
        goodbye

Larger screen:
  based on: hitchrunpy
  given:
    code: |
      long_string = (
        u"â string that is much longer that 80 characters string. "
        u"the small brown fox jumped over the lazy dog."
      )

      result = pyrunner.with_code((
          'print(long_string)'
      )).with_long_strings(long_string=long_string)\
        .with_terminal_size(160, 24)\
        .run()

      result.final_output_was(long_string)
  steps:
  - Run code
