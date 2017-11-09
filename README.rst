HitchRunPy
==========

Run, profile and interact with python code at arm's length -
from other python code.

HitchRunPy was developed to be able to run executable
specifications of python libraries using hitchstory.

Note that HitchRunPy is ALPHA until it reaches version 1.0.
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
* Interact with your code via a virtual terminal - send key strokes, wait for messages to appear on screen.
* Generate profiling data from your code.
