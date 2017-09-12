hitchrunpy:
  preconditions:
    runner python version: (( runner python version ))
    working python version: (( working python version ))
    setup: |
      from hitchrunpy import ExamplePythonCode
      from commandlib import python

      working_dir = '/path/to/working_dir'
  params:
    runner python version: 3.5.0
    working python version: 3.5.0
