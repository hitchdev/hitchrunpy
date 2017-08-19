from copy import copy
from jinja2.environment import Environment
from commandlib import Command
from jinja2 import DictLoader
from strictyaml import load
from path import Path
import json


HITCHRUNPY_DIR = Path(__file__).dirname().abspath()


class HitchRunPyException(Exception):
    pass


class UnexpectedException(HitchRunPyException):
    pass


class ExpectedExceptionWasDifferent(HitchRunPyException):
    pass


class ExpectedExceptionMessageWasDifferent(HitchRunPyException):
    pass


class ExpectedExceptionButWasNoException(HitchRunPyException):
    pass


class ExamplePythonCode(object):
    def __init__(self, code):
        self._code = code
        
        self._is_equal = False
        self._lhs = None
        self._rhs = None
        
        self._exception_type = None
        self._exception_text = None
        self._expect_exception = False
    
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
        pycommand = Command(python_bin).in_dir(working_dir)
        working_dir = Path(working_dir)
        
        error_path = working_dir.joinpath("error.txt")
        example_python_code = working_dir.joinpath("examplepythoncode.py")
        
        env = Environment()
        env.loader = DictLoader(
            load(HITCHRUNPY_DIR.joinpath("codetemplates.yml").bytes().decode('utf8')).data
        )
        
        if self._is_equal:
            example_python_code.write_text(env.get_template("is_equal").render(
                setup=self._code,
                lhs=self._lhs,
                rhs=self._rhs,
                error_path=error_path,
            ))
        elif self._expect_exception:
            example_python_code.write_text(env.get_template("base").render(
                setup=self._code,
                error_path=error_path,
            ))
        else:
            example_python_code.write_text(env.get_template("base").render(
                setup=self._code,
                error_path=error_path,
            ))
            
        
        pycommand(example_python_code).in_dir(working_dir).run()
        
        if self._expect_exception:
            if error_path.exists():
                error_details = json.loads(error_path.bytes().decode('utf8'))
                
                if error_details['exception_type'] != self._exception_type:
                    raise ExpectedExceptionWasDifferent((
                        "Expected exception '{0}', instead "
                        "'{1}' was raised."
                    ).format(self._exception_type, error_details['exception_type']))
            
                if error_details['text'] == self._exception_text:
                    return
                else:
                    raise ExpectedExceptionMessageWasDifferent((
                        "Expected exception '{0}' was raised, but message was different.\n"
                        "\n"
                        "ACTUAL:\n"
                        "{1}\n"
                        "\n"
                        "EXPECTED:\n"
                        "{2}"
                    ).format(
                        self._exception_type,
                        error_details['text'],
                        self._exception_text,
                    ))
            else:
                raise ExpectedExceptionButWasNoException("expected exception but was no exception")
        else:
            if error_path.exists():
                error_details = json.loads(error_path.bytes().decode('utf8'))
                raise UnexpectedException(error_details['text'])
        
        
