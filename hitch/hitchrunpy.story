hitchrunpy:
  preconditions:
    runner python version: (( runner python version ))
    working python version: (( working python version ))
    setup: |
      from hitchrunpy import ExamplePythonCode
      import hitchbuild
      import hitchbuildpy

      bundle = hitchbuild.BuildBundle(
          hitchbuild.BuildPath(build="/path/to/build_dir/", share="/path/to/share_dir/"),
      )

      bundle['python{{ pyver }}'] = hitchbuildpy.PythonBuild("{{ pyver }}")
      bundle['venv{{ pyver }}'] = hitchbuildpy.VirtualenvBuild(bundle['python{{ pyver }}'])
      bundle.ensure_built()
      
      python = bundle['python{{ pyver }}'].bin.python

      working_dir = '/path/to/working_dir'
  params:
    runner python version: 3.5.0
    working python version: 3.5.0
