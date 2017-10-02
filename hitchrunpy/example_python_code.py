from jinja2 import FileSystemLoader, environment
from commandlib import Command
from icommandlib import ICommand, ICommandError
from prettystack import PrettyStackTemplate
from hitchrunpy import exceptions
from path import Path
from copy import copy
import difflib
import json


HITCHRUNPY_TEMPLATE_DIR = Path(__file__).dirname().abspath().joinpath("templates")


class ExceptionRaised(object):
    def __init__(self, error_details):
        self._error_details = error_details
        self.exception_type = error_details['exception_type']
        self.message = error_details['exception_string']

    @property
    def formatted_stacktrace(self):
        return PrettyStackTemplate().to_console().from_stacktrace_data(self._error_details)


class Result(object):
    def __init__(self, exception=None, output=None):
        self.exception = exception
        self.output = output

    def final_output_was(self, output):
        if output != self.output:
            raise exceptions.OutputAppearsDifferent((
                'EXPECTED:\n'
                '{0}\n'
                '\n'
                'ACTUAL:\n'
                '{1}'
            ).format(
                output,
                self.output,
            ))

    def exception_was_raised(self, exception_type=None, text=None):
        if self.exception is None:
            raise exceptions.ExpectedExceptionButNoExceptionOccurred(
                "Expected exception '{0}', but no exception occurred.".format(
                    exception_type,
                )
            )

        if exception_type is not None:
            if self.exception.exception_type != exception_type:
                raise exceptions.ExpectedExceptionWasDifferent(
                    exception_type,
                    self.exception.exception_type,
                    self.exception.formatted_stacktrace,
                )

        if text is not None:
            if self.exception.message != text:
                raise exceptions.ExpectedExceptionMessageWasDifferent(
                    exception_type,
                    self.exception.message,
                    text,
                    ''.join(difflib.ndiff(
                        self.exception.message.splitlines(1),
                        text.splitlines(1)
                    )),
                )


class ExamplePythonCode(object):
    def __init__(self, python_bin, working_dir):
        self._python_bin = python_bin
        self._working_dir = working_dir

        self._code = ''

        self._is_equal = False
        self._lhs = None
        self._rhs = None

        self._exception_type = None
        self._exception_text = None
        self._expect_exception = False
        self._exception_match_function = None
        self._expect_exceptions = False

        self._expected_output = None

        self._long_strings = None

        self._setup_code = u''

    def with_code(self, code):
        new_expyc = copy(self)
        new_expyc._code = code
        return new_expyc

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

    def expect_exception(self, exception_type=None, text=None, match_function=None):
        # TODO : Make this fail if is_equal is used.
        new_expyc = copy(self)
        new_expyc._exception_type = exception_type
        new_expyc._exception_text = text
        new_expyc._exception_match_function = match_function
        new_expyc._expect_exception = True
        return new_expyc

    def expect_exceptions(self):
        new_expyc = copy(self)
        new_expyc._expect_exceptions = True
        return new_expyc

    def with_long_strings(self, **strings):
        new_expyc = copy(self)
        new_expyc._long_strings = strings
        return new_expyc

    def expect_output(self, output):
        new_expyc = copy(self)
        new_expyc._expected_output = output
        return new_expyc

    def run(self):
        """
        Run the code.
        """
        working_dir = Path(self._working_dir)

        error_path = working_dir.joinpath("error.txt")
        example_python_code = working_dir.joinpath("examplepythoncode.py")

        env = environment.Environment()
        env.loader = FileSystemLoader(HITCHRUNPY_TEMPLATE_DIR)

        if self._is_equal:
            example_python_code.write_text(env.get_template("is_equal.jinja2").render(
                long_strings=self._long_strings,
                setup_code=self._setup_code,
                code=self._code,
                lhs=self._lhs,
                rhs=self._rhs,
                error_path=error_path,
            ))
        else:
            example_python_code.write_text(env.get_template("base.jinja2").render(
                long_strings=self._long_strings,
                setup_code=self._setup_code,
                code=self._code,
                error_path=error_path,
            ))

        pycommand = Command(self._python_bin, "examplepythoncode.py").in_dir(working_dir)

        try:
            finished_process = ICommand(pycommand).with_timeout(2.0)\
                                                  .run()\
                                                  .wait_for_successful_exit()
            command_output = finished_process.screenshot.strip()
        except ICommandError as command_error:
            raise exceptions.ErrorRunningCode(
                "Error running code. Output:\n\n{0}".format(command_error.screenshot)
            )

        exception_raised = None

        if error_path.exists():
            error_details = json.loads(error_path.bytes().decode('utf8'))

            if error_details['event'] == "exception":
                exception_raised = ExceptionRaised(error_details)

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

            if not self._expect_exceptions:
                raise exceptions.UnexpectedException(
                    exception_raised.exception_type,
                    exception_raised.message,
                    exception_raised.formatted_stacktrace,
                )

        return Result(exception=exception_raised, output=command_output)
