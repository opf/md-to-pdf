# Styling

## Font Assets

All cuts of a font are needed:

* regular
* bold
* italic
* bolditalic

They must be placed relative to the styling yml as shown here:

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
    bold-italic: 'Vollkorn-BoldItalic.ttf'  # font file for bold-italic text
  - ...
```

### Document

```yml
page:
  page-size: 'A4'
  page-layout: 'portrait'
#  ...: see #font-settings
#  ...: see #margin
```

[font-settings](#font-settings), [margin](#margin)

### Document Header

Up to three header sections are supported:

use page-header as key for the first footer

use page-header-2 as key for the second footer

use page-header-3 as key for the third footer

The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file 

```yml
page-header:
  disabled: false # set true to disable page headers
  filter-pages: [ ] # e.g. [ 1 ] = no header on first page 
  align: left # left or center or right
  offset: -30 # offset position from page.top
  #  ...: see #font-settings
```

[font-settings](#font-settings)

### Document Logo

```yml
page-logo:
  disabled: false # set true to disable page logos
  filter-pages: [ ] # e.g. [ 1 ] = no logo on first page 
  align: left # left or center or right
  offset: -30 # offset position from page.top
  max-width: 40mm # maximum image width in units
```

[units](#units)

The image filename must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file

### Document Footer

Up to three footer sections are supported:

use page-footer as key for the first footer

use page-footer-2 as key for the second footer

use page-footer-3 as key for the third footer

The content must be declared in the [frontmatter](FRONTMATTER.md) head of the markdown file

```yml
page-footer:
  disabled: false # set true to disable page footers
  filter-pages: [ ] # e.g. [ 1 ] = no footer on first page 
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

use header-`x` as key for header level `x`

```yml
header-1:
  #  ...: see #font-settings
  #  ...: see #padding
header-2:
  #  ...: see #font-settings
  #  ...: see #padding
```

[font-settings](#font-settings), [padding](#padding)

### Table

```yml
table:
  auto-width: true # table columns should fit the content, equal spacing otherwise
  #  ...: see #margin
  header:
    background-color: 'F0F0F0'
    no-repeating: true # if table headers should be repeated if table spawns over pages
    #  ...: see #font-settings
  cell:
    style: 'underline' # table cell only allows one default font style (use markup for more)
    background-color: '000FFF'
    #  ...: see #font-settings
    #  ...: see #padding
    #  ...: see #borders
```

[font-settings](#font-settings), [padding](#padding), [margin](#margin), [borders](#borders)

### Lists

#### Unordered list

```yml
unordered-list:
  spacing: 2mm # space between list items
  #  ...: see #font-settings
  #  ...: see #padding
```

[padding](#padding), [font-settings](#font-settings)

#### Unordered list bullet point

```yml
unordered-list-point:
  sign: "•" # the bullet point sign
  spacing: 0.75mm # space between point and list item content
  #  ...: see #font-settings
```

[font-settings](#font-settings)

#### Ordered list

```yml
ordered-list:
  spacing: 2mm # space between list items
  point-inline: false # do not indent paragraph text, but include the point into the first paragraph
  #  ...: see #font-settings
  #  ...: see #padding
```

[padding](#padding), [font-settings](#font-settings)

#### Ordered list prefix

```yml
ordered-list-point:
  template: '<number>.' # customize what the prefix should contain, eg. '(<number>)'
  alphabetical: false # convert the number to a char, eg. 'a. b. c.'
  spacing: 0.75mm # space between point and list item content
  spanning: true # use the width of the largest bullet width
  #  ...: see #font-settings (number point)
```

#### List levels

use unordered-list-`x` as key for unordered list level `x`

use unordered-list-point-`x` as key for unordered list point level `x`

use ordered-list-`x` as key for ordered list level `x`

use ordered-list-point-`x` as key for ordered list point level `x`

```yml
ordered-list-1:
  #  ...: see #font-settings
  #  ...: see #padding
ordered-list-point-1:
  #  ...: see #font-settings
ordered-list-2:
  #  ...: see #font-settings
  #  ...: see #padding
ordered-list-point-2:
  #  ...: see #font-settings
```

### Horizontal Rule

```yml
hrule:
  line-width: 1 # sets the stroke width of the h-rule
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
  background-color: 'F5F5F5'
#  ...: see #font-settings
#  ...: see #padding
#  ...: see #margin
```

[font-settings](#font-settings), [margin](#margin), [padding](#padding)

### Image

```yml
image:
  max-width: 100mm # maximum image width in units
#  ...: see #margin
```

[margin](#margin), [units](#units)


### Footnotes

#### Footnote Reference

```yml
footnote-reference:
#  ...: see #font-settings
```

#### Footnote Definition

```yml
footnote-definition:
  point:
    #  ...: see #font-settings
```

[font-settings](#font-settings)

## YML Blocks

### Font Settings

```yml
  font: 'Vollkorn' # the name of the font as declared in fonts.name
  size: 10 # The font size to use
  character-spacing: 0 # Additional space between characters
  styles: [] # ['bold', 'italic', 'superscript', 'subscript', 'strikethrough', 'underline' ]
  color: '000000' # rgb hex color
  leading: 2 # Additional space between lines
```

### Margin

default: 0

```yml
  margin: 20mm # on all sides in units
  margin-left: 20mm # left margin in units
  margin-right: 20mm # right margin in units
  margin-top: 20mm # top margin in units
  margin-bottom: 20mm # bottom margin in units
```

[units](#units)

### Padding

default: 0

```yml
  padding: 20mm # on all sides 
  padding-left: 20mm # left padding
  padding-right: 20mm # right padding
  padding-top: 20mm # top padding
  padding-bottom: 20mm # bottom padding
```

[units](#units)

### Borders

```yml
    border-color-left: 'F000FF' # left color 
    border-color-right: '00FFF0' # right color
    border-color-top: '000FFF' # top color 
    border-color-bottom: 'FFF000' # bottom color
    no-border-left: false # disable left border with true
    no-border-right: false # disable right border with true
    no-border-top: false # disable top border with true
    no-border-bottom: false # disable bottom border with true
    border-width: 0.25mm # border width
    border-width-left: 0.25mm # left width
    border-width-right: 0.25mm # right width
    border-width-top: 0.25mm  # top width
    border-width-bottom: 0.25mm # bottom width
```

[units](#units)

## Values

### Units

available units are 

mm - Millimeter, cm - Centimeter, dm - Decimeter, m - Meter
in - Inch, ft - Feet, yr - Yard
pt - PostscriptPoint (default)
