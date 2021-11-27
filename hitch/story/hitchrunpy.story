hitchrunpy:
  given:
    runner python version: (( runner python version ))
    working python version: (( working python version ))
    setup: |
      from hitchrunpy import ExamplePythonCode
      from ensure import Ensure
      import hitchbuildpy
      import hitchbuild

      virtualenv = hitchbuildpy.VirtualenvBuild(
          name="py{{ pyver }}",
          base_python=hitchbuildpy.PyenvBuild("{{ pyver }}").with_build_path(
              '/path/to/share_dir/'
          ),
      ).with_build_path("/path/to/build_dir/")

      virtualenv.ensure_built()

      pyrunner = ExamplePythonCode(
          virtualenv.bin.python,
          '/path/to/working_dir',
      )
  with:
    runner python version: 3.7.0
    working python version: 3.7.0
