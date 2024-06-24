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

`___`

___

`---`

---

`***`

***

`_________________`

_________________

# Emphasis

This is **bold** text with `**`

This is __bold__ text with `__`

This is *italic* text with `*`

This is _italic_ text with `_`

~~Strikethrough~~ with `~~`

`<s>...</s>` for <s>strikethrough</s> text

`<strikethrough>...</strikethrough>` for <strikethrough>strikethrough</strikethrough> text

`<strong>...</strong>` for <b>bold</b> text

`<b>...</b>` for <b>bold</b> text

`<strong>...</strong>` for <b>bold</b> text

`<i>...</i>` for <i>italic</i> text

`<sub>...</sub>` for <sub>subscript</sub> text

`<sup>...</sup>` for <sup>superscript</sup> text

<br-page/>

# Blockquotes

> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.

> Blockquotes can also contain images...
>> ...before image ![](demo.jpg) after image...

> Lists in Blockquotes are currently only partly supported
> - entry 1
> - entry 2
> - entry 3

> Blockquotes can be f**or**m*att*ed ~~strikethrough~~ <u>underline</u>


# Alert Blockquotes

Markdown extension by [Github](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts)

> [!NOTE]
> Useful information that users should know, even when skimming content.


> [!TIP]
> Helpful advice for doing things better or more easily.


> [!IMPORTANT]
> Key information users need to know to achieve their goal.


> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.


> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.


> [!NOTE: With an own title]
> Useful information that users should know, even when skimming content.


<br-page/>

# Links

[link text](https://www.openproject.com)

Auto-converted link https://www.openproject.com

[Anchor links in document](#links) (to headline "Links")

HTML tag `<a href="https://www.openproject.com">link text</a>`

Inline <a href="https://www.openproject.com">link text</a> HTML tag

# Lists

## Unordered

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
    * Ac tristique libero volutpat at

## Ordered

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa
4. Four
5. Five
6. Six
7. Seven
8. Eight
9. Nine
10. Ten


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


### Task List

* [ ] A
* [x] Task
* [ ] List

### HTML Lists

<ul>
<li>one</li>
<li>two</li>
<li>three</li>
</ul>


<ol>
<li>one</li>
<li>two</li>
<li>three</li>
</ol>


<ol>
<li>one</li>
<li>two</li>
<li>three
<ol>
<li>one</li>
<li>two</li>
<li>three<ol>
<li>one</li>
<li>two</li>
<li>three</li>
</ol></li>
</ol>
</li>
</ol>


<br-page/>

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

## HTML Table

<table><thead><tr><th>Header</th><th></th></tr></thead><tbody><tr><td style="background-color: #0fffff;">Cell Background Color</td><td></td></tr></tbody></table>

<br-page/>

# Images

## Markdown syntax

Floating text above ![Dummy image](demo.jpg) and below image

### Markdown image class attributes (non-standard kramdown extension)

![Demo image](demo.jpg){: .left .small}

![Demo image](demo.jpg){: .center .small}

![Demo image](demo.jpg){: .right .small}

### Markdown image caption

![Demo image](demo.jpg "Demo image caption")

## HTML syntax

<img src="demo.jpg" class="left small">

<img src="demo.jpg" class="center small">

<img src="demo.jpg" class="right small">

## HTML figure and figcaption

<figure><img src="demo.jpg"><figcaption>Demo image caption</figcaption></figure>

## Footnote syntax

Like links, Images also have a footnote style syntax

![Alt text][image-id]

With a reference later in the document defining the URL location.

[image-id]: demo.jpg  "The demo image"

<br-page/>

# HTML Specials

`<br-page/>` start a new page

---

# Mermaid

if https://github.com/mermaid-js/mermaid-cli is installed, the following code block with mermaid fence is converted to and included as PNG

```mermaid
quadrantChart
    title Reach and engagement of campaigns
    x-axis Low Reach --> High Reach
    y-axis Low Engagement --> High Engagement
    quadrant-1 We should expand
    quadrant-2 Need to promote
    quadrant-3 Re-evaluate
    quadrant-4 May be improved
    Campaign A: [0.3, 0.6]
    Campaign B: [0.45, 0.23]
    Campaign C: [0.57, 0.69]
    Campaign D: [0.78, 0.34]
    Campaign E: [0.40, 0.34]
    Campaign F: [0.35, 0.78]
```

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

Currently, footnotes are placed at the end of the document, not on a page.

Footnote 1 link[^first].

Footnote 2 link[^second].

Duplicated footnote reference[^second].

[^first]: Footnote **can have markup**

    and multiple paragraphs.

[^second]: Footnote text.

