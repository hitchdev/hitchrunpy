Timeout:
  about: |
    If the python code snippets you are running
    encounter a very very long loop or infinite, you
    can get it to time out.
  docs: timeout
  based on: hitchrunpy
  given:
    long string: |
      import time
      time.sleep(3)
  steps:
  - Run:
      code: pyrunner.with_code(long_string).with_timeout(1.0).run()
      raises:
        type: hitchrunpy.exceptions.PythonTimeout
        message: Timed out waiting for exit.
