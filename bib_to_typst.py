#!/usr/bin/env python3
"""
Bibliography parser for Typst CV template
Converts .bib files to Typst-compatible data structures
"""

import re
import argparse
from pathlib import Path
from typing import Dict, List, Any

def parse_bib_file(bib_file: str) -> List[Dict[str, Any]]:
    """Parse a .bib file and return a list of publication dictionaries"""
    
    with open(bib_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Regular expression to match BibTeX entries
    entry_pattern = r'@(\w+)\s*{\s*([^,]+)\s*,\s*(.*?)\n\s*}'
    field_pattern = r'(\w+)\s*=\s*[{"](.*?)["}](?=\s*,|\s*$)'
    
    publications = []
    
    # Find all BibTeX entries
    entries = re.findall(entry_pattern, content, re.DOTALL | re.IGNORECASE)
    
    for entry_type, entry_key, entry_fields in entries:
        pub = {
            'type': entry_type.lower(),
            'key': entry_key.strip()
        }
        
        # Parse fields within the entry
        fields = re.findall(field_pattern, entry_fields, re.DOTALL | re.IGNORECASE)
        
        for field_name, field_value in fields:
            # Clean up field values
            field_value = field_value.strip()
            field_value = re.sub(r'\s+', ' ', field_value)  # Normalize whitespace
            field_value = field_value.replace('{', '').replace('}', '')  # Remove extra braces
            
            pub[field_name.lower()] = field_value
        
        publications.append(pub)
    
    return publications

def format_authors_for_typst(authors: str) -> str:
    """Format author names for Typst"""
    # Handle common BibTeX author separators
    authors = authors.replace(' and ', ' and ')
    return authors

def generate_typst_data(publications: List[Dict[str, Any]]) -> str:
    """Generate Typst data structure from publications"""
    
    typst_entries = []
    
    for pub in publications:
        # Create a Typst dictionary entry
        entry_lines = [f'    (']
        entry_lines.append(f'      type: "{pub["type"]}",')
        
        # Add common fields
        common_fields = ['author', 'title', 'journal', 'booktitle', 'volume', 'number', 
                        'pages', 'year', 'publisher', 'address', 'editor', 'doi', 'url', 'note']
        
        for field in common_fields:
            if field in pub:
                value = pub[field]
                if field == 'author':
                    value = format_authors_for_typst(value)
                # Escape quotes in values
                value = value.replace('"', '\\"')
                entry_lines.append(f'      {field}: "{value}",')
        
        entry_lines.append('    ),')
        typst_entries.append('\n'.join(entry_lines))
    
    # Combine all entries
    typst_data = '  let all-pubs = (\n' + '\n'.join(typst_entries) + '\n  )'
    
    return typst_data

def update_template_with_data(template_file: str, typst_data: str, output_file: str = None):
    """Update the Typst template with the generated bibliography data"""
    
    if output_file is None:
        output_file = template_file.replace('.typ', '_with_bib.typ')
    
    with open(template_file, 'r', encoding='utf-8') as f:
        template_content = f.read()
    
    # Find the display-publications function and replace the sample data
    pattern = r'(let display-publications\(.*?\) = \{.*?)(let sample-pubs = \(.*?\))(.*?let sorted-pubs = sample-pubs\.sorted)'
    
    def replacement(match):
        before = match.group(1)
        after = match.group(3)
        return f"{before}{typst_data}{after}let sorted-pubs = all-pubs.sorted"
    
    updated_content = re.sub(pattern, replacement, template_content, flags=re.DOTALL)
    
    # Remove the note about bibliography import
    updated_content = re.sub(
        r'text\(fill: color-accent.*?Note: To use bibliography import.*?\]\s*v\(0\.5em\)',
        '',
        updated_content,
        flags=re.DOTALL
    )
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(updated_content)
    
    print(f"Updated template saved to: {output_file}")

def main():
    parser = argparse.ArgumentParser(description="Convert .bib file to Typst CV template")
    parser.add_argument('bib_file', help='Path to the .bib file')
    parser.add_argument('template_file', help='Path to the Typst template file')
    parser.add_argument('-o', '--output', help='Output file path (optional)')
    
    args = parser.parse_args()
    
    # Parse the bibliography
    print(f"Parsing bibliography from: {args.bib_file}")
    publications = parse_bib_file(args.bib_file)
    print(f"Found {len(publications)} publications")
    
    # Generate Typst data
    typst_data = generate_typst_data(publications)
    
    # Update template
    update_template_with_data(args.template_file, typst_data, args.output)

if __name__ == "__main__":
    main()