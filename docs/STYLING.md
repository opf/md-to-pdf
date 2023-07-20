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

### YML styles

see the styles documentation at [STYLES.md](STYLES.md)
