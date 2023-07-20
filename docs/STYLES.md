
# YAML Styles

| Key | Description | Data type |
| - | - | - |
| `fonts` | **External fonts**<br/>A list of specifications about external fonts<br/>See [External font](#external-font) | array of object |
| `fallback_font` | **External fallback font**<br/>If a sign is not found in the specified font, a fallback font can be used<br/>See [External fallback font](#external-fallback-font) | object |
| `page` | **Page settings**<br/>Properties to set the basic page settings<br/>See [Page settings](#page-settings) | object |
| `page_header` | **Page header 1**<br/>Up to three header sections are supported. The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file.<br/>See [Page header](#page-header) | object |
| `page_header_2` | **Page header 2**<br/>See [Page header](#page-header) | object |
| `page_header_3` | **Page header 3**<br/>See [Page header](#page-header) | object |
| `page_footer` | **Page footer**<br/>Up to three footer sections are supported.<br/>The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file.<br/>See [Page footer](#page-footer) | object |
| `page_footer_2` | **Page footer 2**<br/>See [Page footer](#page-footer) | object |
| `page_footer_3` | **Page footer 3**<br/>See [Page footer](#page-footer) | object |
| `page_logo` | **Page logo**<br/>A logo image in the header.<br/>The image filename must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file. <br/>See [Page logo](#page-logo) | object |
| `paragraph` | **Paragraph**<br/>A block of text<br/>See [Paragraph](#paragraph) | object |
| `header` | **Header**<br/>Default styling for headers on all levels.<br/>use header_`x` as key for header level `x`.<br/>See [Header](#header) | object |
| `code` | **Code**<br/>Styling to denote a word or phrase as code<br/>See [Code](#code) | object |
| `codeblock` | **Code block**<br/>Styling to denote a paragraph as code<br/>See [Code block](#code-block) | object |
| `blockquote` | **Blockquote**<br/>Styling to denote a paragraph as quote<br/>See [Blockquote](#blockquote) | object |
| `link` | **Link**<br/>Styling a clickable link<br/>See [Link](#link) | object |
| `table` | **Table**<br/>See [Table](#table) | object |
| `headless_table` | **Headless table**<br/>Tables without or empty header rows can be styled differently.<br/>See [Headless table](#headless-table) | object |
| `image` | **Image**<br/>Styling of images<br/>See [Image](#image) | object |
| `image_classes` | **Image classes**<br/>Styling for images by class names<br/>See [Image classes](#image-classes) | object |
| `hrule` | **Horizontal rule**<br/>Styling for horizontal lines<br/>See [Horizontal rule](#horizontal-rule) | object |
| `footnote_reference` | **Footnote reference**<br/>See [Footnote reference](#footnote-reference) | object |
| `footnote_definition` | **Footnote definition**<br/>See [Footnote definition](#footnote-definition) | object |
| `ordered_list` | **Ordered list**<br/>Default styling for ordered lists on all levels.<br/>use ordered_list_`x` as key for ordered list level `x`.<br/>See [Ordered list level](#ordered-list-level) | object |
| `ordered_list_point` | **Ordered list point**<br/>Default styling for ordered list points on all levels.<br/>use ordered_list_point_`x` as key for ordered list points level `x`.<br/>See [Ordered list point level](#ordered-list-point-level) | object |
| `unordered_list` | **Unordered list**<br/>Default styling for unordered lists on all levels.<br/>use unordered_list_`x` as key for unordered list level `x`.<br/>See [Unordered list](#unordered-list) | object |
| `unordered_list_point` | **Unordered list point**<br/>Default styling for unordered list points on all levels.<br/>use unordered_list_point_`x` as key for unordered list points level `x`.<br/>See [Unordered list point](#unordered-list-point) | object |
| `task_list` | **Task list**<br/>See [Task list](#task-list) | object |
| `task_list_point` | **Task list point**<br/>See [Task list point](#task-list-point) | object |
| `fields_default` | **md-to-pdf default fields settings**<br/>See [md-to-pdf default fields settings](#md-to-pdf-default-fields-settings) | object |
| `header_1`<br/>`header_2`<br/>`header_x` | Header level<br/>See [Header](#header) | object |
| `ordered_list_1`<br/>`ordered_list_2`<br/>`ordered_list_x` | See [Ordered list level](#ordered-list-level) | object |
| `ordered_list_point_1`<br/>`ordered_list_point_2`<br/>`ordered_list_point_x` | See [Ordered list point level](#ordered-list-point-level) | object |
| `unordered_list_1`<br/>`unordered_list_2`<br/>`unordered_list_x` | Unordered list level<br/>See [Unordered list](#unordered-list) | object |
| `unordered_list_point_1`<br/>`unordered_list_point_2`<br/>`unordered_list_point_x` | Unordered list point level<br/>See [Unordered list point](#unordered-list-point) | object |

## Blockquote

Styling to denote a paragraph as quote

Key: `blockquote`

Example:
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
| `background_color` | **Color**<br/>A color in RRGGBB format<br/>Example: `F0F0F0` | string |
| … | See [Font properties](#font-properties) |  |
| … | See [Border properties](#border-properties) |  |
| … | See [Padding properties](#padding-properties) |  |
| … | See [Margin properties](#margin-properties) |  |

## Border properties

Properties to set borders

Key: `border`

Example:
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

## Code

Styling to denote a word or phrase as code

Key: `code`

Example:
```yml
code:
  font: Consolas
  color: '880000'
```

| Key | Description | Data type |
| - | - | - |
| … | See [Font properties](#font-properties) |  |

## Code block

Styling to denote a paragraph as code

Key: `codeblock`

Example:
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
| `background_color` | **Color**<br/>A color in RRGGBB format<br/>Example: `F0F0F0` | string |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |
| … | See [Margin properties](#margin-properties) |  |

## External fallback font

If a sign is not found in the specified font, a fallback font can be used

Key: `fallback_font`

Example:
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

## External font

A specification of external font files

Key: `font_spec`

Example:
```yml
name: Vollkorn
pathname: Vollkorn
regular: Vollkorn-Regular.ttf
bold: Vollkorn-Bold.ttf
italic: Vollkorn-Italic.ttf
bold_italic: Vollkorn-BoldItalic.ttf
```

| Key | Description | Data type |
| - | - | - |
| `name` | **Font name**<br/>The name of the external font how it is used in the styling<br/>Example: `Vollkorn` | string |
| `pathname` | **Font directory**<br/>The name of directory where the font files are located<br/>Example: `vollkorn` | string |
| `regular` | **Regular font file name**<br/>The font file name for regular text<br/>Example: `Vollkorn-Regular.ttf` | string |
| `bold` | **Bold font file name**<br/>The font file name for bold text<br/>Example: `Vollkorn-Bold.ttf` | string |
| `italic` | **Italic font file name**<br/>The font file name for italic text<br/>Example: `Vollkorn-Italic.ttf` | string |
| `bold_italic` | **Bold & italic font file name**<br/>The font file name for bold & italic text<br/>Example: `Vollkorn-BoldItalic.ttf` | string |

## External fonts

A list of specifications about external fonts

Key: `fonts`

Example:
```yml
fonts:
- name: Vollkorn
  pathname: vollkorn
  filename: Vollkorn-Regular.ttf
- name: OpenSans
  pathname: opensans
  filename: OpenSans-Regular.ttf
```

## Font properties

Properties to set the font style

Key: `font`

Example:
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
| `character_spacing` | **Character spacing**<br/>Additional space between characters<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `leading` | **Leading**<br/>Additional space between lines<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `color` | **Font color**<br/>The color of the font to use<br/>Example: `F0F0F0` | string |
| `styles` | **Font styles**<br/>The styles of the font to use<br/>Example: `[bold]`<br/>Valid values:<br/>`bold`, `italic`, `underline`, `strikethrough`, `superscript`, `subscript` | array of string |

## Footnote definition

Key: `footnote_definition`

Example:
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
| `point` | **Footnote definition point**<br/>Styling of the point sign for footnotes<br/>See [Footnote definition point](#footnote-definition-point) | object |

## Footnote definition point

Styling of the point sign for footnotes

Key: `point`

| Key | Description | Data type |
| - | - | - |
| … | See [Font properties](#font-properties) |  |

## Footnote reference

Key: `footnote_reference`

Example:
```yml
footnote_reference:
  size: 13
  styles:
    - superscript
  color: '000088'
```

| Key | Description | Data type |
| - | - | - |
| … | See [Font properties](#font-properties) |  |

## Header

Default styling for headers on all levels.<br/>use header_`x` as key for header level `x`.

Key: `header`

Example:
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
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |

## Header level

Key: `header_x`

| Key | Description | Data type |
| - | - | - |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |

## Headless table

Tables without or empty header rows can be styled differently.

Key: `headless_table`

Example:
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
| `cell` | **Table cell**<br/>Properties for table cell style<br/>See [Table cell](#table-cell) | object |
| … | See [Margin properties](#margin-properties) |  |
| … | See [Border properties](#border-properties) |  |

## Horizontal rule

Styling for horizontal lines

Key: `hrule`

Example:
```yml
hrule:
  line_width: 1
```

| Key | Description | Data type |
| - | - | - |
| `line_width` | **Sets the stroke width of the horizontal rule**<br/>A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Margin properties](#margin-properties) |  |

## Image

Styling of images

Key: `image`

Example:
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
| `caption` | **Image caption**<br/>Styling for the caption below an image<br/>See [Paragraph](#paragraph) | object |
| … | See [Margin properties](#margin-properties) |  |

## Image classes

Styling for images by class names

Key: `image_classes`

| Key | Description | Data type |
| - | - | - |
| your choice | See [Image](#image) | object |

## Link

Styling a clickable link

Key: `link`

Example:
```yml
link:
  color: '000088'
```

| Key | Description | Data type |
| - | - | - |
| … | See [Font properties](#font-properties) |  |

## Margin properties

Properties to set margins

Key: `margin`

Example:
```yml
margin: 10mm
margin_top: 15mm
```

| Key | Description | Data type |
| - | - | - |
| `margin` | **Margin**<br/>One value for margin on all sides<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `margin_left` | **Margin left**<br/>Margin only on the left side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `margin_right` | **Margin right**<br/>Margin only on the right side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `margin_top` | **Margin top**<br/>Margin only on the top side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `margin_bottom` | **Margin bottom**<br/>Margin only on the bottom side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |

## Ordered list

Default styling for ordered lists on all levels.<br/>use ordered_list_`x` as key for ordered list level `x`.

Key: `ordered_list`

Example:
```yml
ordered_list:
  spacing: 2mm
  point_inline: false
```

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `point_inline` | **Inline point**<br/>Do not indent paragraph text, but include the point into the first paragraph | boolean |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |

## Ordered list level

Key: `ordered_list_x`

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `point_inline` | **Inline point**<br/>Do not indent paragraph text, but include the point into the first paragraph | boolean |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |

## Ordered list point

Default styling for ordered list points on all levels.<br/>use ordered_list_point_`x` as key for ordered list points level `x`.

Key: `ordered_list_point`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Ordered list point level

Key: `ordered_list_point_x`

| Key | Description | Data type |
| - | - | - |
| `spacing` | A number >= 0 and an optional unit<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `alphabetical` | **Alphabetical bullet points**<br/>Convert the list item number into a character, eg. `a.` `b.` `c.` | boolean |
| `spanning` | **Spanning**<br/>Use the width of the largest bullet as indention. | boolean |
| `template` | **Template**<br/>customize what the prefix should contain, eg. `(<number>)` | string |
| … | See [Font properties](#font-properties) |  |

## Padding properties

Properties to set paddings

Key: `padding`

Example:
```yml
padding: 10mm
padding_top: 15mm
```

| Key | Description | Data type |
| - | - | - |
| `padding` | **Padding**<br/>One value for padding on all sides<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `padding_left` | **Padding left**<br/>Padding only on the left side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `padding_right` | **Padding right**<br/>Padding only on the right side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `padding_top` | **Padding top**<br/>Padding only on the top side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| `padding_bottom` | **Padding bottom**<br/>Padding only on the bottom side<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |

## Page footer

Up to three footer sections are supported.<br/>The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file.

Key: `page_footer`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Page footer 2

Key: `page_footer_2`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Page footer 3

Key: `page_footer_3`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Page header

Key: `page_header`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Page header 1

Up to three header sections are supported. The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file.

Key: `page_header`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Page header 2

Key: `page_header_2`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Page header 3

Key: `page_header_3`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Page logo

A logo image in the header.<br/>The image filename must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file. 

Key: `page_logo`

Example:
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
| `disabled` | **Disable logo**<br/>Disable or enable the page logo<br/>Example: `false` | boolean |

## Page settings

Properties to set the basic page settings

Key: `page`

Example:
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
| … | Default font settings<br/>See [Font properties](#font-properties) |  |
| … | Page margins<br/>See [Margin properties](#margin-properties) |  |

## Paragraph

A block of text

Key: `paragraph`

Example:
```yml
paragraph:
  align: justify
  padding_bottom: 2mm
```

| Key | Description | Data type |
| - | - | - |
| `align` | **Alignment**<br/>How the text should be aligned<br/>Valid values:<br/>`left`, `center`, `right`, `justify` | string |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |

## Table

Key: `table`

Example:
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
| `header` | **Table header**<br/>Properties for table header cell style<br/>See [Table header](#table-header) | object |
| `cell` | **Table cell**<br/>Properties for table cell style<br/>See [Table cell](#table-cell) | object |
| … | See [Margin properties](#margin-properties) |  |
| … | See [Border properties](#border-properties) |  |

## Table cell

Properties for table cell style

Key: `table_cell`

| Key | Description | Data type |
| - | - | - |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |
| … | See [Border properties](#border-properties) |  |

## Table header

Properties for table header cell style

Key: `table_header`

| Key | Description | Data type |
| - | - | - |
| `background_color` | **Color**<br/>A color in RRGGBB format<br/>Example: `F0F0F0` | string |
| `no_repeating` | **Disable header repeating**<br/>Disable table headers should be repeated if table spawns over pages with `true` | boolean |
| … | See [Font properties](#font-properties) |  |

## Task list

Key: `task_list`

Example:
```yml
task_list:
  spacing: 1.5mm
  padding_top: 2mm
  padding_bottom: 2mm
```

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |

## Task list point

Key: `task_list_point`

Example:
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
| … | See [Font properties](#font-properties) |  |

## Unordered list

Default styling for unordered lists on all levels.<br/>use unordered_list_`x` as key for unordered list level `x`.

Key: `unordered_list`

Example:
```yml
unordered_list:
  spacing: 1.5mm
  padding_top: 2mm
  padding_bottom: 2mm
```

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |

## Unordered list level

Key: `unordered_list_x`

Example:
```yml
unordered_list:
  spacing: 1.5mm
  padding_top: 2mm
  padding_bottom: 2mm
```

| Key | Description | Data type |
| - | - | - |
| `spacing` | **Spacing**<br/>Additional space between list items<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font properties](#font-properties) |  |
| … | See [Padding properties](#padding-properties) |  |

## Unordered list point

Default styling for unordered list points on all levels.<br/>use unordered_list_point_`x` as key for unordered list points level `x`.

Key: `unordered_list_point`

Example:
```yml
unordered_list_point:
  sign: "•"
  spacing: 0.75mm
```

| Key | Description | Data type |
| - | - | - |
| `sign` | **Sign**<br/>The 'bullet point' character used in the list | string |
| `spacing` | **Spacing**<br/>Space between point and list item content<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font properties](#font-properties) |  |

## Unordered list point level

Key: `unordered_list_point_x`

| Key | Description | Data type |
| - | - | - |
| `sign` | **Sign**<br/>The 'bullet point' character used in the list | string |
| `spacing` | **Spacing**<br/>Space between point and list item content<br/>Examples: `10mm`, `10` | number or string<br/>See [Units](#units) |
| … | See [Font properties](#font-properties) |  |

## md-to-pdf default custom fields values

Key: `pdf_fields`

| Key | Description | Data type |
| - | - | - |
| your choice |  | ["string", "number"] |

## md-to-pdf default fields settings

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
| `pdf_fields` | **md-to-pdf default custom fields values**<br/>See [md-to-pdf default custom fields values](#md-to-pdf-default-custom-fields-values) | object |
## Units

available units are

`mm` - Millimeter, `cm` - Centimeter, `dm` - Decimeter, `m` - Meter

`in` - Inch, `ft` - Feet, `yr` - Yard

`pt` - [Postscript point](https://en.wikipedia.org/wiki/Point_(typography)#Desktop_publishing_point) (default if no unit is used)