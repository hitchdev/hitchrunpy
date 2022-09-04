Feed string variables to code:
  about: |
    This example shows how to feed variables containing
    strings to your running code.
  docs: variables
  based on: hitchrunpy
  steps:
  - Run:
      code: |
        some_string = u"â string of some kind"

        pyrunner.with_code((
            'with open("examplefile", "w") as handle:'
            '     handle.write(some_string)'
        )).with_strings(some_string=some_string).run()
  - File in working dir contains:
      filename: examplefile
      contents: â string of some kind
