Use modules:
  about: |
    This example shows how to feed variables containing
    strings to your running code.
  docs: variables
  based on: hitchrunpy
  given:
    files:
      write_to_file.py: |
        def write_text():
            with open("examplefile", "w") as handle:
                 handle.write("â string of some kind")
  steps:
  - Run:
      code: |
        some_string = u"â string of some kind"

        pyrunner.with_code((
            "from write_to_file import write_text\n"
            "write_text()"
        )).with_modules(f"{BUILD_DIR}/state/write_to_file.py").run()
  - File in working dir contains:
      filename: examplefile
      contents: â string of some kind
