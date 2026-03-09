"""
Build resources.json from _resources_template.json by replacing all
{{PIXI_PROJECT_ROOT}} tokens with the absolute PIXI_PROJECT_ROOT path.
"""

import json
import os
import sys


def replace_tokens(obj: object, project_root: str) -> object:
    if isinstance(obj, str):
        return obj.replace("{{PIXI_PROJECT_ROOT}}", project_root)
    if isinstance(obj, dict):
        return {k: replace_tokens(v, project_root) for k, v in obj.items()}
    if isinstance(obj, list):
        return [replace_tokens(item, project_root) for item in obj]
    return obj


def main() -> None:
    project_root = os.environ.get("PIXI_PROJECT_ROOT")
    if not project_root:
        print("Error: PIXI_PROJECT_ROOT is not set", file=sys.stderr)
        sys.exit(1)

    input_path = os.path.join(project_root, "scripts", "_resources_template.json")
    output_path = os.path.join(project_root, "resources.json")

    with open(input_path) as f:
        data = json.load(f)

    data = replace_tokens(data, project_root)

    with open(output_path, "w") as f:
        json.dump(data, f, indent=4)

    print(f"Written {output_path}")


if __name__ == "__main__":
    main()
