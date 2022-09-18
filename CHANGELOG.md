# Changelog


### Latest

* BUGFIX : Remove errant debugging statement
* FEATURE : .include_files()
* BUGFIX : Fix hitchrunpy.
* FEATURE : Run python code in different directory to the working directory.


### 0.9.0

* FEATURE : with_files feature.
* BUGFIX : Deal with not having any modules cleanly.


### 0.8.0

* FEATURE : Add modules.


### 0.7.0

* FEATURE : Create working directory specifically for the use of hitchrunpy and drop with_long_strings in favor of with_strings.
* BUGFIX : Read the README correctly in setup.py.


### 0.6.3

* BUGFIX : .finished was broken, should now be fixed.


### 0.6.2

* BUGFIX : Fixed timeout bug.


### 0.6.1

* FEATURE : Able to set environment variables for running python code.


### 0.6.0


No relevant code changes.

### 0.5.0

* MINOR : FEATURE : Added timeout on programs that run forever.


### 0.4.0

* MINOR : FEATURE : Made terminal window that python runs in resizable.
* MINOR FEATURE : No longer profile code in setup - only in code.
* MINOR REFACTOR : Run all of the code in a special function to make the profiling a bit clearer.


### 0.3.0

* MINOR : Tell if process is running or finished.
* MINOR : Ability to interact with running python processes.
* FEATURE : CProfiling of python code.
* BUGFIX : Removed default timeout on icommand.


### 0.2.0

* FEATURE : Use icommandlib instead of commandlib to get the output / errors when running python code.
* BUGFIX : Ensure that the latest version of prettystack is being used, otherwise will break.


### 0.1.6

* FEATURE : Full stack trace displayed when the wrong exception occurs.


### 0.1.5

* BUGFIX : Fixed python 2.7.x bug and improved test framework to be able to test running code in that environment.


### 0.1.4

* FEATURE : Added nicely formatted stack traces to unexpected exceptions.


### 0.1.3

* FEATURE : Expectations are now operated solely upon result objects.
* BUGFIX : Test for exiting immediately if there is a code failure.
* BUGFIX : Exit immediately if exit occurs during setup code.
* BUGFIX : Unicode characters to be handled correctly in long strings.
* FEATURE : Matching function for exceptions.


### 0.1.2

* FEATURE : Long strings.
* FEATURE : When an unknown exception type is raised, still print message.


### 0.1.1

* FEATURE : Allow nameless exceptions and exceptions without text to be expected.

