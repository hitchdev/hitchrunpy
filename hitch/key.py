from pathquery import pathquery
from commandlib import Command
from hitchstory import StoryCollection
from click import argument, group, pass_context
import hitchpylibrarytoolkit
from path import Path
from engine import Engine


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
    toolkit.lint(exclude=["__init__.py"])
    toolkit.validate_readmegen(Engine(DIR, {}))
    toolkit.validate_docgen(Engine(DIR, {}))
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
@argument("version")
def deploy(version):
    """
    Deploy to pypi as specified version.
    """
    initpy = DIR.project.joinpath("hitchrunpy", "__init__.py")
    original_initpy_contents = initpy.bytes().decode("utf8")
    initpy.write_text(
        original_initpy_contents.replace("DEVELOPMENT_VERSION", version)
    )
    python("setup.py", "sdist").in_dir(DIR.project).run()
    initpy.write_text(original_initpy_contents)

    # Upload to pypi
    python(
        "-m",
        "twine",
        "upload",
        "dist/{0}-{1}.tar.gz".format("hitchrunpy", version),
    ).in_dir(DIR.project).run()


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
