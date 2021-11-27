Run with environment variables:
  about: |
    Environment variables within the running python
    snippets can be overridden or set by using .with_env.
  docs: environment-vars
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
      filename: working/examplefile
      contents: myenvironmentvar
