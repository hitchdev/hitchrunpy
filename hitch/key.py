from commandlib import Command
from hitchstory import StoryCollection, GivenDefinition, GivenProperty
from hitchstory import BaseEngine, no_stacktrace_for, HitchStoryException
from hitchrun import expected
from strictyaml import Str
from pathquery import pathquery
from commandlib import python
from hitchrun import hitch_maintenance
from hitchrun import DIR
from hitchrunpy import ExamplePythonCode, HitchRunPyException
import hitchpylibrarytoolkit
from templex import Templex
import colorama


class Engine(BaseEngine):
    """Python engine for running tests."""

    given_definition = GivenDefinition(
        long_string=GivenProperty(Str()),
        runner_python_version=GivenProperty(Str()),
        working_python_version=GivenProperty(Str()),
        setup=GivenProperty(Str()),
        code=GivenProperty(Str()),
    )

    def __init__(self, paths, settings):
        self.path = paths
        self.settings = settings

    def set_up(self):
        """Set up your applications and the test environment."""
        self.path.state = self.path.gen / "state"
        self.path.working_dir = self.path.gen / "working"

        if self.path.state.exists():
            self.path.state.rmtree(ignore_errors=True)
        self.path.state.mkdir()

        if self.path.working_dir.exists():
            self.path.working_dir.rmtree(ignore_errors=True)
        self.path.working_dir.mkdir()

        self.python = hitchpylibrarytoolkit.project_build(
            "hitchrunpy",
            self.path,
            self.given["runner python version"],
        ).bin.python

        self.example_python_code = ExamplePythonCode(
            self.python,
            self.path.state,
        ).with_code(
            self.given.get('code', '')
        ).with_setup_code(
            self.given.get('setup').replace("/path/to/working_dir", self.path.working_dir)
                                   .replace("/path/to/share_dir/", self.path.share)
                                   .replace("/path/to/build_dir/", self.path.state)
                                   .replace(
                                       "{{ pyver }}",
                                       self.given['working python version'],
                                   )
        ).with_long_strings(
            long_string=self.given.get("long string", "")
        )

    def _output_swap(self, content):
        return '\n'.join([
            line.rstrip() for line in content
                .replace(self.path.gen / "working", "/path/to/code")
                .replace(self.path.share, "/path/to/share")
                .replace(colorama.Fore.RED, "[[ RED ]]")
                .replace(colorama.Style.BRIGHT, "[[ BRIGHT ]]")
                .replace(colorama.Style.DIM, "[[ DIM ]]")
                .replace(colorama.Fore.RESET, "[[ RESET FORE ]]")
                .replace(colorama.Style.RESET_ALL, "[[ RESET ALL ]]")
                .split('\n')
        ])

    @no_stacktrace_for(HitchRunPyException)
    def run_code(self):
        self.example_python_code.run()

    @no_stacktrace_for(AssertionError)
    @no_stacktrace_for(HitchRunPyException)
    def raises_exception(self, message=None, exception_type=None):
        try:
            result = self.example_python_code.expect_exceptions().run()
            result.exception_was_raised(exception_type)
            processed_message = self._output_swap(result.exception.message)
            Templex(processed_message).assert_match(message)
        except AssertionError:
            if self.settings.get("rewrite"):
                self.current_step.update(message=processed_message)
            else:
                raise

    def file_in_working_dir_contains(self, filename, contents):
        assert self.path.working_dir.joinpath(filename).bytes().decode('utf8') == contents

    def file_in_written_by_code_contains(self, filename, contents):
        assert self.path.state.joinpath(filename).bytes().decode('utf8') == contents

    def pause(self, message="Pause"):
        import IPython
        IPython.embed()

    def on_success(self):
        if self.settings.get("rewrite"):
            self.new_story.save()


@expected(HitchStoryException)
def bdd(*words):
    """
    Run test with words.
    """
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {"rewrite": False})
    ).shortcut(*words).play()


@expected(HitchStoryException)
def rbdd(*words):
    """
    Run executable spec and rewrite if output has changed.
    """
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
    ).shortcut(*words).play()


@expected(HitchStoryException)
def regressfile(filename):
    """
    Run all stories in filename 'filename'.
    """
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
    ).in_filename(filename).ordered_by_name().play().report()


def regression():
    """
    Regression test - run all tests and linter.
    """
    lint()
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {})
    ).ordered_by_name().play()


def rewriteall():
    """
    Run regression tests with story rewriting on.
    """
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
    ).ordered_by_name().play().report()


def lint():
    """
    Lint all code.
    """
    python("-m", "flake8")(
        DIR.project.joinpath("hitchrunpy"),
        "--max-line-length=100",
        "--exclude=__init__.py",
    ).run()
    python("-m", "flake8")(
        DIR.key.joinpath("key.py"),
        "--max-line-length=100",
        "--exclude=__init__.py",
    ).run()
    print("Lint success!")


def deploy(version):
    """
    Deploy to pypi as specified version.
    """
    NAME = "hitchrunpy"
    git = Command("git").in_dir(DIR.project)
    version_file = DIR.project.joinpath("VERSION")
    old_version = version_file.bytes().decode('utf8')
    if version_file.bytes().decode("utf8") != version:
        DIR.project.joinpath("VERSION").write_text(version)
        git("add", "VERSION").run()
        git("commit", "-m", "RELEASE: Version {0} -> {1}".format(
            old_version,
            version
        )).run()
        git("push").run()
        git("tag", "-a", version, "-m", "Version {0}".format(version)).run()
        git("push", "origin", version).run()
    else:
        git("push").run()

    # Set __version__ variable in __init__.py, build sdist and put it back
    initpy = DIR.project.joinpath(NAME, "__init__.py")
    original_initpy_contents = initpy.bytes().decode('utf8')
    initpy.write_text(
        original_initpy_contents.replace("DEVELOPMENT_VERSION", version)
    )
    python("setup.py", "sdist").in_dir(DIR.project).run()
    initpy.write_text(original_initpy_contents)

    # Upload to pypi
    python(
        "-m", "twine", "upload", "dist/{0}-{1}.tar.gz".format(NAME, version)
    ).in_dir(DIR.project).run()
