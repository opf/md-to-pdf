# Markdown-to-PDF

**WORK IN PROGRESS**, please expect changes to API and styling yml spec

## Installation

```bash
bundle add md_to_pdf --github opf/md-to-pdf
```

Requirements

* Ruby 3.0.3 or newer

## Usage

### Command line

bundle exec md_to_pdf `<styling file>` `<source file>` `<dest file>`

Example:

```bash
bundle exec md_to_pdf ./demo/demo.yml ./demo/demo.md ./demo/generated/demo.pdf
```

### As Library

```ruby
require 'md_to_pdf'

#...
# file processing
styling_filename = './demo/demo.yml'
source_filename = './demo/demo.md'
dest_filename = './demo/generated/demo.pdf'
MarkdownToPDF.generate_markdown_pdf(source_filename, styling_filename, dest_filename)

# example with raw markdown pre-processing
markdown_string = File.read(source_filename)
markdown_string += 'An additional text at the bottom'
images_path = File.dirname(source_filename)
MarkdownToPDF.generate_markdown_string_pdf(markdown_string, styling_filename, images_path, dest_filename)
```
## Known Limitations

* Table cells that exceed the height of a single page are truncated (see [prawn-table#41](https://github.com/prawnpdf/prawn-table/issues/41)).   

## Markdown

Please have a look at [demo.md](./demo/demo.md) for an overview and examples of all supported markdown syntax

Currently **not** supported:

* Images inline in text in tables (images will be placed in own line)
* Images inline in text (images will be placed in own line)
* Remote images e.g. via http (images will be skipped)

## Styling

A yml config file is used to set the pdf styling

Please have a look at [docs/STYLING.md](docs/STYLING.md) for description.

## Frontmatter

Meta Information and header/footer content is defined in a head section of the markdown file

Please have a look at [docs/FRONTMATTER.md](docs/FRONTMATTER.md) for description.
