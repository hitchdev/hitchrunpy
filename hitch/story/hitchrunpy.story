hitchrunpy:
  given:
    setup: |
      from hitchrunpy import ExamplePythonCode
      from ensure import Ensure
      from commandlib import python
      import hitchbuild
      
      BUILD_DIR = "/path/to/build_dir/.."

      pyrunner = ExamplePythonCode(
          python,
          '/path/to/working_dir',
      )
