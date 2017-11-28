from jinja2 import FileSystemLoader, environment
from commandlib import Command
from icommandlib import ICommand, ICommandError, IProcessTimeout
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


class RunningCode(object):
    def __init__(self, iprocess, error_path):
        self._iprocess = iprocess
        self._error_path = error_path

    @property
    def iprocess(self):
        return self._iprocess

    @property
    def finished(self):
        try:
            self._iprocess.psutil
            return False
        except:
            return True


class ExamplePythonCode(object):
    def __init__(self, python_bin, working_dir):
        self._python_bin = python_bin
        self._working_dir = working_dir
        self._terminal_size = (80, 24)

        self._setup_code = u''
        self._code = u''
        self._expect_exceptions = False
        self._long_strings = None
        self._cprofile_data = None
        self._timeout = None

    def with_code(self, code):
        new_expyc = copy(self)
        new_expyc._code = code
        return new_expyc

    def with_terminal_size(self, width, height):
        new_expyc = copy(self)
        new_expyc._terminal_size = (width, height)
        return new_expyc

    def with_setup_code(self, setup_code):
        new_expyc = copy(self)
        new_expyc._setup_code = setup_code
        return new_expyc

    def expect_exceptions(self):
        new_expyc = copy(self)
        new_expyc._expect_exceptions = True
        return new_expyc

    def with_long_strings(self, **strings):
        new_expyc = copy(self)
        new_expyc._long_strings = strings
        return new_expyc

    def with_cprofile(self, filename):
        new_expyc = copy(self)
        new_expyc._cprofile_data = Path(filename).abspath()
        return new_expyc

    def with_timeout(self, timeout):
        new_expyc = copy(self)
        new_expyc._timeout = timeout
        return new_expyc

    def running_code(self):
        """
        Start the code and return a RunningCode object.
        """
        working_dir = Path(self._working_dir)

        error_path = working_dir.joinpath("error.txt")
        example_python_code = working_dir.joinpath("examplepythoncode.py")

        env = environment.Environment()
        env.loader = FileSystemLoader(HITCHRUNPY_TEMPLATE_DIR)

        example_python_code.write_text(env.get_template("base.jinja2").render(
            long_strings=self._long_strings,
            setup_code=self._setup_code,
            cprofile_data=self._cprofile_data,
            code=self._code,
            error_path=error_path,
        ))

        pycommand = Command(self._python_bin, "examplepythoncode.py").in_dir(working_dir)

        try:
            return RunningCode(ICommand(pycommand).run(), error_path)
        except ICommandError as command_error:
            raise exceptions.ErrorRunningCode(
                "Error running code. Output:\n\n{0}".format(command_error.screenshot)
            )

    def run(self):
        """
        Run the code.
        """
        working_dir = Path(self._working_dir)

        error_path = working_dir.joinpath("error.txt")
        example_python_code = working_dir.joinpath("examplepythoncode.py")

        env = environment.Environment()
        env.loader = FileSystemLoader(HITCHRUNPY_TEMPLATE_DIR)

        example_python_code.write_text(env.get_template("base.jinja2").render(
            long_strings=self._long_strings,
            setup_code=self._setup_code,
            cprofile_data=self._cprofile_data,
            code=self._code,
            error_path=error_path,
        ))

        pycommand = Command(self._python_bin, "examplepythoncode.py").in_dir(working_dir)

        icommand = ICommand(pycommand).screensize(*self._terminal_size)

        if self._timeout is not None:
            icommand = icommand.with_timeout(self._timeout)

        try:
            finished_process = icommand.run().wait_for_successful_exit()
            command_output = finished_process.screenshot.strip()
        except IProcessTimeout as timeout_error:
            raise exceptions.PythonTimeout(
                str(timeout_error)
            )
        except ICommandError as command_error:
            raise exceptions.ErrorRunningCode(
                "Error running code. Output:\n\n{0}".format(command_error.screenshot)
            )

        exception_raised = None

        if error_path.exists():
            error_details = json.loads(error_path.bytes().decode('utf8'))

            if error_details['event'] == "exception":
                exception_raised = ExceptionRaised(error_details)
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
