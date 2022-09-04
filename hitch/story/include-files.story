Include files:
  about: |
    This example shows how to include files which can be
    used as e.g. modules to import or text files to read accessible
    in the working directory.
  docs: include-files
  based on: hitchrunpy
  given:
    files:
      differentdirectory/write_file.py: |
        def write_to_file():
            with open("examplefile", "w") as handle:
                handle.write("â string of some kind")
  steps:
  - Run:
      code: |
        CODE = """
        from write_file import write_to_file

        write_to_file()
        """

        pyrunner.with_code(CODE).include_files("../differentdirectory/write_file.py").run()
  - File in working dir contains:
      filename: examplefile
      contents: â string of some kind
