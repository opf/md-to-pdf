require 'pdf_helpers'

describe MarkdownToPDF::Image do
  include_context 'with pdf'

  it 'creates image by markdown' do
    generator.parse_file('image/image.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Floating text above" },
                 { x: 36.0, y: 306.507, text: "and below image" }])
    expect_pdf_images([
                        { x: 36.0, y: 315.123, width: 540.0, height: 427.005 },
                        { x: 164.0, y: 215.251, width: 284.0, height: 86.0 }])
  end

  it 'creates image with classes' do
    generator.parse_file('image/classes.md',
                         {
                           image_classes: {
                             small: { max_width: 100 },
                             left: { margin: 0, align: "left" },
                             center: { margin: 0, align: "center" },
                             right: { margin: 0, align: "right" }
                           }
                         })
    expect_pdf([])
    expect_pdf_images([
                        { x: 36.0, y: 676.925, width: 100.0, height: 79.075 },
                        { x: 256.0, y: 597.85, width: 100.0, height: 79.075 },
                        { x: 476.0, y: 518.775, width: 100.0, height: 79.075 }])
  end

  it 'creates image by html' do
    generator.parse_file('image/html.md', { image: { max_width: 300 } })
    expect_pdf([
                 { x: 36.0, y: 450.85275, text: "An image in the middle of" },
                 { x: 36.0, y: 199.75575, text: "a headline" },
                 { x: 36.0, y: 185.88375, text: "•" },
                 { x: 43.536, y: 185.88375, text: "List 1" },
                 { x: 36.0, y: 172.01175, text: "•" },
                 { x: 43.536, y: 172.01175, text: "An image in the middle of" },
                 { x: 43.536, y: 510.159, text: "a list" },
                 { x: 36.0, y: 496.287, text: "•" },
                 { x: 43.536, y: 496.287, text: "List 3" },
                 { x: 41.0, y: 739.756, text: "Quote 1" },
                 { x: 41.0, y: 725.884, text: "An image in the middle of" },
                 { x: 41.0, y: 275.007, text: "a quote" },
                 { x: 41.0, y: 261.135, text: "Quote 2" }])
    expect_pdf_images([
                        { x: 268.5, y: 696.69375, width: 75.0, height: 59.30625 },
                        { x: 156.0, y: 459.46875, width: 300.0, height: 237.225 },
                        { x: 156.0, y: 208.37175, width: 300.0, height: 237.225 },
                        { x: 159.768, y: 518.775, width: 300.0, height: 237.225 },
                        { x: 41.0, y: 296.251, width: 527.35378, height: 417.005 }
                      ])
  end

  it 'creates image by footnote' do
    generator.parse_file('image/footnote.md', { image: { max_width: 100 } })
    expect_pdf([{ x: 36.0, y: 668.309, text: "The demo image" }])
    expect_pdf_images([{ x: 256.0, y: 676.925, width: 100.0, height: 79.075 }])
  end

  it 'creates image with caption' do
    generator.parse_file('image/caption.md', { image: { max_width: 100, caption: { align: :center, size: 10 } } })
    expect_pdf([{ x: 264.315, y: 669.745, text: "Image with caption" }])
    expect_pdf_images([{ x: 256.0, y: 676.925, width: 100.0, height: 79.075 }])
  end

  it 'creates image with figure and caption' do
    generator.parse_file('image/figure.md', { image: { max_width: 100, margin_bottom: 100, caption: { align: :center, size: 10 } } })
    expect_pdf([{ x: 273.85, y: 669.745, text: "Dummy image" }])
    expect_pdf_images([{ x: 256.0, y: 676.925, width: 100.0, height: 79.075 }])
  end

  it 'creates image in a html table' do
    generator.parse_file('image/in_table.html', { html_table: { auto_width: true } })
    expect_pdf(
      [{ x: 41.0, y: 739.756, text: "Lorem ipsum dolor sit amet, consetetur" },
       { x: 41.0, y: 725.884, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
       { x: 41.0, y: 698.14, text: "" },
       { x: 41.0, y: 578.63544, text: "Lorem ipsum dolor sit amet, consetetur" },
       { x: 41.0, y: 564.76344, text: "sadipscing elitr, sed diam nonumy eirmod" },
       { x: 41.0, y: 550.89144, text: "tempor " },
       { x: 41.0, y: 537.01944, text: "" },
       { x: 306.0, y: 744.756, text: "Lorem ipsum dolor sit amet, consetetur sadipscing" },
       { x: 306.0, y: 730.884, text: "elitr, sed diam nonumy eirmod tempor invidunt ut" },
       { x: 306.0, y: 717.012, text: "labore et dolore magna aliquyam erat, sed diam" },
       { x: 306.0, y: 703.14, text: "voluptua. At vero eos et accusam et justo duo" },
       { x: 306.0, y: 689.268, text: "dolores et ea rebum. Stet clita kasd gubergren, no" },
       { x: 306.0, y: 675.396, text: "sea takimata sanctus est L" },
       { x: 36.0, y: 518.14744, text: "Lorem ipsum dolor sit amet, consetetur sadipscing" },
       { x: 36.0, y: 504.27544, text: "elitr, sed diam nonumy " },
       { x: 311.0, y: 513.14744, text: "Lorem ipsum dolor sit amet, consetetur" },
       { x: 311.0, y: 499.27544, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
       { x: 311.0, y: 471.53144, text: "" },
       { x: 311.0, y: 352.02687, text: "Lorem ipsum dolor sit amet, consetetur" },
       { x: 311.0, y: 338.15487, text: "sadipscing elitr, sed diam nonumy eirmod" },
       { x: 311.0, y: 324.28287, text: "tempor " },
       { x: 311.0, y: 310.41087, text: "" },
       { x: 311.0, y: 190.90631, text: "Lorem ipsum dolor sit amet, consetetur" },
       { x: 311.0, y: 177.03431, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
       { x: 311.0, y: 149.29031, text: "" },
       { x: 36.0, y: 744.756, text: "Lorem ipsum dolor sit amet," },
       { x: 36.0, y: 730.884, text: "consetetur sadipscing elitr, sed" },
       { x: 36.0, y: 717.012, text: "diam nonumy " },
       { x: 216.0, y: 744.756, text: "Lorem ipsum dolor sit amet," },
       { x: 216.0, y: 730.884, text: "consetetur sadipscing elitr, sed" },
       { x: 216.0, y: 717.012, text: "diam nonumy " },
       { x: 401.0, y: 739.756, text: "Lorem ipsum dolor sit amet," },
       { x: 401.0, y: 725.884, text: "consetetur sadipscing elitr, sed" },
       { x: 401.0, y: 712.012, text: "diam nonumy eirmod tempor" },
       { x: 401.0, y: 698.14, text: "invidunt ut labore et dolore" },
       { x: 401.0, y: 684.268, text: "magna aliquyam erat, " },
       { x: 401.0, y: 656.524, text: "" },
       { x: 401.0, y: 564.27296, text: "Lorem ipsum dolor sit amet," },
       { x: 401.0, y: 550.40096, text: "consetetur sadipscing elitr, sed" },
       { x: 401.0, y: 536.52896, text: "diam nonumy eirmod tempor " },
       { x: 401.0, y: 522.65696, text: "" },
       { x: 41.0, y: 498.78496, text: "" },
       { x: 41.0, y: 375.04096, text: "" }]
    )
    expect_pdf_images([
                        { x: 41.0, y: 613.75144, width: 236.97674, height: 71.76056 },
                        { x: 311.0, y: 387.14287, width: 236.97674, height: 71.76056 },
                        { x: 311.0, y: 226.02231, width: 236.97674, height: 71.76056 },
                        { x: 401.0, y: 599.38896, width: 146.97674, height: 44.50704 },
                        { x: 41.0, y: 410.15696, width: 250.97674, height: 76.0 }
                      ])
  end

  it 'creates image with large width in table' do
    generator.parse_file('image/width_in_table.html', { html_table: { auto_width: true } })
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "With image style.width:" },
                 { x: 41.0, y: 725.884, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 712.012, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 41.0, y: 698.14, text: "tempor invidunt ut labore et dolore magna" },
                 { x: 41.0, y: 684.268, text: "aliquyam erat, " },
                 { x: 41.0, y: 477.26962, text: "sed diam voluptua. At vero eos et accusam et" },
                 { x: 41.0, y: 463.39762, text: "justo duo dolores et ea rebum. " },
                 { x: 298.648, y: 730.884, text: "Lorem ipsum dolor sit" },
                 { x: 298.648, y: 717.012, text: "amet, consetetur" },
                 { x: 298.648, y: 703.14, text: "sadipscing elitr, sed diam" },
                 { x: 298.648, y: 689.268, text: "nonumy eirmod tempor" },
                 { x: 298.648, y: 675.396, text: "invidunt ut labore et" },
                 { x: 298.648, y: 661.524, text: "dolore magna aliquyam" },
                 { x: 298.648, y: 647.652, text: "erat, sed diam voluptua." },
                 { x: 298.648, y: 633.78, text: "At vero eos et accusam et" },
                 { x: 298.648, y: 619.908, text: "justo duo dolores et ea" },
                 { x: 298.648, y: 606.036, text: "rebum. Stet clita kasd" },
                 { x: 298.648, y: 592.164, text: "gubergren, no sea" },
                 { x: 298.648, y: 578.292, text: "takimata sanctus est L" },
                 { x: 437.324, y: 730.884, text: "Lorem ipsum dolor sit" },
                 { x: 437.324, y: 717.012, text: "amet, consetetur" },
                 { x: 437.324, y: 703.14, text: "sadipscing elitr, sed diam" },
                 { x: 437.324, y: 689.268, text: "nonumy eirmod tempor" },
                 { x: 437.324, y: 675.396, text: "invidunt ut labore et" },
                 { x: 437.324, y: 661.524, text: "dolore magna aliquyam" },
                 { x: 437.324, y: 647.652, text: "erat, sed diam voluptua." },
                 { x: 437.324, y: 633.78, text: "At vero eos et accusam et" },
                 { x: 437.324, y: 619.908, text: "justo duo dolores et ea" },
                 { x: 437.324, y: 606.036, text: "rebum. Stet clita kasd" },
                 { x: 437.324, y: 592.164, text: "gubergren, no sea" },
                 { x: 437.324, y: 578.292, text: "takimata sanctus est L" },
                 { x: 36.0, y: 444.52562, text: "Stet clita kasd gubergren, no sea takimata" },
                 { x: 36.0, y: 430.65362, text: "sanctus est Lorem ipsum dolor sit amet. Lorem" },
                 { x: 36.0, y: 416.78162, text: "ipsum dolor sit amet, consetetur sadipscing elitr," },
                 { x: 36.0, y: 402.90962, text: "sed diam nonumy eirmod tempor invidunt ut" },
                 { x: 36.0, y: 389.03762, text: "labore et dolore magna aliquyam erat, sed diam" },
                 { x: 36.0, y: 375.16562, text: "voluptua. At vero eos et accusam et justo duo" },
                 { x: 36.0, y: 361.29362, text: "dolores et ea rebum. Stet clita kasd gubergren," },
                 { x: 36.0, y: 347.42162, text: "no sea takimata sanctus est Lorem ipsum dolor" },
                 { x: 36.0, y: 333.54962, text: "sit amet." },
                 { x: 298.648, y: 444.52562, text: "Lorem ipsum dolor sit" },
                 { x: 298.648, y: 430.65362, text: "amet, consetetur" },
                 { x: 298.648, y: 416.78162, text: "sadipscing elitr, sed diam" },
                 { x: 298.648, y: 402.90962, text: "nonumy eirmod tempor" },
                 { x: 298.648, y: 389.03762, text: "invidunt ut labore et" },
                 { x: 298.648, y: 375.16562, text: "dolore magna aliquyam" },
                 { x: 298.648, y: 361.29362, text: "erat, sed diam voluptua." },
                 { x: 298.648, y: 347.42162, text: "At vero eos et accusam et" },
                 { x: 298.648, y: 333.54962, text: "justo duo dolores et ea" },
                 { x: 298.648, y: 319.67762, text: "rebum. Stet clita kasd" },
                 { x: 298.648, y: 305.80562, text: "gubergren, no sea" },
                 { x: 298.648, y: 291.93362, text: "takimata sanctus est L" },
                 { x: 437.324, y: 444.52562, text: "Lorem ipsum dolor sit" },
                 { x: 437.324, y: 430.65362, text: "amet, consetetur" },
                 { x: 437.324, y: 416.78162, text: "sadipscing elitr, sed diam" },
                 { x: 437.324, y: 402.90962, text: "nonumy eirmod tempor" },
                 { x: 437.324, y: 389.03762, text: "invidunt ut labore et" },
                 { x: 437.324, y: 375.16562, text: "dolore magna aliquyam" },
                 { x: 437.324, y: 361.29362, text: "erat, sed diam voluptua." },
                 { x: 437.324, y: 347.42162, text: "At vero eos et accusam et" },
                 { x: 437.324, y: 333.54962, text: "justo duo dolores et ea" },
                 { x: 437.324, y: 319.67762, text: "rebum. Stet clita kasd" },
                 { x: 437.324, y: 305.80562, text: "gubergren, no sea" },
                 { x: 437.324, y: 291.93362, text: "takimata sanctus est L" },
                 { x: 36.0, y: 266.81762, text: "Without image style.width:" },
                 { x: 41.0, y: 739.756, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 725.884, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 41.0, y: 712.012, text: "tempor invidunt ut labore et dolore magna" },
                 { x: 41.0, y: 698.14, text: "aliquyam erat, " },
                 { x: 41.0, y: 438.83509, text: "sed diam voluptua. At vero eos et accusam et" },
                 { x: 41.0, y: 424.96309, text: "justo duo dolores et ea rebum. " },
                 { x: 298.648, y: 744.756, text: "Lorem ipsum dolor sit" },
                 { x: 298.648, y: 730.884, text: "amet, consetetur" },
                 { x: 298.648, y: 717.012, text: "sadipscing elitr, sed diam" },
                 { x: 298.648, y: 703.14, text: "nonumy eirmod tempor" },
                 { x: 298.648, y: 689.268, text: "invidunt ut labore et" },
                 { x: 298.648, y: 675.396, text: "dolore magna aliquyam" },
                 { x: 298.648, y: 661.524, text: "erat, sed diam voluptua." },
                 { x: 298.648, y: 647.652, text: "At vero eos et accusam et" },
                 { x: 298.648, y: 633.78, text: "justo duo dolores et ea" },
                 { x: 298.648, y: 619.908, text: "rebum. Stet clita kasd" },
                 { x: 298.648, y: 606.036, text: "gubergren, no sea" },
                 { x: 298.648, y: 592.164, text: "takimata sanctus est L" },
                 { x: 437.324, y: 744.756, text: "Lorem ipsum dolor sit" },
                 { x: 437.324, y: 730.884, text: "amet, consetetur" },
                 { x: 437.324, y: 717.012, text: "sadipscing elitr, sed diam" },
                 { x: 437.324, y: 703.14, text: "nonumy eirmod tempor" },
                 { x: 437.324, y: 689.268, text: "invidunt ut labore et" },
                 { x: 437.324, y: 675.396, text: "dolore magna aliquyam" },
                 { x: 437.324, y: 661.524, text: "erat, sed diam voluptua." },
                 { x: 437.324, y: 647.652, text: "At vero eos et accusam et" },
                 { x: 437.324, y: 633.78, text: "justo duo dolores et ea" },
                 { x: 437.324, y: 619.908, text: "rebum. Stet clita kasd" },
                 { x: 437.324, y: 606.036, text: "gubergren, no sea" },
                 { x: 437.324, y: 592.164, text: "takimata sanctus est L" },
                 { x: 36.0, y: 406.09109, text: "Stet clita kasd gubergren, no sea takimata" },
                 { x: 36.0, y: 392.21909, text: "sanctus est Lorem ipsum dolor sit amet. Lorem" },
                 { x: 36.0, y: 378.34709, text: "ipsum dolor sit amet, consetetur sadipscing elitr," },
                 { x: 36.0, y: 364.47509, text: "sed diam nonumy eirmod tempor invidunt ut" },
                 { x: 36.0, y: 350.60309, text: "labore et dolore magna aliquyam erat, sed diam" },
                 { x: 36.0, y: 336.73109, text: "voluptua. At vero eos et accusam et justo duo" },
                 { x: 36.0, y: 322.85909, text: "dolores et ea rebum. Stet clita kasd gubergren," },
                 { x: 36.0, y: 308.98709, text: "no sea takimata sanctus est Lorem ipsum dolor" },
                 { x: 36.0, y: 295.11509, text: "sit amet." },
                 { x: 298.648, y: 406.09109, text: "Lorem ipsum dolor sit" },
                 { x: 298.648, y: 392.21909, text: "amet, consetetur" },
                 { x: 298.648, y: 378.34709, text: "sadipscing elitr, sed diam" },
                 { x: 298.648, y: 364.47509, text: "nonumy eirmod tempor" },
                 { x: 298.648, y: 350.60309, text: "invidunt ut labore et" },
                 { x: 298.648, y: 336.73109, text: "dolore magna aliquyam" },
                 { x: 298.648, y: 322.85909, text: "erat, sed diam voluptua." },
                 { x: 298.648, y: 308.98709, text: "At vero eos et accusam et" },
                 { x: 298.648, y: 295.11509, text: "justo duo dolores et ea" },
                 { x: 298.648, y: 281.24309, text: "rebum. Stet clita kasd" },
                 { x: 298.648, y: 267.37109, text: "gubergren, no sea" },
                 { x: 298.648, y: 253.49909, text: "takimata sanctus est L" },
                 { x: 437.324, y: 406.09109, text: "Lorem ipsum dolor sit" },
                 { x: 437.324, y: 392.21909, text: "amet, consetetur" },
                 { x: 437.324, y: 378.34709, text: "sadipscing elitr, sed diam" },
                 { x: 437.324, y: 364.47509, text: "nonumy eirmod tempor" },
                 { x: 437.324, y: 350.60309, text: "invidunt ut labore et" },
                 { x: 437.324, y: 336.73109, text: "dolore magna aliquyam" },
                 { x: 437.324, y: 322.85909, text: "erat, sed diam voluptua." },
                 { x: 437.324, y: 308.98709, text: "At vero eos et accusam et" },
                 { x: 437.324, y: 295.11509, text: "justo duo dolores et ea" },
                 { x: 437.324, y: 281.24309, text: "rebum. Stet clita kasd" },
                 { x: 437.324, y: 267.37109, text: "gubergren, no sea" },
                 { x: 437.324, y: 253.49909, text: "takimata sanctus est L" }])
    expect_pdf_images([
                        { x: 41.0, y: 512.38562, width: 183.85378, height: 145.38238 },
                        { x: 41.0, y: 473.95109, width: 250.00178, height: 197.68891 }
                      ])
  end

  it 'creates image with large height in table' do
    generator.parse_file('image/height_in_table.html', { html_table: { auto_width: true } })
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "With image larger than a page:" },
                 { x: 41.0, y: 739.756, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 725.884, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 41.0, y: 712.012, text: "tempor invidunt ut labore et dolore magna" },
                 { x: 41.0, y: 698.14, text: "aliquyam erat, " },
                 { x: 41.0, y: -1318.476, text: "sed diam voluptua. At vero eos et accusam et" },
                 { x: 41.0, y: -1332.348, text: "justo duo dolores et ea rebum. " },
                 { x: 298.648, y: 744.756, text: "Lorem ipsum dolor sit" },
                 { x: 298.648, y: 730.884, text: "amet, consetetur" },
                 { x: 298.648, y: 717.012, text: "sadipscing elitr, sed diam" },
                 { x: 298.648, y: 703.14, text: "nonumy eirmod tempor" },
                 { x: 298.648, y: 689.268, text: "invidunt ut labore et" },
                 { x: 298.648, y: 675.396, text: "dolore magna aliquyam" },
                 { x: 298.648, y: 661.524, text: "erat, sed diam voluptua." },
                 { x: 298.648, y: 647.652, text: "At vero eos et accusam et" },
                 { x: 298.648, y: 633.78, text: "justo duo dolores et ea" },
                 { x: 298.648, y: 619.908, text: "rebum. Stet clita kasd" },
                 { x: 298.648, y: 606.036, text: "gubergren, no sea" },
                 { x: 298.648, y: 592.164, text: "takimata sanctus est L" },
                 { x: 437.324, y: 744.756, text: "Lorem ipsum dolor sit" },
                 { x: 437.324, y: 730.884, text: "amet, consetetur" },
                 { x: 437.324, y: 717.012, text: "sadipscing elitr, sed diam" },
                 { x: 437.324, y: 703.14, text: "nonumy eirmod tempor" },
                 { x: 437.324, y: 689.268, text: "invidunt ut labore et" },
                 { x: 437.324, y: 675.396, text: "dolore magna aliquyam" },
                 { x: 437.324, y: 661.524, text: "erat, sed diam voluptua." },
                 { x: 437.324, y: 647.652, text: "At vero eos et accusam et" },
                 { x: 437.324, y: 633.78, text: "justo duo dolores et ea" },
                 { x: 437.324, y: 619.908, text: "rebum. Stet clita kasd" },
                 { x: 437.324, y: 606.036, text: "gubergren, no sea" },
                 { x: 437.324, y: 592.164, text: "takimata sanctus est L" },
                 { x: 36.0, y: 744.756, text: "Stet clita kasd gubergren, no sea takimata" },
                 { x: 36.0, y: 730.884, text: "sanctus est Lorem ipsum dolor sit amet. Lorem" },
                 { x: 36.0, y: 717.012, text: "ipsum dolor sit amet, consetetur sadipscing elitr," },
                 { x: 36.0, y: 703.14, text: "sed diam nonumy eirmod tempor invidunt ut" },
                 { x: 36.0, y: 689.268, text: "labore et dolore magna aliquyam erat, sed diam" },
                 { x: 36.0, y: 675.396, text: "voluptua. At vero eos et accusam et justo duo" },
                 { x: 36.0, y: 661.524, text: "dolores et ea rebum. Stet clita kasd gubergren," },
                 { x: 36.0, y: 647.652, text: "no sea takimata sanctus est Lorem ipsum dolor" },
                 { x: 36.0, y: 633.78, text: "sit amet." },
                 { x: 298.648, y: 744.756, text: "Lorem ipsum dolor sit" },
                 { x: 298.648, y: 730.884, text: "amet, consetetur" },
                 { x: 298.648, y: 717.012, text: "sadipscing elitr, sed diam" },
                 { x: 298.648, y: 703.14, text: "nonumy eirmod tempor" },
                 { x: 298.648, y: 689.268, text: "invidunt ut labore et" },
                 { x: 298.648, y: 675.396, text: "dolore magna aliquyam" },
                 { x: 298.648, y: 661.524, text: "erat, sed diam voluptua." },
                 { x: 298.648, y: 647.652, text: "At vero eos et accusam et" },
                 { x: 298.648, y: 633.78, text: "justo duo dolores et ea" },
                 { x: 298.648, y: 619.908, text: "rebum. Stet clita kasd" },
                 { x: 298.648, y: 606.036, text: "gubergren, no sea" },
                 { x: 298.648, y: 592.164, text: "takimata sanctus est L" },
                 { x: 437.324, y: 744.756, text: "Lorem ipsum dolor sit" },
                 { x: 437.324, y: 730.884, text: "amet, consetetur" },
                 { x: 437.324, y: 717.012, text: "sadipscing elitr, sed diam" },
                 { x: 437.324, y: 703.14, text: "nonumy eirmod tempor" },
                 { x: 437.324, y: 689.268, text: "invidunt ut labore et" },
                 { x: 437.324, y: 675.396, text: "dolore magna aliquyam" },
                 { x: 437.324, y: 661.524, text: "erat, sed diam voluptua." },
                 { x: 437.324, y: 647.652, text: "At vero eos et accusam et" },
                 { x: 437.324, y: 633.78, text: "justo duo dolores et ea" },
                 { x: 437.324, y: 619.908, text: "rebum. Stet clita kasd" },
                 { x: 437.324, y: 606.036, text: "gubergren, no sea" },
                 { x: 437.324, y: 592.164, text: "takimata sanctus est L" }
               ])
    expect_pdf_images([{ x: 41.0, y: 10.0, width: 66.164, height: 661.64 }])
  end

  it 'creates image mot larger than a page' do
    generator.parse_file('image/height.md')
    expect_pdf_images([{ x: 270.0, y: 36.0, width: 72.0, height: 720.0 }])
  end
end
