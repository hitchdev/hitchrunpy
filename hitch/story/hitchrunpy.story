hitchrunpy:
  given:
    runner python version: (( runner python version ))
    working python version: (( working python version ))
    setup: |
      from hitchrunpy import ExamplePythonCode
      from ensure import Ensure
      import hitchbuildpy
      import hitchbuild

      BUILD_DIR = "/path/to/build_dir/.."

      virtualenv = hitchbuildpy.VirtualenvBuild(
          "/path/to/build_dir/../py{{ pyver }}",
          base_python=hitchbuildpy.PyenvBuild(
              '/path/to/share_dir/../pyenv{{ pyver }}',
              "{{ pyver }}",
          ),
      )

      virtualenv.verify()

      pyrunner = ExamplePythonCode(
          virtualenv.bin.python,
          '/path/to/working_dir',
      )
  with:
    runner python version: 3.7.0
    working python version: 3.7.0
