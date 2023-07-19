# Styles


## External fonts

Key: `fonts`

A list of specifications about external fonts

```yml
fonts:
- name: Vollkorn
  pathname: vollkorn
  filename: Vollkorn-Regular.ttf
- name: OpenSans
  pathname: opensans
  filename: OpenSans-Regular.ttf
```

## External Fallback font

Key: `fallback_font`

If a sign is not found in the specified font, a fallback font can be used

```yml
fallback_font:
  name: NotoSansSymbols2
  pathname: NotoSansSymbols2
  filename: NotoSansSymbols2-Regular.ttf
```

| Key | Description | Data type |
| - | - | - |
| `name` | **Font name**<br/>The name of the fallback font<br/>Example: `NotoSansSymbols2` | string |
| `pathname` | **Font directory**<br/>The name of directory where the fallback font file is located<br/>Example: `NotoSansSymbols2` | string |
| `filename` | **Font file name**<br/>The fallback font file name<br/>Example: `NotoSansSymbols2-Regular.ttf` | string |

## Page settings

Key: `page`

Properties to set the basic page settings

```yml
page:
  font: Vollkorn
  size: 10
  color: '000000'
  page_size: A4
  page_layout: portrait
  margin: 20mm
```

| Key | Description | Data type |
| - | - | - |
| `page_layout` | **Page layout**<br/>The layout of a page<br/>Example: `portrait`<br/>Valid values:<br/>`portrait`, `landscape` | string |
| `page_size` | **Page size**<br/>The size of a page<br/>Example: `EXECUTIVE`<br/>Valid values:<br/>`EXECUTIVE`, `TABLOID`, `LETTER`, `LEGAL`, `FOLIO`, `A0`, `A1`, `A2`, `A3`, `A4`, `A5`, `A6`, `A7`, `A8`, `A9`, `A10`, `B0`, `B1`, `B2`, `B3`, `B4`, `B5`, `B6`, `B7`, `B8`, `B9`, `B10`, `C0`, `C1`, `C2`, `C3`, `C4`, `C5`, `C6`, `C7`, `C8`, `C9`, `C10`, `RA0`, `RA1`, `RA2`, `RA3`, `RA4`, `SRA0`, `SRA1`, `SRA2`, `SRA3`, `SRA4`, `4A0`, `2A0` | string |
| … | See [Font Properties](#font_properties) |  |
| … | See [Margin Properties](#margin_properties) |  |

## Page Header 1

Key: `page_header`

Up to three header sections are supported. The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file.

```yml
page_header:
  align: left
  filter_pages:
    - 1
    - 2
  offset: -30
```

| Key | Description | Data type |
| - | - | - |
| `filter_pages` | **Pages to skip**<br/>A list of pages to skip<br/>Examples: `- 1 = not on first page`, `- 2 = not on second page` | array of integer |
| `align` | **Alignment**<br/>How the element should be aligned<br/>Example: `center`<br/>Valid values:<br/>`left`, `center`, `right` | string |
| `offset` | **Offset position from page top**<br/>A positive or negative number and an optional unit<br/>Example: `-30` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Page Header 2

Key: `page_header_2`

```yml
page_header_2:
  align: center
  filter_pages:
    - 1
  offset: -30
```

| Key | Description | Data type |
| - | - | - |
| `filter_pages` | **Pages to skip**<br/>A list of pages to skip<br/>Examples: `- 1 = not on first page`, `- 2 = not on second page` | array of integer |
| `align` | **Alignment**<br/>How the element should be aligned<br/>Example: `center`<br/>Valid values:<br/>`left`, `center`, `right` | string |
| `offset` | **Offset position from page top**<br/>A positive or negative number and an optional unit<br/>Example: `-30` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Page Header 3

Key: `page_header_3`

```yml
page_header_3:
  align: right
  filter_pages:
    - 1
  offset: -30
```

| Key | Description | Data type |
| - | - | - |
| `filter_pages` | **Pages to skip**<br/>A list of pages to skip<br/>Examples: `- 1 = not on first page`, `- 2 = not on second page` | array of integer |
| `align` | **Alignment**<br/>How the element should be aligned<br/>Example: `center`<br/>Valid values:<br/>`left`, `center`, `right` | string |
| `offset` | **Offset position from page top**<br/>A positive or negative number and an optional unit<br/>Example: `-30` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Page Footer

Key: `page_footer`

Up to three footer sections are supported.<br/>The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file.

```yml
page_footer:
  align: left
  offset: -30
  size: 8
```

| Key | Description | Data type |
| - | - | - |
| `filter_pages` | **Pages to skip**<br/>A list of pages to skip<br/>Examples: `- 1 = not on first page`, `- 2 = not on second page` | array of integer |
| `align` | **Alignment**<br/>How the element should be aligned<br/>Example: `center`<br/>Valid values:<br/>`left`, `center`, `right` | string |
| `offset` | **Offset position from page bottom**<br/>A positive or negative number and an optional unit<br/>Example: `-30` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Page Footer 2

Key: `page_footer_2`

```yml
page_footer_2:
  align: center
  offset: -30
  size: 8
```

| Key | Description | Data type |
| - | - | - |
| `filter_pages` | **Pages to skip**<br/>A list of pages to skip<br/>Examples: `- 1 = not on first page`, `- 2 = not on second page` | array of integer |
| `align` | **Alignment**<br/>How the element should be aligned<br/>Example: `center`<br/>Valid values:<br/>`left`, `center`, `right` | string |
| `offset` | **Offset position from page bottom**<br/>A positive or negative number and an optional unit<br/>Example: `-30` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Page Footer 3

Key: `page_footer_3`

```yml
page_footer_3:
  align: right
  offset: -30
  size: 8
```

| Key | Description | Data type |
| - | - | - |
| `filter_pages` | **Pages to skip**<br/>A list of pages to skip<br/>Examples: `- 1 = not on first page`, `- 2 = not on second page` | array of integer |
| `align` | **Alignment**<br/>How the element should be aligned<br/>Example: `center`<br/>Valid values:<br/>`left`, `center`, `right` | string |
| `offset` | **Offset position from page bottom**<br/>A positive or negative number and an optional unit<br/>Example: `-30` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Page Logo

Key: `page_logo`

A logo image in the header.<br/>The image filename must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file. 

```yml
page_logo:
  disabled: false
  align: left
  offset: -30
  max_width: 40mm
```

| Key | Description | Data type |
| - | - | - |
| `filter_pages` | **Pages to skip**<br/>A list of pages to skip<br/>Examples: `- 1 = not on first page`, `- 2 = not on second page` | array of integer |
| `align` | **Alignment**<br/>How the element should be aligned<br/>Example: `center`<br/>Valid values:<br/>`left`, `center`, `right` | string |
| `max_width` | **Maximum width of the image**<br/>A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `height` | **Height of the image**<br/>A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `offset` | **Offset position from page top**<br/>A positive or negative number and an optional unit<br/>Example: `-30` | number or string<br/>See [Units](#units) |
| `disabled` | **Disable Logo**<br/>Disable or enable the page logo<br/>Example: `false` | boolean |

## Paragraph

Key: `paragraph`

A block of text

```yml
paragraph:
  align: justify
  padding_bottom: 2mm
```

| Key | Description | Data type |
| - | - | - |
| `align` | **Alignment**<br/>How the text should be aligned<br/>Valid values:<br/>`left`, `center`, `right`, `justify` | string |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Header

Key: `header`

Default styling for headers on all levels.<br/>use header_`x` as key for header level `x`.

```yml
header:
  styles:
    - bold
  padding_top: 2mm
  padding_bottom: 2mm
header_1:
  size: 14
  styles:
    - bold
    - italic
header_2:
  size: 12
  styles:
    - bold
```

| Key | Description | Data type |
| - | - | - |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Header Level 1

Key: `header_1`

| Key | Description | Data type |
| - | - | - |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Header Level 2

Key: `header_2`

| Key | Description | Data type |
| - | - | - |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Code

Key: `code`

Styling to denote a word or phrase as code

```yml
code:
  font: Consolas
  color: '880000'
```

| Key | Description | Data type |
| - | - | - |
| … | See [Font Properties](#font_properties) |  |

## Code Block

Key: `codeblock`

Styling to denote a paragraph as code

```yml
codeblock:
  background_color: F5F5F5
  font: Consolas
  size: 8
  color: '880000'
  padding: 3mm
  margin_top: 2mm
  margin_bottom: 2mm
```

| Key | Description | Data type |
| - | - | - |
| `background_color` | **A color**<br/>A color in RRGGBB format<br/>Example: `F0F0F0` | string |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |
| … | See [Margin Properties](#margin_properties) |  |

## Blockquote

Key: `blockquote`

Styling to denote a paragraph as quote

```yml
blockquote:
  background_color: f4f9ff
  size: 14
  styles:
    - italic
  color: 0f3b66
  border_color: b8d6f4
  border_width: 1
  no_border_right: true
  no_border_left: false
  no_border_bottom: true
  no_border_top: true
```

| Key | Description | Data type |
| - | - | - |
| `background_color` | **A color**<br/>A color in RRGGBB format<br/>Example: `F0F0F0` | string |
| … | See [Font Properties](#font_properties) |  |
| … | See [Border Properties](#border_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |
| … | See [Margin Properties](#margin_properties) |  |

## Link

Key: `link`

Styling a clickable link

```yml
link:
  color: '000088'
```

| Key | Description | Data type |
| - | - | - |
| … | See [Font Properties](#font_properties) |  |

## Table

Key: `table`

```yml
table:
  auto_width: true
  header:
    background_color: F0F0F0
    no_repeating: true
    size: 12
  cell:
    background_color: 000FFF
    size: 10
```

| Key | Description | Data type |
| - | - | - |
| `auto_width` | **Automatic column widths**<br/>Table columns should fit the content, equal spacing of columns if value is `false` | boolean |
| `header` | **Table Header**<br/>Properties for table header cell style<br/>See [Table Header](#table_header) | object |
| `cell` | **Table Cell**<br/>Properties for table cell style<br/>See [Table Cell](#table_cell) | object |
| … | See [Margin Properties](#margin_properties) |  |
| … | See [Border Properties](#border_properties) |  |

#### Table Cell

Key: `cell`

Properties for table cell style

| Key | Description | Data type |
| - | - | - |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |
| … | See [Border Properties](#border_properties) |  |

## Headless Table

Key: `headless_table`

Tables without or empty header rows can be styled differently.

```yml
headless_table:
  auto_width: true
  cell:
    style: underline
    background_color: 000FFF
```

| Key | Description | Data type |
| - | - | - |
| `auto_width` | **Automatic column widths**<br/>Table columns should fit the content, equal spacing of columns if value is `false` | boolean |
| `cell` | **Table Cell**<br/>Properties for table cell style<br/>See [Table Cell](#table_cell) | object |
| … | See [Margin Properties](#margin_properties) |  |
| … | See [Border Properties](#border_properties) |  |

## Image

Key: `image`

Styling of images

```yml
image:
  max_width: 50mm
  margin: 2mm
  margin_bottom: 3mm
  align: center
  caption:
    align: center
    size: 8
```

| Key | Description | Data type |
| - | - | - |
| `max_width` | **Maximum width of the image**<br/>A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `align` | **Alignment**<br/>How the element should be aligned<br/>Example: `center`<br/>Valid values:<br/>`left`, `center`, `right` | string |
| `caption` | **Image caption**<br/>Styling for the caption below an image<br/>See [Image caption](#image_caption) | object |
| … | See [Margin Properties](#margin_properties) |  |

#### Image caption

Key: `caption`

Styling for the caption below an image

| Key | Description | Data type |
| - | - | - |
| `align` | **Alignment**<br/>How the text should be aligned<br/>Valid values:<br/>`left`, `center`, `right`, `justify` | string |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Image classes

Key: `image_classes`

Styling for images by class names

| Key | Description | Data type |
| - | - | - |
| your choice | See [Image](#image) |  |

## Horizontal Rule

Key: `hrule`

Styling for horizontal lines

```yml
hrule:
  line_width: 1
```

| Key | Description | Data type |
| - | - | - |
| `line_width` | **Sets the stroke width of the horizontal rule**<br/>A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Margin Properties](#margin_properties) |  |

## Footnote Reference

Key: `footnote_reference`

```yml
footnote_reference:
  size: 13
  styles:
    - superscript
  color: '000088'
```

| Key | Description | Data type |
| - | - | - |
| … | See [Font Properties](#font_properties) |  |

## Footnote Definition

Key: `footnote_definition`

```yml
footnote_definition:
  point:
    size: 13
    styles:
    - superscript
    color: '000000'
```

| Key | Description | Data type |
| - | - | - |
| `point` | **Footnote Definition Point**<br/>Styling of the point sign for footnotes<br/>See [Footnote Definition Point](#footnote_definition_point) | object |

#### Footnote Definition Point

Key: `point`

Styling of the point sign for footnotes

| Key | Description | Data type |
| - | - | - |
| … | See [Font Properties](#font_properties) |  |

## Ordered List

Key: `ordered_list`

Default styling for ordered lists on all levels.<br/>use ordered_list_`x` as key for ordered list level `x`.

```yml
ordered_list:
  spacing: 2mm
  point_inline: false
```

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `point_inline` | **Inline Point**<br/>Do not indent paragraph text, but include the point into the first paragraph | boolean |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Ordered List Level 1

Key: `ordered_list_1`

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `point_inline` | **Inline Point**<br/>Do not indent paragraph text, but include the point into the first paragraph | boolean |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Ordered List Level 2

Key: `ordered_list_2`

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `point_inline` | **Inline Point**<br/>Do not indent paragraph text, but include the point into the first paragraph | boolean |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Ordered List Point

Key: `ordered_list_point`

Default styling for ordered list points on all levels.<br/>use ordered_list_point_`x` as key for ordered list points level `x`.

```yml
ordered_list_point:
  template: "<number>."
  alphabetical: false
  spacing: 0.75mm
  spanning: true
```

| Key | Description | Data type |
| - | - | - |
| `spacing` | A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `alphabetical` | **Alphabetical bullet points**<br/>Convert the list item number into a character, eg. `a.` `b.` `c.` | boolean |
| `spanning` | **Spanning**<br/>Use the width of the largest bullet as indention. | boolean |
| `template` | **Template**<br/>customize what the prefix should contain, eg. `(<number>)` | string |
| … | See [Font Properties](#font_properties) |  |

## Ordered List Point Level 1

Key: `ordered_list_point_1`

| Key | Description | Data type |
| - | - | - |
| `spacing` | A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `alphabetical` | **Alphabetical bullet points**<br/>Convert the list item number into a character, eg. `a.` `b.` `c.` | boolean |
| `spanning` | **Spanning**<br/>Use the width of the largest bullet as indention. | boolean |
| `template` | **Template**<br/>customize what the prefix should contain, eg. `(<number>)` | string |
| … | See [Font Properties](#font_properties) |  |

## Ordered List Point Level 2

Key: `ordered_list_point_2`

| Key | Description | Data type |
| - | - | - |
| `spacing` | A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `alphabetical` | **Alphabetical bullet points**<br/>Convert the list item number into a character, eg. `a.` `b.` `c.` | boolean |
| `spanning` | **Spanning**<br/>Use the width of the largest bullet as indention. | boolean |
| `template` | **Template**<br/>customize what the prefix should contain, eg. `(<number>)` | string |
| … | See [Font Properties](#font_properties) |  |

## Unordered List

Key: `unordered_list`

Default styling for unordered lists on all levels.<br/>use unordered_list_`x` as key for unordered list level `x`.

```yml
unordered_list:
  spacing: 1.5mm
  padding_top: 2mm
  padding_bottom: 2mm
```

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Unordered List Level 1

Key: `unordered_list_1`

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Unordered List Level 2

Key: `unordered_list_2`

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Unordered List Point

Key: `unordered_list_point`

Default styling for unordered list points on all levels.<br/>use unordered_list_point_`x` as key for unordered list points level `x`.

```yml
unordered_list_point:
  sign: "•"
  spacing: 0.75mm
```

| Key | Description | Data type |
| - | - | - |
| `sign` | **Sign**<br/>The 'bullet point' character used in the list | string |
| `spacing` | **Spacing**<br/>Space between point and list item content<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Unordered List Point Level 1

Key: `unordered_list_point_1`

| Key | Description | Data type |
| - | - | - |
| `sign` | **Sign**<br/>The 'bullet point' character used in the list | string |
| `spacing` | **Spacing**<br/>Space between point and list item content<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Unordered List Point Level 2

Key: `unordered_list_point_2`

| Key | Description | Data type |
| - | - | - |
| `sign` | **Sign**<br/>The 'bullet point' character used in the list | string |
| `spacing` | **Spacing**<br/>Space between point and list item content<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Task List

Key: `task_list`

```yml
task_list:
  spacing: 2mm
```

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |
| … | See [Padding Properties](#padding_properties) |  |

## Task List Point

Key: `task_list_point`

```yml
task_list_point:
  checked: "☑"
  unchecked: "☐"
  spacing: 0.75mm
```

| Key | Description | Data type |
| - | - | - |
| `checked` | **Checked sign**<br/>Sign for checked state of a task list item | string |
| `unchecked` | **Unchecked sign**<br/>Sign for unchecked state of a task list item | string |
| `spacing` | **Spacing**<br/>Additional space between point and list item content<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font Properties](#font_properties) |  |

## Default Field Settings

Key: `fields_default`

| Key | Description | Data type |
| - | - | - |
| `pdf_language` |  | string |
| `pdf_header` |  | string |
| `pdf_header_2` |  | string |
| `pdf_header_3` |  | string |
| `pdf_footer` |  | string |
| `pdf_footer_2` |  | string |
| `pdf_footer_3` |  | string |
| `pdf_header_logo` |  | string |
| `pdf_hyphenation` |  | boolean |
| `pdf_fields` | **Default Custom Fields Values**<br/>See [Default Custom Fields Values](#default_custom_fields_values) | object |

#### Default Custom Fields Values

Key: `pdf_fields`

| Key | Description | Data type |
| - | - | - |
| your choice | See [](#) |  |

## Font Properties

Key: `font`

Properties to set the font style

```yml
font: Vollkorn
size: 10
character_spacing: 0
styles: []
color: '000000'
leading: 2
```

| Key | Description | Data type |
| - | - | - |
| `font` | **Font name**<br/>The name of the font to use | string |
| `size` | **Font size**<br/>The size of the font to use<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `character_spacing` | **Character Spacing**<br/>Additional space between characters<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `leading` | **Leading**<br/>Additional space between lines<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `color` | **Font color**<br/>The color of the font to use<br/>Example: `F0F0F0` | string |
| `styles` | **Font styles**<br/>The styles of the font to use<br/>Example: `[bold]`<br/>Valid values:<br/>`bold`, `italic`, `underline`, `strikethrough`, `superscript`, `subscript` | array of string |

## Margin Properties

Key: `margin`

Properties to set margins

| Key | Description | Data type |
| - | - | - |
| `margin` | **Margin**<br/>One value for margin on all sides<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `margin_left` | **Margin left**<br/>Margin only on the left side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `margin_right` | **Margin right**<br/>Margin only on the right side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `margin_top` | **Margin top**<br/>Margin only on the top side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `margin_bottom` | **Margin bottom**<br/>Margin only on the bottom side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |

## Padding Properties

Key: `padding`

Properties to set paddings

| Key | Description | Data type |
| - | - | - |
| `padding` | **Padding**<br/>One value for padding on all sides<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `padding_left` | **Padding left**<br/>Padding only on the left side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `padding_right` | **Padding right**<br/>Padding only on the right side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `padding_top` | **Padding top**<br/>Padding only on the top side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `padding_bottom` | **Padding bottom**<br/>Padding only on the bottom side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |

## Border Properties

Key: `border`

Properties to set borders

```yml
border_color: F000FF
border_color_top: 000FFF
border_color_bottom: FFF000
no_border_left: true
no_border_right: true
border_width: 0.25mm
border_width_left: 0.5mm
border_width_right: 0.5mm
```

| Key | Description | Data type |
| - | - | - |
| `border_width` | **Border width**<br/>One value for border line width on all sides<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `border_width_left` | **Border width left**<br/>Border width only on the left side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `border_width_top` | **Border width top**<br/>Border width only on the top side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `border_width_right` | **Border width right**<br/>Border width only on the right side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `border_width_bottom` | **Border width bottom**<br/>Border width only on the bottom side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `border_color` | **Border color**<br/>One value for border color on all sides<br/>Example: `F0F0F0` | string |
| `border_color_left` | **Border color left**<br/>Border color only on the left side<br/>Example: `F0F0F0` | string |
| `border_color_top` | **Border color top**<br/>Border color only on the top side<br/>Example: `F0F0F0` | string |
| `border_color_right` | **Border color right**<br/>Border color only on the right side<br/>Example: `F0F0F0` | string |
| `border_color_bottom` | **Border color bottom**<br/>Border color only on the bottom side<br/>Example: `F0F0F0` | string |
| `no_border` | **Disable borders**<br/>Turn off borders on all sides | boolean |
| `no_border_left` | **Disable border left**<br/>Turn off border on the left sides | boolean |
| `no_border_top` | **Disable border top**<br/>Turn off border on the top sides | boolean |
| `no_border_right` | **Disable border right**<br/>Turn off border on the right sides | boolean |
| `no_border_bottom` | **Disable border bottom**<br/>Turn off border on the bottom sides | boolean |
## Units

available units are

`mm` - Millimeter, `cm` - Centimeter, `dm` - Decimeter, `m` - Meter

`in` - Inch, `ft` - Feet, `yr` - Yard

`pt` - [Postscript point](https://en.wikipedia.org/wiki/Point_(typography)#Desktop_publishing_point) (default if no unit is used)