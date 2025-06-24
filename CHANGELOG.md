# Release notes

## [0.2.4] - 2025-06-24

- fix: html-links, inline a-tag without text

## [0.2.3] - 2025-06-23

- feature: support justify text alignment
- feature: allow default cell alignments for tables in styles
- fix: css centered vertical alignment of table cells is called "middle"

## [0.2.2] - 2025-06-19

- fix: for smart-header don't measure lists with all child nodes
- fix: html-table, always use yml styles as default, so e.g. borders have to be turned off explicitly if not wanted
- feat: html-table, implement css text-align/vertical-align for cells
- fix: limit images height to the page height

## [0.2.1] - 2025-04-22
 
- fix: html-table; include all supported html text formatting
- fix: html-table; include strikethrough formatting by [@prathamesh-vic](https://github.com/opf/md-to-pdf/pull/27)

## [0.2.0] - 2025-02-25
 
- fix: html-table; do not include zero width borders

BREAKING:

- drop ruby < 3.4

## [0.1.6] - 2025-02-24
 
- fix: html table cell border/background yml styles were not applied

## [0.1.5] - 2025-01-30

- feat: support for html tables cell borders styles
- feat: support for html tables cell outer border (overwrites cell border)
- feat: support for lists styles `decimal`, `lower-latin`, `lower-roman`, `upper-latin`, `upper-roman`

## [0.1.4] - 2025-01-07

- fix: smart header feature to avoid dangling header rows on page breaks with height measurements
- fix: avoid split of alert box first line on page breaks

## [0.1.3] - 2025-01-07

- feat: parse and use more html table cell css

## [0.1.2] - 2024-09-17

- feat: support page break markers
- feat: support for line breaks and paragraphs in html tables

## [0.1.1] - 2024-06-26

- fix: table header row with image crashed because of missing methods

## [0.1.0] - 2024-06-24

- feat: add support for mermaid diagrams if [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) is installed and available in the PATH
- feat: add support for Github alert blockquotes

BREAKING:

- styles now require a ˚alerts˚ key with settings for the alert blockquotes (see [docs/STYLING.md](docs/STYLING.md#alert-boxes-styled-blockquotes))
- command line tool parameters have been fixed to match the documentation
- Module users need to implement mermaid_cli_enabled? and return true to enable mermaid diagrams

## [0.0.27] - 2024-06-11

- fix(tables): better image handling in table autosizing
- fix(tables): better image handling in table cells

## [0.0.26] - 2024-02-15

- fix(tasklists): support nested tasklists and tasklist items with or without any text

## [0.0.25] - 2024-02-15
 
- feat(html table cell): better support for html lists

## [0.0.24] - 2024-02-05

- fix(html table cell): allow set a cell background color of empty cells; custom color overwrites default header color as-op 30 minutes ago

## [0.0.23] - 2024-01-15

- feat(html table cell): allow set a cell background color in html tables with style attribute

## [0.0.22] - 2024-01-02

- fix(markly): follow renamed property

## [0.0.21] - 2024-01-02

- chore(dependencies): commonmarker 1.x gem removed the possibility to parse and get the markdown AST; switched to markly fork

## [0.0.20] - 2023-08-10

- feat(html): support p-tag for inline html
- fix(codeblock): ignore empty table instead letting prawnpdf throw an exception

## [0.0.19] - 2023-07-05

- feat(image caption): support caption in markdown and figcaption in html
- test(paragraph): add align tests

## [0.0.18] - 2023-06-07

- feat(codeblock): create a table row per line instead of one large cell

## [0.0.17] - 2023-06-01

- fix(tables): add test and fix error for empty prawn cells

## [0.0.16] - 2023-05-25

- validation of yml styles with json schema
- use _ instead of - in yml style key names
- fix(images): handle invalid image specs

## [0.0.15] - 2023-05-09

- refactor(generator): split monolithic generator class into modules
- basic html tag support for tables, paragraphs, lists, links, images and formatting
- add rspec testing
- add rubocop linting
- fix: don't scale up small images
- fix: table.header.size has been ignored, now applied

## [0.0.14] - 2023-01-11

- chore(deps): update nokogiri dependency

## [0.0.13] - 2022-12-08

- feat(table): prevent single table header rows on the bottom of the page

## [0.0.12] - 2022-12-07

- feat(ordered list): optional spanning to the most width bullet point

## [0.0.11] - 2022-11-24

- feat(tables): allow disabling repeating header if table is split on pages

## [0.0.10] - 2022-11-09

- feat(tables): allow individual styling of headless tables

## [0.0.9] - 2022-11-08

- fix(fields): add to_s for yml fields parsed as non-string

## [0.0.8] - 2022-11-07

- feat(lists): allow defining spacing between bullet and list item content

## [0.0.7] - 2022-11-03

- feat(lists): allow defining spacing between list items

## [0.0.6] - 2022-11-02

- fix(prawn): caching of text fragment measurement did fail for same text in different sizes
- fix(pdf): ignore image if missing 

## [0.0.5] - 2022-11-01

- feat(pdf): support rendering into result string

BREAKING:

- style_filename - markdown parameters switched

## [0.0.4] - 2022-11-01

- feat(blockquote): support background color and border

BREAKING:

- use `<br-page/>` instead of `<br page>` to avoid having an unwanted break in html

## [0.0.3] - 2022-10-27
 
- feat(styling): uses css-ish values with unit

BREAKING: 

- *-mm specific keys removed

## [0.0.2] - 2022-10-27

- fix(header/footer): apply font to repeated elements; 
- feat(styling): allow declaring default frontmatter values

BREAKING: 

- feat(header/footer): renamed offset key name
- feat(header/footer): remove special page number settings => optional in all header and footers

## [0.0.1] - 2022-10-25

- Initial pre-release
