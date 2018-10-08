Run with environment variables:
  based on: hitchrunpy
  steps:
  - Run:
      code: |
        pyrunner.with_env(MYVAR="myenvironmentvar").with_code((
            'import os\n'
            '\n'
            'with open("examplefile", "w") as handle:\n'
            '     handle.write(os.environ["MYVAR"])\n'
        )).run()
  - File in working dir contains:
      filename: examplefile
      contents: myenvironmentvar
