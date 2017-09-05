from jinja2 import FileSystemLoader, environment
from commandlib import Command
from commandlib import exceptions as command_exception
from hitchrunpy import exceptions
from path import Path
from copy import copy
import difflib
import json


HITCHRUNPY_TEMPLATE_DIR = Path(__file__).dirname().abspath().joinpath("templates")


class ExamplePythonCode(object):
    def __init__(self, code):
        self._code = code

        self._is_equal = False
        self._lhs = None
        self._rhs = None

        self._exception_type = None
        self._exception_text = None
        self._expect_exception = False

        self._expected_output = None

        self._setup_code = u''

    def with_setup_code(self, setup_code):
        new_expyc = copy(self)
        new_expyc._setup_code = setup_code
        return new_expyc

    def is_equal(self, lhs, rhs):
        # TODO : Make this fail if expect_exception is used.
        new_expyc = copy(self)
        new_expyc._lhs = lhs
        new_expyc._rhs = rhs
        new_expyc._is_equal = True
        return new_expyc

    def expect_exception(self, exception_type=None, text=None):
        # TODO : Make this fail if is_equal is used.
        new_expyc = copy(self)
        new_expyc._exception_type = exception_type
        new_expyc._exception_text = text
        new_expyc._expect_exception = True
        return new_expyc

    def expect_output(self, output):
        new_expyc = copy(self)
        new_expyc._expected_output = output
        return new_expyc

    def run(self, working_dir, python_bin):
        """
        Run the defined code with python_bin in working_dir.

        python_bin - can either be a python commandlib object or a
        string referencing a python binary.

        working_dir can either be a path.py object or a string
        referencing an existing directory.
        """
        pycommand = Command(python_bin).in_dir(working_dir)
        working_dir = Path(working_dir)

        error_path = working_dir.joinpath("error.txt")
        example_python_code = working_dir.joinpath("examplepythoncode.py")

        env = environment.Environment()
        env.loader = FileSystemLoader(HITCHRUNPY_TEMPLATE_DIR)

        if self._is_equal:
            example_python_code.write_text(env.get_template("is_equal.jinja2").render(
                setup_code=self._setup_code,
                code=self._code,
                lhs=self._lhs,
                rhs=self._rhs,
                error_path=error_path,
            ))
        else:
            example_python_code.write_text(env.get_template("base.jinja2").render(
                setup_code=self._setup_code,
                code=self._code,
                error_path=error_path,
            ))

        try:
            command_output = pycommand(example_python_code).in_dir(working_dir).output().strip()
        except command_exception.CommandExitError as command_error:
            error_message = command_error.stderr.replace(
                str(working_dir.joinpath("examplepythoncode.py").abspath()),
                "example_python_code.py"
            ).rstrip()
            raise exceptions.ErrorRunningCode(
                "Error running code. Output:\n\n{0}".format(error_message)
            )

        if self._expected_output is not None:
            if self._expected_output != command_output:
                raise exceptions.OutputAppearsDifferent((
                    'EXPECTED:\n'
                    '{0}\n'
                    '\n'
                    'ACTUAL:\n'
                    '{1}'
                ).format(
                    self._expected_output,
                    command_output,
                ))

        if error_path.exists():
            error_details = json.loads(error_path.bytes().decode('utf8'))

            if error_details['event'] == "exception":
                if self._expect_exception:
                    if self._exception_type is not None:
                        if error_details['exception_type'] != self._exception_type:
                            raise exceptions.ExpectedExceptionWasDifferent((
                                u"Expected exception '{0}', instead "
                                u"'{1}' was raised."
                            ).format(self._exception_type, error_details['exception_type']))

                    if self._exception_text is not None:
                        if error_details['text'] != self._exception_text:
                            raise exceptions.ExpectedExceptionMessageWasDifferent(
                                self._exception_type,
                                error_details['text'],
                                self._exception_text,
                                ''.join(difflib.ndiff(
                                    error_details['text'].splitlines(1),
                                    self._exception_text.splitlines(1)
                                )),
                            )
                else:
                    raise exceptions.UnexpectedException(
                        "Unexpected exception '{0}' raised. Message:\n{1}".format(
                            error_details['exception_type'],
                            error_details['text'],
                        )
                    )
            elif error_details['event'] == "notequal":
                raise exceptions.NotEqual((
                  u"'{0}' is not equal to '{1}'.\n"
                  u"\n"
                  u"'{0}' is:\n"
                  u"{2}\n"
                  u"\n"
                  u"'{1}' is:\n"
                  u"{3}"
                  u"DIFF:\n"
                  u"{4}"
                ).format(
                    self._lhs,
                    self._rhs,
                    error_details['lhs'],
                    error_details['rhs'],
                    ''.join(difflib.ndiff(
                        error_details['lhs'].splitlines(1),
                        error_details['rhs'].splitlines(1)
                    )),
                ))
            else:
                raise TypeError(
                    "Invalid error event type {0} reported.".format(error_details['event'])
                )
        else:
            if self._expect_exception:
                raise exceptions.ExpectedExceptionButNoExceptionOccurred(
                    "Expected exception '{0}', but no exception occurred.".format(
                        self._exception_type,
                    )
                )
