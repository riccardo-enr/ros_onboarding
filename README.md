# ros_onboarding

Onboarding guide for Politecnico di Torino master's thesis students joining
the UAV research group: Linux, Git and GitHub, ROS 2, PX4 and Gazebo.

**Start here: <https://riccardo-enr.github.io/ros_onboarding/>**

One LaTeX source, three outputs.

- Website: <https://riccardo-enr.github.io/ros_onboarding/>
- PDF: [docs/onboarding.pdf](docs/onboarding.pdf)
- Markdown, readable on GitHub: [docs/onboarding.md](docs/onboarding.md)

Target versions (Ubuntu, ROS 2, PX4, `px4_msgs`) are in the "Versions" table
near the top of `onboarding.tex`. Bump them there.

## Build

```bash
pixi run render   # figures, then the PDF into docs/ (needs TeX Live with dvisvgm)
pixi run docs     # Markdown into docs/, the website into site/ (needs Docker and act)
```

`pixi run docs` runs `.github/workflows/docs.yml` locally with `act`, in the
`pandoc/core` container. On every push to `main` the same workflow builds the
website and deploys it to GitHub Pages: one page per section, laid out by
`pandoc/page.html` and `pandoc/style.css`. The PDF is not built in CI; commit
`docs/onboarding.pdf` after `pixi run render`. `pandoc/callouts.lua` turns the `note` and `tip`
boxes into GitHub alerts (Markdown) or styled divs (HTML), and swaps the PDF
figures for their SVGs.

Figures are standalone TikZ files in `figures/`. `figures/build.py` compiles
each to PDF (for LaTeX) and SVG (for HTML and Markdown). The generated files
are committed.

Keep `onboarding.tex` to what pandoc reads: `lstlisting` for code, the `note`
and `tip` environments for callouts, and plain `longtable` tables without
`\endhead`/`\endlastfoot`.
