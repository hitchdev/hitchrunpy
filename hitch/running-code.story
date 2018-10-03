Running code:
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
    code: |
      running_code = pyrunner.with_code(long_string).with_terminal_size(10, 10).running_code()

      assert not running_code.finished

      running_code.iprocess.wait_until_output_contains("favorite color:")
      running_code.iprocess.send_keys("red\n")
      running_code.iprocess.wait_until_output_contains("favorite movie:")
      running_code.iprocess.send_keys("the usual suspects\n")
      running_code.iprocess.wait_for_finish()
      
      # This part of the code never reached because of bug in icommandlib
      
      with open("screenshot.txt", 'w') as handle:
          handle.write(running_code.iprocess.stripshot())

      #assert running_code.finished
  steps:
  - Run code
  #- File written by code contains:
  #    filename: screenshot.txt
  #    contents: x
