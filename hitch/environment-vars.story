Environment variables:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_env(MYVAR="myenvironmentvar").with_code((
          'import os\n'
          '\n'
          'with open("examplefile", "w") as handle:\n'
          '     handle.write(os.environ["MYVAR"])\n'
      )).run()
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: myenvironmentvar
