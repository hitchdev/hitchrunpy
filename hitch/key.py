from hitchstory import StoryCollection, GivenDefinition, GivenProperty, validate
from hitchstory import InfoDefinition, InfoProperty
from hitchstory import BaseEngine, no_stacktrace_for, HitchStoryException
from hitchrun import expected
from strictyaml import Str, MapPattern, Map, Enum, Optional
from pathquery import pathquery
from click import argument, group, pass_context
from hitchrunpy import ExamplePythonCode, HitchRunPyException
import hitchpylibrarytoolkit
from templex import Templex
import dirtemplate
import colorama
from path import Path

class Directories:
    gen = Path("/gen")
    key = Path("/src/hitch/")
    project = Path("/src/")
    share = Path("/gen")


DIR = Directories()


@group(invoke_without_command=True)
@pass_context
def cli(ctx):
    """Integration test command line interface."""
    pass



toolkit = hitchpylibrarytoolkit.ProjectToolkit(
    "hitchrunpy",
    DIR,
)


class Engine(BaseEngine):
    """Python engine for running tests."""

    given_definition = GivenDefinition(
        long_string=GivenProperty(Str()),
        runner_python_version=GivenProperty(Str()),
        working_python_version=GivenProperty(Str()),
        setup=GivenProperty(Str()),
        code=GivenProperty(Str()),
        files=GivenProperty(MapPattern(Str(), Str())),
    )

    info_definition = InfoDefinition(
        status=InfoProperty(schema=Enum(["experimental", "stable"])),
        docs=InfoProperty(schema=Str()),
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

        for filepath, content in self.given.get("files", {}).items():
            fullpath = self.path.state.joinpath(filepath)
            if not fullpath.dirname().exists():
                fullpath.dirname().makedirs()
            fullpath.write_text(content)

        
        self.pylibrary = hitchpylibrarytoolkit.PyLibraryBuild(
            "hitchrunpy",
            self.path,
        ).with_python_version(self.given.get("python_version", "3.7.0"))
        self.pylibrary.ensure_built()
        self.python = self.pylibrary.bin.python

    def _story_friendly_output(self, content):
        return "\n".join(
            [
                line.rstrip()
                for line in content.replace(self.path.gen / "working", "/path/to/code")
                .replace(self.path.share, "/path/to/share")
                .replace(colorama.Fore.RED, "[[ RED ]]")
                .replace(colorama.Style.BRIGHT, "[[ BRIGHT ]]")
                .replace(colorama.Style.DIM, "[[ DIM ]]")
                .replace(colorama.Fore.RESET, "[[ RESET FORE ]]")
                .replace(colorama.Style.RESET_ALL, "[[ RESET ALL ]]")
                .split("\n")
            ]
        )

    def _setup_code(self):
        return (
            self.given.get("setup", "")
            .replace("/path/to/working_dir", self.path.working_dir)
            .replace("/path/to/share_dir", self.path.state)
            .replace("/path/to/build_dir", self.path.state)
            .replace("{{ pyver }}", self.given["working python version"])
        )

    @no_stacktrace_for(AssertionError)
    @no_stacktrace_for(HitchRunPyException)
    @validate(
        code=Str(),
        will_output=Str(),
        raises=Map({Optional("type"): Str(), Optional("message"): Str()}),
    )
    def run(self, code, will_output=None, raises=None):
        self.example_py_code = (
            ExamplePythonCode(self.python, self.path.state)
            .with_terminal_size(160, 100)
            .with_setup_code(self._setup_code())
            .with_long_strings(long_string=self.given.get("long string"))
            .with_timeout(10.0)
        )
        to_run = self.example_py_code.with_code(code)

        if self.settings.get("cprofile"):
            to_run = to_run.with_cprofile(
                self.path.profile.joinpath("{0}.dat".format(self.story.slug))
            )

        if raises is None:
            result = to_run.run()

            actual_output = self._story_friendly_output(result.output)

            if will_output is not None:
                try:
                    Templex(will_output).assert_match(actual_output)
                except AssertionError:
                    if self.settings.get("rewrite"):
                        self.current_step.update(**{"will output": actual_output})
                    else:
                        raise

        else:
            exception_type = raises.get("type")
            message = raises.get("message")

            try:
                result = to_run.expect_exceptions().run()
                result.exception_was_raised(exception_type)
                exception_message = self._story_friendly_output(
                    result.exception.message
                )
                Templex(exception_message).assert_match(message)
            except AssertionError:
                if self.settings.get("rewrite"):
                    new_raises = raises.copy()
                    new_raises["message"] = exception_message
                    self.current_step.update(raises=new_raises)
                else:
                    raise

    @no_stacktrace_for(AssertionError)
    def file_in_working_dir_contains(self, filename, contents):
        assert (
            self.path.state.joinpath("..", "working", "working").joinpath(filename).bytes().decode("utf8") == contents
        )

    @no_stacktrace_for(AssertionError)
    def file_in_dir_contains(self, filename, contents):
        assert self.path.state.joinpath(filename).bytes().decode("utf8") == contents

    @no_stacktrace_for(AssertionError)
    def file_written_by_code_contains(self, filename, contents):
        filepath = self.path.state / "working" / filename
        try:
            Templex(contents).assert_match(filepath.text())
        except AssertionError:
            if self.settings.get("rewrite"):
                self.current_step.update(
                    contents=filepath.text()
                )
            else:
                raise

    def pause(self, message="Pause"):
        import IPython

        IPython.embed()


def _storybook(settings):
    return StoryCollection(pathquery(DIR.key).ext("story"), Engine(DIR, settings))


@cli.command()
@argument("words", nargs=-1)
def bdd(words):
    """
    Run test with words.
    """
    _storybook({"rewrite": False}).shortcut(*words).play()


@cli.command()
@argument("words", nargs=-1)
def rbdd(words):
    """
    Run executable spec and rewrite if output has changed.
    """
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
    ).shortcut(*words).play()


@cli.command()
def regressfile(filename):
    """
    Run all stories in filename 'filename'.
    """
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
    ).in_filename(filename).ordered_by_name().play().report()


@cli.command()
def regression():
    """
    Regression test - run all tests and linter.
    """
    #toolkit.lint(exclude=["__init__.py"])
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {})
    ).ordered_by_name().play()


@cli.command()
def rewriteall():
    """
    Run regression tests with story rewriting on.
    """
    StoryCollection(
        pathquery(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
    ).ordered_by_name().play().report()


@cli.command()
def reformat():
    """
    Reformat using black and then relint.
    """
    toolkit.reformat()


@cli.command()
def lint():
    """
    Lint project code and hitch code.
    """
    toolkit.lint(exclude=["__init__.py"])


@cli.command()
def deploy(version):
    """
    Deploy to pypi as specified version.
    """
    hitchpylibrarytoolkit.deploy(version)


@cli.command()
def docgen():
    """
    Build documentation.
    """
    toolkit.docgen(Engine(DIR, {}))


@cli.command()
def readmegen():
    """
    Build documentation.
    """
    toolkit.readmegen(Engine(DIR, {}))


if __name__ == "__main__":
    cli()