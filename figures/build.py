import pathlib
import subprocess

HERE = pathlib.Path(__file__).resolve().parent
JUNK = (".aux", ".log", ".dvi")


def run(*cmd):
    subprocess.run(cmd, cwd=HERE, check=True, stdout=subprocess.DEVNULL)


for tex in sorted(HERE.glob("*.tex")):
    name = tex.stem
    run("pdflatex", "-interaction=nonstopmode", "-halt-on-error", tex.name)
    run("latex", "-interaction=nonstopmode", "-halt-on-error", tex.name)
    run("dvisvgm", "--no-fonts", "-o", f"{name}.svg", f"{name}.dvi")
    for ext in JUNK:
        (HERE / f"{name}{ext}").unlink(missing_ok=True)
    print(f"built {name}.pdf {name}.svg")
