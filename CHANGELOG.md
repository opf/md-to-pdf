## [Unreleased]

## [0.0.22] - 2024-02-01

- fix(markly): follow renamed property

## [0.0.21] - 2024-02-01

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
