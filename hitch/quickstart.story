Run code until completion:
  based on: hitchrunpy
  steps:
  - Run:
      code: |
        pyrunner.with_code((
            'with open("examplefile", "w") as handle:'
            '     handle.write("exampletext")'
        )).run()
  - File in working dir contains:
      filename: working/examplefile
      contents: exampletext
