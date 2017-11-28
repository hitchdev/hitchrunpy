from commandlib import run, Command
import hitchpython
from hitchstory import StoryCollection, StorySchema, BaseEngine, exceptions, expected_exception
from hitchrun import expected
from strictyaml import Str, Optional
from pathquery import pathq
import hitchtest
import hitchdoc
from commandlib import python
from hitchrun import hitch_maintenance
from hitchrun import DIR
from hitchrunpy import ExamplePythonCode, HitchRunPyException
from templex import Templex, NonMatching, TemplexException
import colorama


class Engine(BaseEngine):
    """Python engine for running tests."""

    schema = StorySchema(
        preconditions={
            Optional("long string"): Str(),
            Optional("runner python version"): Str(),
            Optional("working python version"): Str(),
            Optional("setup"): Str(),
            Optional("code"): Str(),
        },
    )

    def __init__(self, paths, settings):
        self.path = paths
        self.settings = settings

    def set_up(self):
        """Set up your applications and the test environment."""
        from path import Path
        self.path.state = self.path.gen.joinpath("state")
        self.path.working_dir = self.path.gen.joinpath("working")
        self.path.share = Path("~/.hitchpkg/").expand()

        self.doc = hitchdoc.Recorder(
            hitchdoc.HitchStory(self),
            self.path.gen.joinpath('storydb.sqlite'),
        )

        if self.path.state.exists():
            self.path.state.rmtree(ignore_errors=True)
        self.path.state.mkdir()

        if self.path.working_dir.exists():
            self.path.working_dir.rmtree(ignore_errors=True)
        self.path.working_dir.mkdir()

        self.python_package = hitchpython.PythonPackage(
            self.preconditions.get('python_version', '3.5.0')
        )
        self.python_package.build()

        self.pip = self.python_package.cmd.pip
        self.python = self.python_package.cmd.python

        # Install debugging packages
        with hitchtest.monitor([self.path.key.joinpath("debugrequirements.txt")]) as changed:
            if changed:
                run(self.pip("install", "-r", "debugrequirements.txt").in_dir(self.path.key))

        # Uninstall and reinstall
        with hitchtest.monitor(pathq(self.path.project.joinpath("hitchrunpy"))) as changed:
            if changed:
                self.pip("uninstall", "hitchrunpy", "-y").ignore_errors().run()
                self.pip("install", ".").in_dir(self.path.project).run()

        self.example_python_code = ExamplePythonCode(
            self.python,
            self.path.state,
        ).with_code(
            self.preconditions.get('code', '')
        ).with_setup_code(
            self.preconditions.get('setup').replace("/path/to/working_dir", self.path.working_dir)
                                           .replace("/path/to/share_dir/", self.path.share)
                                           .replace("/path/to/build_dir/", self.path.state)
                                           .replace(
                                               "{{ pyver }}",
                                               self.preconditions['working python version'],
                                           )
        ).with_long_strings(
            long_string=self.preconditions.get("long string", "")
        )

    @expected_exception(HitchRunPyException)
    def run_code(self):
        self.example_python_code.run()

    @expected_exception(TemplexException)
    @expected_exception(HitchRunPyException)
    def raises_exception(self, message=None, exception_type=None):
        try:
            result = self.example_python_code.expect_exceptions().run()
            result.exception_was_raised(exception_type)
            processed_message = '\n'.join([
                line.rstrip() for line in result.exception.message
                    .replace(self.path.state, "/path/to/code")
                    .replace(self.path.share, "/path/to/share")
                    .replace(colorama.Fore.RED, "[[ RED ]]")
                    .replace(colorama.Style.BRIGHT, "[[ BRIGHT ]]")
                    .replace(colorama.Style.DIM, "[[ DIM ]]")
                    .replace(colorama.Fore.RESET, "[[ RESET FORE ]]")
                    .replace(colorama.Style.RESET_ALL, "[[ RESET ALL ]]")
                    .split('\n')
            ])
            Templex(processed_message).assert_match(message)
        except NonMatching:
            if self.settings.get("rewrite"):
                self.current_step.update(message=processed_message)
            else:
                raise

    def file_contains(self, filename, contents):
        assert self.path.working_dir.joinpath(filename).bytes().decode('utf8') == contents

    def pause(self, message="Pause"):
        import IPython
        IPython.embed()

    def on_success(self):
        if self.settings.get("rewrite"):
            self.new_story.save()


@expected(exceptions.HitchStoryException)
def tdd(*words):
    """
    Run test with words.
    """
    print(
        StoryCollection(
            pathq(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
        ).shortcut(*words).play().report()
    )


@expected(exceptions.HitchStoryException)
def testfile(filename):
    """
    Run all stories in filename 'filename'.
    """
    print(
        StoryCollection(
            pathq(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
        ).in_filename(filename).ordered_by_name().play().report()
    )


def regression():
    """
    Regression test - run all tests and linter.
    """
    lint()
    results = StoryCollection(
        pathq(DIR.key).ext("story"), Engine(DIR, {})
    ).ordered_by_name().play()
    print(results.report())


def rewriteall():
    """
    Run regression tests with story rewriting on.
    """
    print(
        StoryCollection(
            pathq(DIR.key).ext("story"), Engine(DIR, {"rewrite": True})
        ).ordered_by_name().play().report()
    )


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


def hitch(*args):
    """
    Use 'h hitch --help' to get help on these commands.
    """
    hitch_maintenance(*args)


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


def docgen():
    """
    Generate documentation.
    """
    docpath = DIR.project.joinpath("docs")

    if not docpath.exists():
        docpath.mkdir()

    documentation = hitchdoc.Documentation(
        DIR.gen.joinpath('storydb.sqlite'),
        'doctemplates.yml'
    )

    for story in documentation.stories:
        story.write(
            "rst",
            docpath.joinpath("{0}.rst".format(story.slug))
        )
