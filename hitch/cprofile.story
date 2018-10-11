CProfile:
  docs: cprofile
  about: |
    Code snippets run by hitchrunpy can be
    profiled with cprofile.
  based on: hitchrunpy
  given:
    long string: |
      def do_calculation(number):
          x = i^i

      for i in range(0, 5000 * 1000):
          do_calculation(i)
  steps:
  - Run:
      code: |
        pyrunner.with_cprofile("profiledata.dat").with_code(long_string).run()

        import pstats

        data = pstats.Stats("profiledata.dat").sort_stats('cumulative')
        data.calc_callees()
        Ensure(data.stats).has_key(('examplepythoncode.py', 56, 'do_calculation'))
