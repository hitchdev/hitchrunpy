Bring files into working directory:
  about: |
    This example shows how to feed variables containing
    strings to your running code.
  docs: variables
  based on: hitchrunpy
  steps:
  - Run:
      code: |
        some_string = u"â string of some kind"

        pyrunner.with_code((
            "with open('inputfile.txt', 'r') as read_handle:\n"
            "    with open('outputfile', 'w') as write_handle:\n"
            "        write_handle.write(read_handle.read())\n"
        )).with_files({"inputfile.txt": "â string of some kind"}).run()

  - File in working dir contains:
      filename: working/outputfile
      contents: â string of some kind
