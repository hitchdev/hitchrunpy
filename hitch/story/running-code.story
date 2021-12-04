Interact with running code:
  docs: interact-with-running-code
  about: |
    If you need to test code asynchronously or interact
    with it in a terminal window, you can use .running_code()
    to get a RunningCode object.

    From the RunningCode object you can use .iprocess to
    get an [icommandlib iprocess object](https://github.com/crdoconnor/icommandlib).
  based on: hitchrunpy
  given:
    long string: |
      import sys
      import time

      answer = input("favorite color:")

      with open("color.txt", "w") as handle:
          handle.write(answer)

      answer = input("favorite movie:")

      with open("movie.txt", "w") as handle:
          handle.write(answer)

      time.sleep(0.5)
      sys.exit(0)
  steps:
  - Run:
      code: |
        running_code = pyrunner.with_code(long_string).with_terminal_size(10, 10).running_code()

        assert not running_code.finished

        running_code.iprocess.wait_until_output_contains("favorite color:")
        running_code.iprocess.send_keys("red\n")
        running_code.iprocess.wait_until_output_contains("favorite movie:")
        running_code.iprocess.send_keys("the usual suspects\n")
        running_code.iprocess.wait_for_finish()

        with open("screenshot.txt", 'w') as handle:
            handle.write(running_code.iprocess.stripshot())

        assert running_code.finished
  - File written by code contains:
      filename: screenshot.txt
      contents: |-
        favorite c
        olor:red
        favorite m
        ovie:the u
        sual suspe
        cts
