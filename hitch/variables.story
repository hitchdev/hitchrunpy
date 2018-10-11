Feed string variables to code:
  about: |
    This example shows how to feed variables containing
    strings to your running code.
  docs: variables
  based on: hitchrunpy
  steps:
  - Run:
      code: |
        long_string = u"â long string"

        pyrunner.with_code((
            'with open("examplefile", "w") as handle:'
            '     handle.write(long_string)'
        )).with_long_strings(long_string=long_string).run()
  - File in working dir contains:
      filename: examplefile
      contents: â long string
