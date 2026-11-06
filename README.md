# Amal Bose Mathew — Senior AWS DevOps Engineer (Portfolio)

A self-contained, high-end static portfolio for Amal Bose Mathew, Senior AWS
DevOps / DevSecOps and Cloud Engineer (6+ years). No build step, no
dependencies, no tracking — open it in a browser.

Content is sourced from the résumé and the live site
(https://amalbosemathew.github.io/) and expanded into rich, interactive pages.

## Files

- `index.html` — main page structure
- `project.html` — data-driven case-study page (`project.html?id=<project-id>`)
- `styles.css` — base theme and components
- `modern.css` — high-end layer: aurora background, glassmorphism, motion, section styling
- `data.js` — all content (profile, about, skills, experience, projects, certs)
- `graphics.js` — inline SVG icons, hero particle canvas, architecture diagram, donut gauges
- `motion.js` — scroll reveal, 3D tilt, magnetic buttons, cursor glow, intro, parallax, typing
- `app.js` — rendering, skill accordions, experience expand, project links

## Sections

Hero with live stats, About + highlight cards, filterable Skills (compact
accordions under "All"), a 5-role Experience timeline that expands on hover,
six production projects each linking to a full case study, animated proficiency
donuts, certifications, and a contact card (email, phone, LinkedIn, GitHub).

## Run it

```powershell
start devops-2026-site\index.html
```

Recommended (so multi-page navigation and backdrop-filter behave consistently):

```powershell
cd devops-2026-site
python -m http.server 8080
# open http://localhost:8080
```

> `python -m http.server` is long-running — run it yourself and stop with Ctrl+C.

## Deploying to GitHub Pages

This is a static site, so it drops straight into the existing
`amalbosemathew.github.io` repo. Copy the contents of this folder to the repo
root (or a `/docs` folder configured as the Pages source), commit, and push.

## Editing content

Everything is in `data.js` — profile, skills (each with a `category` and
`level`), experience, projects (each with a `detail` block that powers its case
study), and certifications. Changing content never requires touching HTML.

## Notes to verify

- **Résumé dates**: the source PDF lists "May 2026 – Present" (GTI) and
  "April 2025 – April 2025" (Primeweb). These look like typos. The site shows
  GTI as current and Primeweb as "2025" — update the exact months in `data.js`
  (`experience[].period`) once confirmed.
- Only certifications listed in the résumé are included.
