CProfile:
  based on: hitchrunpy
  preconditions:
    long string: |
      def do_calculation(number):
          x = i^i

      for i in range(0, 5000 * 1000):
          do_calculation(i)
    code: |
      pyrunner.with_cprofile("profiledata.dat").with_code(long_string).run()

      import pstats

      data = pstats.Stats("profiledata.dat").sort_stats('cumulative')
      data.calc_callees()
      Ensure(data.stats).has_key(('examplepythoncode.py', 56, 'do_calculation'))
  scenario:
  - Run code
