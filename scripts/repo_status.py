#!/usr/bin/env python3
"""
Cold Front Forge - Repository Status Dashboard & Lifecycle Manager

Scans open-source CAD projects for README.md metadata, prints a color-coded
terminal status table, and synchronizes lifecycle stage updates across both
project READMEs and the root README.md project matrix table.
"""

from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

IGNORED_DIRS = {".git", ".vault-cache", "lib", "templates", "scripts", "assets", "node_modules"}

STAGES: dict[int, dict[str, str]] = {
    1: {"name": "Draft", "color": "yellow", "desc": "Concept / WIP CAD"},
    2: {"name": "Testing", "color": "orange", "desc": "Prototyping & tolerance testing"},
    3: {"name": "Validation", "color": "blue", "desc": "Print-verified / release candidate"},
    4: {"name": "Released", "color": "green", "desc": "Verified & ready for community printing"},
    5: {"name": "Archived", "color": "lightgrey", "desc": "Deprecated / superseded"},
}

STAGE_ALIASES: dict[str, int] = {
    "1": 1,
    "draft": 1,
    "wip": 1,
    "concept": 1,
    "2": 2,
    "testing": 2,
    "test": 2,
    "proto": 2,
    "prototyping": 2,
    "3": 3,
    "validation": 3,
    "validate": 3,
    "rc": 3,
    "candidate": 3,
    "4": 4,
    "released": 4,
    "release": 4,
    "prod": 4,
    "ready": 4,
    "5": 5,
    "archived": 5,
    "archive": 5,
    "deprecated": 5,
}

PROJECT_ALIASES: dict[str, str] = {
    "billy": "billy-ball",
    "ghostface": "ghostface-ball",
    "jason": "jason-ball",
    "tester": "clearance-tester",
    "k2-se": "k2-se-tool-holder",
    "tool-holder": "k2-se-tool-holder",
    "caddy": "cold-snap-desk-caddy",
    "desk-caddy": "cold-snap-desk-caddy",
    "sorter": "cold-snap-sorter",
    "wedge": "cold-snap-wedge",
    "exhibit": "cold-snap-exhibit",
    "frost-bite": "entry-1-frost-bite",
}

ANSI_COLORS: dict[str, str] = {
    "yellow": "\033[93m",
    "orange": "\033[33m",
    "blue": "\033[94m",
    "green": "\033[92m",
    "lightgrey": "\033[90m",
    "bold": "\033[1m",
    "cyan": "\033[96m",
    "reset": "\033[0m",
}

TITLE_RE = re.compile(r"^#\s+(.+)$", re.MULTILINE)
STATUS_BADGE_RE = re.compile(
    r"Status-([A-Za-z_]+)-(yellow|orange|blue|green|lightgrey)"
)
LIFECYCLE_BADGE_RE = re.compile(
    r"Lifecycle-Stage_?(\d+)(?:-(yellow|orange|blue|green|lightgrey))?"
)
PRIMARY_MATERIAL_RE = re.compile(
    r"^-\s+\*\*Primary Material:\*\*\s*(.+)$", re.MULTILINE
)
READINESS_LINE_RE = re.compile(
    r"^>\s+\*\*Release Status:\*\*.*$", re.MULTILINE
)


def enable_ansi() -> bool:
    """Enable ANSI colors on Windows terminals when supported."""
    if os.environ.get("NO_COLOR"):
        return False
    if os.name == "nt":
        os.system("")
    return sys.stdout.isatty() or bool(os.environ.get("WT_SESSION")) or bool(os.environ.get("TERM"))


def colorize(text: str, color: str, use_color: bool) -> str:
    """Wrap text in ANSI color codes if terminal color is enabled."""
    if not use_color or color not in ANSI_COLORS:
        return text
    return f"{ANSI_COLORS[color]}{text}{ANSI_COLORS['reset']}"


def discover_projects(root: Path = REPO_ROOT) -> list[Path]:
    """Find all project directories containing both a Makefile and README.md."""
    projects: list[Path] = []
    for current_root, dirs, files in os.walk(root):
        dirs[:] = sorted(
            d for d in dirs if not d.startswith(".") and d not in IGNORED_DIRS
        )
        current_path = Path(current_root)
        if current_path == root:
            continue
        if "Makefile" in files and "README.md" in files:
            projects.append(current_path)
    return sorted(projects, key=lambda p: p.relative_to(root).as_posix())


def parse_project(project_dir: Path, root: Path = REPO_ROOT) -> dict[str, object]:
    """Extract status, lifecycle stage, material, and STL count for a project."""
    readme_text = (project_dir / "README.md").read_text(encoding="utf-8")

    title_match = TITLE_RE.search(readme_text)
    title = title_match.group(1).strip() if title_match else project_dir.name

    status_match = STATUS_BADGE_RE.search(readme_text)
    if status_match:
        status_name = status_match.group(1).replace("_", " ")
        status_color = status_match.group(2)
    else:
        status_name = "Unknown"
        status_color = "lightgrey"

    stage_match = LIFECYCLE_BADGE_RE.search(readme_text)
    stage_num = int(stage_match.group(1)) if stage_match else 0

    mat_match = PRIMARY_MATERIAL_RE.search(readme_text)
    material = mat_match.group(1).strip() if mat_match else "PLA+"

    models_dir = project_dir / "models"
    if models_dir.is_dir():
        stl_count = sum(1 for _ in models_dir.rglob("*.stl"))
    else:
        stl_count = sum(1 for _ in project_dir.rglob("*.stl"))

    scad_count = sum(1 for _ in project_dir.rglob("*.scad"))

    return {
        "dir": project_dir,
        "slug": project_dir.name,
        "rel_path": project_dir.relative_to(root).as_posix(),
        "title": title,
        "status": status_name,
        "color": status_color,
        "stage": stage_num,
        "material": material,
        "stl_count": stl_count,
        "scad_count": scad_count,
    }


def print_status_table(projects: list[dict[str, object]]) -> None:
    """Render a color-coded CLI status dashboard."""
    use_color = enable_ansi()

    if not projects:
        print("No projects found.")
        return

    headers = ("Project", "Status", "Stage", "Material", "STLs", "Path")
    rows: list[tuple[str, str, str, str, str, str]] = []
    for p in projects:
        stage_str = f"Stage {p['stage']}" if p["stage"] else "-"
        rows.append(
            (
                str(p["slug"]),
                str(p["status"]),
                stage_str,
                str(p["material"]),
                str(p["stl_count"]),
                str(p["rel_path"]),
            )
        )

    widths = [
        max(len(h), *(len(r[i]) for r in rows)) for i, h in enumerate(headers)
    ]

    print()
    print(colorize("Cold Front Forge - Project Status Dashboard", "bold", use_color))
    print("-" * (sum(widths) + 3 * (len(widths) - 1)))

    header_line = "   ".join(h.ljust(widths[i]) for i, h in enumerate(headers))
    print(colorize(header_line, "cyan", use_color))
    print("   ".join("-" * w for w in widths))

    for p, r in zip(projects, rows):
        color = str(p["color"])
        cols = [
            r[0].ljust(widths[0]),
            colorize(r[1].ljust(widths[1]), color, use_color),
            colorize(r[2].ljust(widths[2]), color, use_color),
            r[3].ljust(widths[3]),
            r[4].rjust(widths[4]),
            r[5].ljust(widths[5]),
        ]
        print("   ".join(cols))

    total_stls = sum(int(p["stl_count"]) for p in projects)
    print("-" * (sum(widths) + 3 * (len(widths) - 1)))
    print(f"Total: {len(projects)} projects | {total_stls} compiled STLs\n")


def resolve_project(query: str, projects: list[Path], root: Path = REPO_ROOT) -> Path:
    """Resolve a project directory by path, folder name, alias, or substring."""
    q = query.strip().lower().replace("\\", "/")
    if not q:
        raise ValueError("Project name cannot be empty. Pass project=<name>.")

    q_aliased = PROJECT_ALIASES.get(q, q)

    for p in projects:
        rel = p.relative_to(root).as_posix().lower()
        if rel == q or rel == q_aliased:
            return p

    for p in projects:
        if p.name.lower() == q or p.name.lower() == q_aliased:
            return p

    matches = [
        p
        for p in projects
        if q in p.name.lower() or q in p.relative_to(root).as_posix().lower()
    ]
    if len(matches) == 1:
        return matches[0]
    if len(matches) > 1:
        names = ", ".join(p.name for p in matches)
        raise ValueError(f"Ambiguous project '{query}'. Matches: {names}")

    available = ", ".join(p.name for p in projects)
    raise ValueError(f"Project '{query}' not found. Available: {available}")


def resolve_stage(stage_arg: str) -> int:
    """Resolve a stage number (1-5) or stage name/alias."""
    key = stage_arg.strip().lower()
    if key in STAGE_ALIASES:
        return STAGE_ALIASES[key]
    valid = ", ".join(f"{k}={v['name']}" for k, v in STAGES.items())
    raise ValueError(f"Invalid stage '{stage_arg}'. Valid stages: {valid}")


def update_project_readme(project_dir: Path, stage_num: int) -> None:
    """Update status badge, lifecycle badge, and readiness line in project README.md."""
    readme_path = project_dir / "README.md"
    content = readme_path.read_text(encoding="utf-8")
    stage = STAGES[stage_num]
    name = stage["name"]
    color = stage["color"]
    desc = stage["desc"]

    if STATUS_BADGE_RE.search(content):
        content = STATUS_BADGE_RE.sub(f"Status-{name}-{color}", content)
    else:
        raise ValueError(
            f"Missing Status badge in {readme_path.relative_to(REPO_ROOT)}"
        )

    if LIFECYCLE_BADGE_RE.search(content):
        content = LIFECYCLE_BADGE_RE.sub(
            lambda m: (
                f"Lifecycle-Stage_{stage_num}-{color}"
                if m.group(2)
                else f"Lifecycle-Stage_{stage_num}"
            ),
            content,
        )
    else:
        raise ValueError(
            f"Missing Lifecycle badge in {readme_path.relative_to(REPO_ROOT)}"
        )

    readiness_line = f"> **Release Status:** Stage {stage_num} ({name}) — {desc}."
    if READINESS_LINE_RE.search(content):
        content = READINESS_LINE_RE.sub(readiness_line, content)

    readme_path.write_text(content, encoding="utf-8")


def update_root_readme(rel_path: str, stage_num: int, root: Path = REPO_ROOT) -> bool:
    """Update the matching project row in the root README.md project matrix table."""
    root_readme = root / "README.md"
    if not root_readme.is_file():
        return False

    stage = STAGES[stage_num]
    name = stage["name"]
    color = stage["color"]

    lines = root_readme.read_text(encoding="utf-8").splitlines(keepends=True)
    updated = False
    new_lines: list[str] = []

    for line in lines:
        if line.lstrip().startswith("|") and rel_path in line:
            line = STATUS_BADGE_RE.sub(f"Status-{name}-{color}", line)
            line = re.sub(r"\bStage\s+\d+\b", f"Stage {stage_num}", line)
            updated = True
        new_lines.append(line)

    if updated:
        root_readme.write_text("".join(new_lines), encoding="utf-8")
    return updated


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Cold Front Forge project status dashboard and lifecycle updater."
    )
    parser.add_argument("--project", help="Project name, alias, or relative path")
    parser.add_argument("--stage", help="Target lifecycle stage (1-5 or name)")
    args = parser.parse_args()

    project_dirs = discover_projects(REPO_ROOT)

    if args.project is not None or args.stage is not None:
        if not args.project or not args.stage:
            print(
                "Error: Both project=<name> and stage=<stage> are required.",
                file=sys.stderr,
            )
            return 1
        try:
            target_dir = resolve_project(args.project, project_dirs, REPO_ROOT)
            stage_num = resolve_stage(args.stage)
            update_project_readme(target_dir, stage_num)
            rel_path = target_dir.relative_to(REPO_ROOT).as_posix()
            root_updated = update_root_readme(rel_path, stage_num, REPO_ROOT)
        except ValueError as exc:
            print(f"Error: {exc}", file=sys.stderr)
            return 1

        stage_info = STAGES[stage_num]
        print(
            f"Updated {rel_path} -> Stage {stage_num} ({stage_info['name']}, {stage_info['color']})"
        )
        if root_updated:
            print("Synchronized root README.md project matrix.")
        else:
            print(
                f"Warning: No matching row for '{rel_path}' found in root README.md.",
                file=sys.stderr,
            )
        return 0

    parsed = [parse_project(p, REPO_ROOT) for p in project_dirs]
    print_status_table(parsed)
    return 0


if __name__ == "__main__":
    sys.exit(main())
