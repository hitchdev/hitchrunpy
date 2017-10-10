HitchRunPy
==========

Test python code at arm's length.

Note that HitchRunPy is ALPHA until it reaches version 0.5.
APIs may change at any time and without warning.


Install
-------

.. code-block:: sh

  $ pip install hitchrunpy


Example
-------

.. code-block:: python


      from hitchrunpy import ExamplePythonCode
      
      ExamplePythonCode(
          '/path/to/bin/python',
          '/path/to/working_directory',
      ).with_code((
          'with open("examplefile", "w") as handle:'
          '     handle.write("exampletext")'
      )).run()

      
Features
--------

* Pretty stack traces when your code snippets fail.
* Interact directly with the process that your python code runs with.
