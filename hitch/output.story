Output from finished code:
  based on: hitchrunpy
  steps:
  - Run: |
      result = pyrunner.with_code('''print("hello")''').run()

      assert result.output == "hello"


Output from larger terminal size:
  based on: hitchrunpy
  steps:
  - Run:
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

        assert result.output == long_string
