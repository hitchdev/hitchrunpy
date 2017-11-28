Timeout:
  based on: hitchrunpy
  preconditions:
    long string: |
      import time
      time.sleep(3)
    code: |
      pyrunner.with_code(long_string).with_timeout(1.0).run()
  scenario:
  - Raises exception:
      exception type: hitchrunpy.exceptions.PythonTimeout
      message: Timed out after 1.0 seconds.
