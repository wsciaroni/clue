#!/usr/bin/env python3
"""
Converts LCOV coverage report to SonarQube Generic Test Data XML format.
Usage: python3 lcov2sonar.py <lcov_file> <output_xml_file>
"""

import sys
import os
import xml.dom.minidom

def parse_lcov(lcov_path):
    coverage_data = {}
    current_file = None

    with open(lcov_path, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('SF:'):
                current_file = line[3:]
                if current_file not in coverage_data:
                    coverage_data[current_file] = {}
            elif line.startswith('DA:'):
                if current_file:
                    parts = line[3:].split(',')
                    line_num = int(parts[0])
                    hit_count = int(parts[1])
                    # In Sonar Generic XML: covered="true" if hit > 0
                    # We can store hit count if we want, but covered=true/false is mandatory?
                    # "lineToCover" element has "covered" attribute (boolean).
                    # It also has "branchesToCover" and "coveredBranches" if applicable.

                    # For simplicity, we just mark covered=true if hit > 0
                    is_covered = hit_count > 0
                    coverage_data[current_file][line_num] = is_covered
            elif line.startswith('end_of_record'):
                current_file = None

    return coverage_data

def generate_xml(coverage_data, output_path):
    doc = xml.dom.minidom.Document()
    root = doc.createElement('coverage')
    root.setAttribute('version', '1')
    doc.appendChild(root)

    for file_path, lines in coverage_data.items():
        file_node = doc.createElement('file')
        file_node.setAttribute('path', file_path)
        root.appendChild(file_node)

        for line_num, is_covered in lines.items():
            line_node = doc.createElement('lineToCover')
            line_node.setAttribute('lineNumber', str(line_num))
            line_node.setAttribute('covered', str(is_covered).lower())
            file_node.appendChild(line_node)

    with open(output_path, 'w') as f:
        f.write(doc.toprettyxml(indent="  "))

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python3 lcov2sonar.py <lcov_file> <output_xml_file>")
        sys.exit(1)

    lcov_file = sys.argv[1]
    output_file = sys.argv[2]

    if not os.path.exists(lcov_file):
        print(f"Error: {lcov_file} not found.")
        sys.exit(1)

    data = parse_lcov(lcov_file)
    generate_xml(data, output_file)
    print(f"Generated {output_file}")
