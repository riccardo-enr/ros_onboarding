# ros_onboarding

Onboarding guide for Politecnico di Torino master's thesis students joining
the UAV research group: Linux, Git and GitHub, ROS 2, PX4 and Gazebo.

**Start here: <https://riccardo-enr.github.io/ros_onboarding/>**

One LaTeX source, three outputs.

- Website: <https://riccardo-enr.github.io/ros_onboarding/>
- PDF: [docs/onboarding.pdf](docs/onboarding.pdf)
- HTML (single page): [docs/index.html](docs/index.html)
- Markdown, readable on GitHub: [docs/onboarding.md](docs/onboarding.md)

Target versions (Ubuntu, ROS 2, PX4, `px4_msgs`) are in the "Versions" table
near the top of `onboarding.tex`. Bump them there.

## Build

```bash
pixi run render   # figures, then the PDF into docs/ (needs TeX Live with dvisvgm)
pixi run docs     # Markdown and HTML into docs/ (needs Docker and act)
```

`pixi run docs` runs `.github/workflows/docs.yml` locally with `act`, in the
`pandoc/core` container. `pandoc/callouts.lua` turns the `note` and `tip`
boxes into GitHub alerts (Markdown) or styled divs (HTML), and swaps the PDF
figures for their SVGs.

Figures are standalone TikZ files in `figures/`. `figures/build.py` compiles
each to PDF (for LaTeX) and SVG (for HTML and Markdown). The generated files
are committed.

Keep `onboarding.tex` to what pandoc reads: `lstlisting` for code, the `note`
and `tip` environments for callouts, and plain `longtable` tables without
`\endhead`/`\endlastfoot`.
