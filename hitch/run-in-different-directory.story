Run in different directory:
  about: |
    This example shows how to feed variables containing
    strings to your running code.
  docs: variables
  based on: hitchrunpy
  given:
    files:
      differentdirectory/examplefile: some file
  steps:
  - Run:
      code: |
        pyrunner.with_code((
            'with open("outputfile", "w") as handle:'
            '     handle.write("some kind of text")'
        )).in_dir("differentdirectory/").run()
  - File in dir contains:
      filename: differentdirectory/outputfile
      contents: some kind of text
