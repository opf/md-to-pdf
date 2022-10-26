
# Frontmatter

Frontmatter YML is supported for content set per markdown file:

```md
---
pdf_header: |
  Multiline Header
  with variable %variable-demo-1%
pdf_header_2: Another header
pdf_header_3: Behind Logo
pdf_footer: Some static footer
pdf_footer_2: Another footer
pdf_footer_3: "Page <page> of <total>"
pdf_header_logo: logo.png
pdf_language: en
pdf_hyphenation: false
pdf_fields:
  variable-demo-1: "one"
  variable-demo-2: "two"
---
```
TODO: Explain options

## Variable replacement

Add key-value pairs to the frontmatter header node `pdf_fields:`, use `%key%` to have them replaced.

`This is replaced: %variable-demo-1% and this is replaced: %variable-demo-2%.`

