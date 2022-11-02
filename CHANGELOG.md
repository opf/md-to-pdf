## [Unreleased]

## [0.0.6] - 2022-11-02

- fix(prawn): caching of text fragment measurement did fail for same text in different sizes
- fix(pdf): ignore image if missing 

## [0.0.5] - 2022-11-01

- feat(pdf): support rendering into result string

BREAKING:

- style_filename - markdown parameters switched

## [0.0.4] - 2022-11-01

- feat(blockcode): support background color and border

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
