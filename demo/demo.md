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
pdf_fields:
  variable-demo-1: "one"
  variable-demo-2: "two"
---

# DEMO

<br-page/>

# h1 Heading

## h2 Heading

### h3 Heading

#### h4 Heading

##### h5 Heading

###### h6 Heading

# Horizontal Rules

___

---

***

_________________

# Emphasis

**This is bold text**

__This is bold text__

*This is italic text*

_This is italic text_

~~Strikethrough~~

# Blockquotes

> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.

<br-page/>

# Lists

## Unordered

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at

    + Facilisis in pretium nisl aliquet

    - Nulla volutpat aliquam velit
+ Very easy!

## Ordered

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

### Custom ordered point format

1. Level 1
   1. Level 2
   2. Level 2
      1. Level 3 uses alphabetical points
      2. Level 3
      3. Level 3
          1. Level 4 uses a brackets template
          2. Level 4
          3. Level 4

<br-page/>

## Links

[link text](https://www.openproject.com)

Autoconverted link https://www.openproject.com

[Anchor links in document](#links) (to headline "Links")

# Code

## Inline

Inline `code`

## Indented code

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code

## Block code "fences"

```
Sample text here...
```

``` js
var foo = function (bar) {
  return bar++;
};

```

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

<br-page/>

# Tables

| Description Column 1            | Description Column 2            |
|---------------------------------|---------------------------------|
| Lorem ipsum dolor sit amet      | Lorem ipsum dolor sit amet      |
| Consectetur adipiscing elit     | Consectetur adipiscing elit     |
| Integer molestie lorem at massa | Integer molestie lorem at massa |

## Aligned columns

| Left | Center | Right |
|:-----|:------:|------:|
| 1a   |   1b   |    1c |
| 2a   |   2b   |    2c |
| 3a   |   3b   |    3c |

## Headerless Tables

|                              |                              |
|:-----------------------------|:----------------------------:|
| Leave the header cells empty | to create a headerless table |
| which can be styled          |         differently          |


## Images and Formatting in Cells

|                        One                        | Two                       | Three                              |
|:-------------------------------------------------:|---------------------------|------------------------------------|
|             ![Dummy image](demo.jpg)              | Multiple lines<br>in cell | ![Dummy image](demo.jpg)           |
| text around a ![Dummy image](demo.jpg) cell image | Links [ipsum](dolor)      | f**or**m*at*ting ~~strikethrough~~ |
|                      # test                       | <u>underline</u>          | ---                                |

<br-page/>

# Images

## Markdown syntax

Floating text above ![Dummy image](demo.jpg) and below image

### Markdown image class attributes (non-standard kramdown extension)

![Demo image](demo.jpg){: .left .small}

![Demo image](demo.jpg){: .center .small}

![Demo image](demo.jpg){: .right .small}

## HTML syntax

<img src="demo.jpg" class="left small">

<img src="demo.jpg" class="center small">

<img src="demo.jpg" class="right small">

## Footnote syntax

Like links, Images also have a footnote style syntax

![Alt text][image-id]

With a reference later in the document defining the URL location.

[image-id]: demo.jpg  "The demo image"

<br-page/>

# HTML Specials

`<br-page/>` start a new page

`<u>...</u>` to <u>underline</u> text

---

# Frontmatter

Frontmatter YML is supported:

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
pdf_hyphenation: true
pdf_language: "en"
pdf_fields:
  variable-demo-1: "one"
  variable-demo-2: "two"
---
```

## Variable replacement

Add key-value pairs to the frontmatter header node `pdf_fields:`, use `%key%` to have them replaced.

`This is replaced: % variable-demo-1 % and this is replaced: % variable-demo-2 %.`

This is replaced: %variable-demo-1% and this is replaced: %variable-demo-2%.

# Footnotes

Currently footnotes are placed at the end of the document, not on a page.

Footnote 1 link[^first].

Footnote 2 link[^second].

Duplicated footnote reference[^second].

[^first]: Footnote **can have markup**

    and multiple paragraphs.

[^second]: Footnote text.

---
