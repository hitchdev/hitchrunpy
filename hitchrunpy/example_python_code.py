from jinja2 import DictLoader, environment
from hitchrunpy import exceptions
from commandlib import Command
from strictyaml import load
from path import Path
from copy import copy
import difflib
import json


HITCHRUNPY_DIR = Path(__file__).dirname().abspath()


class ExamplePythonCode(object):
    def __init__(self, code):
        self._code = code

        self._is_equal = False
        self._lhs = None
        self._rhs = None

        self._exception_type = None
        self._exception_text = None
        self._expect_exception = False

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

    def expect_exception(self, exception_type, text):
        # TODO : Make this fail if is_equal is used.
        new_expyc = copy(self)
        new_expyc._exception_type = exception_type
        new_expyc._exception_text = text
        new_expyc._expect_exception = True
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
        env.loader = DictLoader(
            load(HITCHRUNPY_DIR.joinpath("codetemplates.yml").bytes().decode('utf8')).data
        )

        if self._is_equal:
            example_python_code.write_text(env.get_template("is_equal").render(
                setup_code=self._setup_code,
                code=self._code,
                lhs=self._lhs,
                rhs=self._rhs,
                error_path=error_path,
            ))
        else:
            example_python_code.write_text(env.get_template("base").render(
                setup_code=self._setup_code,
                code=self._code,
                error_path=error_path,
            ))

        pycommand(example_python_code).in_dir(working_dir).run()

        if error_path.exists():
            error_details = json.loads(error_path.bytes().decode('utf8'))

            if error_details['event'] == "exception":
                if self._expect_exception:
                    if error_details['exception_type'] != self._exception_type:
                        raise exceptions.ExpectedExceptionWasDifferent((
                            u"Expected exception '{0}', instead "
                            u"'{1}' was raised."
                        ).format(self._exception_type, error_details['exception_type']))

                    if error_details['text'] == self._exception_text:
                        return
                    else:
                        raise exceptions.ExpectedExceptionMessageWasDifferent((
                            u"Expected exception '{0}' was raised, but message was different.\n"
                            u"\n"
                            u"ACTUAL:\n"
                            u"{1}\n"
                            u"\n"
                            u"EXPECTED:\n"
                            u"{2}\n"
                            u"DIFF:\n"
                            u"{3}"
                        ).format(
                            self._exception_type,
                            error_details['text'],
                            self._exception_text,
                            ''.join(difflib.ndiff(
                                error_details['text'].splitlines(1),
                                self._exception_text.splitlines(1)
                            ))
                        ))
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
