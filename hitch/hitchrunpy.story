hitchrunpy:
  preconditions:
    runner python version: (( runner python version ))
    working python version: (( working python version ))
    setup: |
      from hitchrunpy import ExamplePythonCode
      import hitchbuild
      import hitchbuildpy

      bundle = hitchbuild.BuildBundle(
          hitchbuild.BuildPath(build=".", share="/path/to/share_dir/"),
      )

      bundle['python3.5.0'] = hitchbuildpy.PythonBuild("3.5.0")
      bundle['venv3.5.0'] = hitchbuildpy.VirtualenvBuild(bundle['python3.5.0'])
      bundle.ensure_built()
      
      python = bundle['python3.5.0'].bin.python

      working_dir = '/path/to/working_dir'
  params:
    runner python version: 3.5.0
    working python version: 3.5.0
