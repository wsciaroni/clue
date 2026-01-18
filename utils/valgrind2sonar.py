import sys
import xml.etree.ElementTree as ET
import json
import os

def parse_valgrind_xml(xml_file):
    try:
        tree = ET.parse(xml_file)
        root = tree.getroot()
    except ET.ParseError:
        print(f"Error parsing XML file: {xml_file}")
        return []

    issues = []

    for error in root.findall('error'):
        kind = error.find('kind').text if error.find('kind') is not None else "Unknown"
        what = error.find('xwhat/text').text if error.find('xwhat/text') is not None else "Unknown Error"

        # Determine severity and type based on kind
        severity = "MAJOR"
        issue_type = "CODE_SMELL"

        if "Leak" in kind:
            severity = "CRITICAL"
            issue_type = "BUG"
        elif "Invalid" in kind or "Uninit" in kind:
            severity = "CRITICAL"
            issue_type = "BUG"

        stack = error.find('stack')
        if stack is None:
            continue

        # Find the first frame that is part of the source code (skipping libraries if possible)
        primary_location = None

        for frame in stack.findall('frame'):
            file_node = frame.find('file')
            line_node = frame.find('line')

            if file_node is not None and line_node is not None:
                file_path = file_node.text
                line = int(line_node.text)

                # Valgrind often outputs absolute paths or relative to build dir
                # We need to normalize path to be relative to project root for Sonar

                rel_path = file_path
                if os.path.isabs(file_path):
                    # Try to make it relative to CWD (assumed to be project root)
                    try:
                        rel_path = os.path.relpath(file_path, os.getcwd())
                    except ValueError:
                        pass # Keep absolute if on different drive (Windows) or failure

                # Simple check to filter out system files if running from repo root
                if not os.path.exists(rel_path):
                     # If the file doesn't exist relative to CWD, it might be a system file or build artifact
                     # we might want to skip it to avoid Sonar errors about missing files
                     # However, sometimes Valgrind reports build/../source/file.cpp which might be valid
                     # Let's trust it if it doesn't look like /usr or /lib
                     if file_path.startswith("/usr") or file_path.startswith("/lib") or file_path.startswith("/bin"):
                         continue

                primary_location = {
                    "message": f"{kind}: {what}",
                    "filePath": rel_path,
                    "textRange": {
                        "startLine": line,
                        "endLine": line
                    }
                }
                break

        if primary_location:
            issue = {
                "engineId": "valgrind",
                "ruleId": kind,
                "severity": severity,
                "type": issue_type,
                "primaryLocation": primary_location
            }
            issues.append(issue)

    return issues

def main():
    if len(sys.argv) != 3:
        print("Usage: valgrind2sonar.py <valgrind_xml_path> <sonar_json_path>")
        sys.exit(1)

    xml_path = sys.argv[1]
    json_path = sys.argv[2]

    issues = parse_valgrind_xml(xml_path)

    report = {"issues": issues}

    with open(json_path, 'w') as f:
        json.dump(report, f, indent=2)

    print(f"Converted {len(issues)} issues from {xml_path} to {json_path}")

if __name__ == "__main__":
    main()
