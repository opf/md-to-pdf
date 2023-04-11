# Styling

## Font Assets

All cuts of a font are needed:

* regular
* bold
* italic
* bolditalic

They must be placed relative to the styling yml as the example shown here:

```
/
├── styling                      Root path for all styling assets       
│   ├── legal.yml                The reference styling
│   ├── employment-contract.yml  The styling for employment contracts
│   ├── custom.yml               Your styling?
│   └── fonts                    Font folder (must be lowercase "font")
│       ├── Font1                Folder for font 1
│       │   ├── regular.ttf      TTF font file
│       │   ├── ...              TTF font files
│       │   └── bolditalic.ttf   TTF font file
│       ├── ...                  More fonts
│       └── FontX                Folder for font x
│           └── ...
│       
```

## YML Configuration

A yml config file is used to set the pdf styling

see a reference file at [demo/demo.yml](../demo/demo.yml)

### Fonts

There are built-in fonts:

* Courier
* Helvetica
* Times-Roman

PDF's built-in fonts have very limited support for internationalized text.
If you need full UTF-8 support, please use an external font instead.

### External fonts

```yml
fonts:
  - name: 'Vollkorn' # the name of the as used later for content
    pathname: 'Vollkorn' # the name of the font directory where the font files are located 
    regular: 'Vollkorn-Regular.ttf' # font file for regular text
    bold: 'Vollkorn-Bold.ttf' # font file for bold text
    italic: 'Vollkorn-Italic.ttf' # font file for italic text
    bold_italic: 'Vollkorn-BoldItalic.ttf'  # font file for bold-italic text
  - ...
```

### Document

```yml
page:
  page_size: 'A4'
  page_layout: 'portrait'
#  ...: see #font-settings
#  ...: see #margin
```

[font-settings](#font-settings), [margin](#margin)

### Document Header

Up to three header sections are supported:

use page_header as key for the first footer

use page_header_2 as key for the second footer

use page_header_3 as key for the third footer

The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file 

```yml
page_header:
  disabled: false # set true to disable page headers
  filter_pages: [ ] # e.g. [ 1 ] = no header on first page 
  align: left # left or center or right
  offset: -30 # offset position from page.top
  #  ...: see #font-settings
```

[font-settings](#font-settings)

### Document Logo

```yml
page_logo:
  disabled: false # set true to disable page logos
  filter_pages: [ ] # e.g. [ 1 ] = no logo on first page 
  align: left # left or center or right
  offset: -30 # offset position from page.top
  max_width: 40mm # maximum image width in units
```

[units](#units)

The image filename must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file

### Document Footer

Up to three footer sections are supported:

use page_footer as key for the first footer

use page_footer_2 as key for the second footer

use page_footer_3 as key for the third footer

The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file

```yml
page_footer:
  disabled: false # set true to disable page footers
  filter_pages: [ ] # e.g. [ 1 ] = no footer on first page 
  align: left # left or center or right
  offset: -30 # offset position from page.bottom
  #  ...: see #font-settings
```

[font-settings](#font-settings)

### Paragraph

```yml
paragraph:
  align: 'justify' # left or justify or right
#  ...: see #font-settings
#  ...: see #padding
```

[font-settings](#font-settings), [padding](#padding)

### Link

```yml
link:
#  ...: see #font-settings
```

[font-settings](#font-settings)

### Header

#### Default for all headers

```yml
header:
  #  ...: see #font-settings
  #  ...: see #padding
```

[font-settings](#font-settings), [padding](#padding)

#### Header levels

use header_`x` as key for header level `x`

```yml
header_1:
  #  ...: see #font-settings
  #  ...: see #padding
header_2:
  #  ...: see #font-settings
  #  ...: see #padding
```

[font-settings](#font-settings), [padding](#padding)

### Table

```yml
table:
  auto_width: true # table columns should fit the content, equal spacing otherwise
  #  ...: see #margin
  header:
    background_color: 'F0F0F0'
    no_repeating: true # if table headers should be repeated if table spawns over pages
    #  ...: see #font-settings
  cell:
    style: 'underline' # table cell only allows one default font style (use markup for more)
    background_color: '000FFF'
    #  ...: see #font-settings
    #  ...: see #padding
    #  ...: see #borders
```

[font-settings](#font-settings), [padding](#padding), [margin](#margin), [borders](#borders)

### Lists

#### Unordered list

```yml
unordered_list:
  spacing: 2mm # space between list items
  #  ...: see #font-settings
  #  ...: see #padding
```

[padding](#padding), [font-settings](#font-settings)

#### Unordered list bullet point

```yml
unordered_list_point:
  sign: "•" # the bullet point sign
  spacing: 0.75mm # space between point and list item content
  #  ...: see #font-settings
```

[font-settings](#font-settings)

#### Ordered list

```yml
ordered_list:
  spacing: 2mm # space between list items
  point_inline: false # do not indent paragraph text, but include the point into the first paragraph
  #  ...: see #font-settings
  #  ...: see #padding
```

[padding](#padding), [font-settings](#font-settings)

#### Ordered list prefix

```yml
ordered_list_point:
  template: '<number>.' # customize what the prefix should contain, eg. '(<number>)'
  alphabetical: false # convert the number to a char, eg. 'a. b. c.'
  spacing: 0.75mm # space between point and list item content
  spanning: true # use the width of the largest bullet width
  #  ...: see #font-settings (number point)
```

#### List levels

use unordered_list_`x` as key for unordered list level `x`

use unordered_list_point_`x` as key for unordered list point level `x`

use ordered_list_`x` as key for ordered list level `x`

use ordered_list_point_`x` as key for ordered list point level `x`

```yml
ordered_list_1:
  #  ...: see #font-settings
  #  ...: see #padding
ordered_list_point_1:
  #  ...: see #font-settings
ordered_list_2:
  #  ...: see #font-settings
  #  ...: see #padding
ordered_list_point_2:
  #  ...: see #font-settings
```

### Horizontal Rule

```yml
hrule:
  line_width: 1 # sets the stroke width of the h_rule
  #  ...: see #margin
```

[padding](#margin)

### Blockquote

```yml
blockquote:
#  ...: see #font-settings
#  ...: see #margin
```

[font-settings](#font-settings), [margin](#margin)

### Code

```yml
code:
#  ...: see #font-settings
```

[font-settings](#font-settings)

### Codeblock

```yml
codeblock:
  background_color: 'F5F5F5'
#  ...: see #font-settings
#  ...: see #padding
#  ...: see #margin
```

[font-settings](#font-settings), [margin](#margin), [padding](#padding)

### Image

```yml
image:
  max_width: 100mm # maximum image width in units
#  ...: see #margin
```

[margin](#margin), [units](#units)


### Footnotes

#### Footnote Reference

```yml
footnote_reference:
#  ...: see #font-settings
```

#### Footnote Definition

```yml
footnote_definition:
  point:
    #  ...: see #font-settings
```

[font-settings](#font-settings)

## YML Blocks

### Font Settings

```yml
  font: 'Vollkorn' # the name of the font as declared in fonts.name
  size: 10 # The font size to use
  character_spacing: 0 # Additional space between characters
  styles: [] # ['bold', 'italic', 'superscript', 'subscript', 'strikethrough', 'underline' ]
  color: '000000' # rgb hex color
  leading: 2 # Additional space between lines
```

### Margin

default: 0

```yml
  margin: 20mm # on all sides in units
  margin_left: 20mm # left margin in units
  margin_right: 20mm # right margin in units
  margin_top: 20mm # top margin in units
  margin_bottom: 20mm # bottom margin in units
```

[units](#units)

### Padding

default: 0

```yml
  padding: 20mm # on all sides 
  padding_left: 20mm # left padding
  padding_right: 20mm # right padding
  padding_top: 20mm # top padding
  padding_bottom: 20mm # bottom padding
```

[units](#units)

### Borders

```yml
    border_color_left: 'F000FF' # left color 
    border_color_right: '00FFF0' # right color
    border_color_top: '000FFF' # top color 
    border_color_bottom: 'FFF000' # bottom color
    no_border_left: false # disable left border with true
    no_border_right: false # disable right border with true
    no_border_top: false # disable top border with true
    no_border_bottom: false # disable bottom border with true
    border_width: 0.25mm # border width
    border_width_left: 0.25mm # left width
    border_width_right: 0.25mm # right width
    border_width_top: 0.25mm  # top width
    border_width_bottom: 0.25mm # bottom width
```

[units](#units)

## Values

### Units

available units are 

mm - Millimeter, cm - Centimeter, dm - Decimeter, m - Meter
in - Inch, ft - Feet, yr - Yard
pt - PostscriptPoint (default)
