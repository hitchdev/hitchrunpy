HitchRunPy
==========

Tools to run and interact with python code at arm's length,
from other python code.

Install
-------

.. code-block:: sh

  $ pip install hitchrunpy


Example
-------

.. code-block:: python


      from hitchrunpy import ExamplePythonCode
      
      ExamplePythonCode((
          'with open("examplefile", "w") as handle:'
          '     handle.write("exampletext")'
      )).run(
          '/path/to/working_directory', 
          '/path/to/bin/python',
      )

      
Features
--------

* Test variables for equality.
* "Expect" exceptions and get detailed debugging info when the exception is not quite right.
* Monitor what is printed to stdout.
