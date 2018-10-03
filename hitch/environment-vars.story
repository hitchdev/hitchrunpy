sys argv:
  based on: hitchrunpy
  given:
    code: |
      pyrunner.with_env(MYVAR="myenvironmentvar").with_code((
          'import os\n'
          '\n'
          'with open("examplefile", "w") as handle:\n'
          '     handle.write(os.environ["MYVAR"])\n'
      )).run()
  steps:
  - Run code
  - File in working dir contains:
      filename: examplefile
      contents: myenvironmentvar
