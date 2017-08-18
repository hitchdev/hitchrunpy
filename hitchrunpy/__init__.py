from copy import copy
from jinja2.environment import Environment
from commandlib import Command
from jinja2 import DictLoader
from strictyaml import load
from path import Path

HITCHRUNPY_DIR = Path(__file__).dirname().abspath()

class HitchRunPyException(Exception):
    pass


class UnexpectedException(HitchRunPyException):
    pass


class ExamplePythonCode(object):
    def __init__(self, code):
        self._code = code
        
        self._is_equal = False
        self._lhs = None
        self._rhs = None
    
    def is_equal(self, lhs, rhs):
        new_epy = copy(self)
        new_epy._lhs = lhs
        new_epy._rhs = rhs
        new_epy._is_equal = True
        return new_epy

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
        else:
            example_python_code.write_text(env.get_template("base").render(
                setup=self._code,
                error_path=error_path,
            ))
            
        
        pycommand(example_python_code).in_dir(working_dir).run()
        
        if error_path.exists():
            raise UnexpectedException(error_path.bytes().decode('utf8'))
        
        
