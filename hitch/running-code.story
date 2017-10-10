Running code:
  based on: hitchrunpy
  preconditions:
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
      running_code = pyrunner.with_code(long_string).running_code()

      running_code.iprocess.wait_until_output_contains("favorite color:")
      running_code.iprocess.send_keys("red\n")
      running_code.iprocess.wait_until_output_contains("favorite movie:")
      running_code.iprocess.send_keys("the usual suspects\n")
      running_code.iprocess.wait_until_on_screen("favorite color")
      running_code.iprocess.wait_for_finish()
  scenario:
  - Run code
