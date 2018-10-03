Timeout:
  based on: hitchrunpy
  given:
    long string: |
      import time
      time.sleep(3)
    code: |
      pyrunner.with_code(long_string).with_timeout(1.0).run()
  steps:
  - Raises exception:
      exception type: hitchrunpy.exceptions.PythonTimeout
      message: Timed out waiting for exit.
