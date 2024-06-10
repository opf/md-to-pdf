require 'pdf_helpers'

# TODO: test image objects in pdf

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
                 { x: 41.0, y: 739.756, text: "Quote 1 An image in the middle of" },
                 { x: 41.0, y: 288.879, text: "a quote Quote 2" }])
    expect_pdf_images([
                        { x: 268.5, y: 696.69375, width: 75.0, height: 59.30625 },
                        { x: 156.0, y: 459.46875, width: 300.0, height: 237.225 },
                        { x: 156.0, y: 208.37175, width: 300.0, height: 237.225 },
                        { x: 159.768, y: 518.775, width: 300.0, height: 237.225 },
                        { x: 41.0, y: 309.623, width: 527.35378, height: 417.005 }])
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

  it 'creates image in table' do
    generator.parse_file('image/in_table.md', { headless_table: { auto_width: true } })
    expect_pdf([
                 { x: 41.0, y: 739.756, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 725.884, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
                 { x: 41.0, y: 712.012, text: "" },
                 { x: 41.0, y: 606.37944, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 592.50744, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 41.0, y: 578.63544, text: "tempor " },
                 { x: 306.0, y: 744.756, text: "Lorem ipsum dolor sit amet, consetetur sadipscing" },
                 { x: 306.0, y: 730.884, text: "elitr, sed diam nonumy eirmod tempor invidunt ut" },
                 { x: 306.0, y: 717.012, text: "labore et dolore magna aliquyam erat, sed diam" },
                 { x: 306.0, y: 703.14, text: "voluptua. At vero eos et accusam et justo duo" },
                 { x: 306.0, y: 689.268, text: "dolores et ea rebum. Stet clita kasd gubergren, no" },
                 { x: 306.0, y: 675.396, text: "sea takimata sanctus est L" },
                 { x: 36.0, y: 559.76344, text: "Lorem ipsum dolor sit amet, consetetur sadipscing" },
                 { x: 36.0, y: 545.89144, text: "elitr, sed diam nonumy" },
                 { x: 311.0, y: 554.76344, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 311.0, y: 540.89144, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
                 { x: 311.0, y: 527.01944, text: "" },
                 { x: 311.0, y: 421.38687, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 311.0, y: 407.51487, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 311.0, y: 393.64287, text: "tempor " },
                 { x: 311.0, y: 288.01031, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 311.0, y: 274.13831, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
                 { x: 311.0, y: 260.26631, text: "" },
                 { x: 36.0, y: 241.39431, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 36.0, y: 227.52231, text: "sadipscing elitr, sed diam nonumy" },
                 { x: 257.324, y: 241.39431, text: "Lorem ipsum dolor sit" },
                 { x: 257.324, y: 227.52231, text: "amet, consetetur" },
                 { x: 257.324, y: 213.65031, text: "sadipscing elitr, sed diam" },
                 { x: 257.324, y: 199.77831, text: "nonumy" },
                 { x: 401.0, y: 236.39431, text: "Lorem ipsum dolor sit amet," },
                 { x: 401.0, y: 222.52231, text: "consetetur sadipscing elitr, sed" },
                 { x: 401.0, y: 208.65031, text: "diam nonumy eirmod tempor" },
                 { x: 401.0, y: 194.77831, text: "invidunt ut labore et dolore" },
                 { x: 401.0, y: 180.90631, text: "magna aliquyam erat, " },
                 { x: 401.0, y: 167.03431, text: "" },
                 { x: 401.0, y: 88.65527, text: "Lorem ipsum dolor sit amet," },
                 { x: 401.0, y: 74.78327, text: "consetetur sadipscing elitr, sed" },
                 { x: 401.0, y: 60.91127, text: "diam nonumy eirmod tempor " },
                 { x: 41.0, y: 739.756, text: "" },
                 { x: 41.0, y: 629.884, text: "" }])
    expect_pdf_images([
                        { x: 41.0, y: 627.12344, width: 236.97674, height: 71.76056 },
                        { x: 311.0, y: 442.13087, width: 236.97674, height: 71.76056 },
                        { x: 311.0, y: 308.75431, width: 236.97674, height: 71.76056 },
                        { x: 401.0, y: 109.39927, width: 146.97674, height: 44.50704 },
                        { x: 41.0, y: 650.628, width: 250.97674, height: 76.0 }])
  end

  it 'creates large image in table' do
    generator.parse_file('image/large_in_table.md', { headless_table: { auto_width: true } })
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "With image style.width:" },
                 { x: 41.0, y: 725.884, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 712.012, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 41.0, y: 698.14, text: "tempor invidunt ut labore et dolore magna" },
                 { x: 41.0, y: 684.268, text: "aliquyam erat, " },
                 { x: 41.0, y: 505.01362, text: "sed diam voluptua. At vero eos et accusam et" },
                 { x: 41.0, y: 491.14162, text: "justo duo dolores et ea rebum. " },
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
                 { x: 36.0, y: 472.26962, text: "Stet clita kasd gubergren, no sea takimata" },
                 { x: 36.0, y: 458.39762, text: "sanctus est Lorem ipsum dolor sit amet. Lorem" },
                 { x: 36.0, y: 444.52562, text: "ipsum dolor sit amet, consetetur sadipscing elitr," },
                 { x: 36.0, y: 430.65362, text: "sed diam nonumy eirmod tempor invidunt ut" },
                 { x: 36.0, y: 416.78162, text: "labore et dolore magna aliquyam erat, sed diam" },
                 { x: 36.0, y: 402.90962, text: "voluptua. At vero eos et accusam et justo duo" },
                 { x: 36.0, y: 389.03762, text: "dolores et ea rebum. Stet clita kasd gubergren," },
                 { x: 36.0, y: 375.16562, text: "no sea takimata sanctus est Lorem ipsum dolor" },
                 { x: 36.0, y: 361.29362, text: "sit amet." },
                 { x: 298.648, y: 472.26962, text: "Lorem ipsum dolor sit" },
                 { x: 298.648, y: 458.39762, text: "amet, consetetur" },
                 { x: 298.648, y: 444.52562, text: "sadipscing elitr, sed diam" },
                 { x: 298.648, y: 430.65362, text: "nonumy eirmod tempor" },
                 { x: 298.648, y: 416.78162, text: "invidunt ut labore et" },
                 { x: 298.648, y: 402.90962, text: "dolore magna aliquyam" },
                 { x: 298.648, y: 389.03762, text: "erat, sed diam voluptua." },
                 { x: 298.648, y: 375.16562, text: "At vero eos et accusam et" },
                 { x: 298.648, y: 361.29362, text: "justo duo dolores et ea" },
                 { x: 298.648, y: 347.42162, text: "rebum. Stet clita kasd" },
                 { x: 298.648, y: 333.54962, text: "gubergren, no sea" },
                 { x: 298.648, y: 319.67762, text: "takimata sanctus est L" },
                 { x: 437.324, y: 472.26962, text: "Lorem ipsum dolor sit" },
                 { x: 437.324, y: 458.39762, text: "amet, consetetur" },
                 { x: 437.324, y: 444.52562, text: "sadipscing elitr, sed diam" },
                 { x: 437.324, y: 430.65362, text: "nonumy eirmod tempor" },
                 { x: 437.324, y: 416.78162, text: "invidunt ut labore et" },
                 { x: 437.324, y: 402.90962, text: "dolore magna aliquyam" },
                 { x: 437.324, y: 389.03762, text: "erat, sed diam voluptua." },
                 { x: 437.324, y: 375.16562, text: "At vero eos et accusam et" },
                 { x: 437.324, y: 361.29362, text: "justo duo dolores et ea" },
                 { x: 437.324, y: 347.42162, text: "rebum. Stet clita kasd" },
                 { x: 437.324, y: 333.54962, text: "gubergren, no sea" },
                 { x: 437.324, y: 319.67762, text: "takimata sanctus est L" },
                 { x: 36.0, y: 308.43362, text: "Without image style.width:" },
                 { x: 41.0, y: 739.756, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 725.884, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 41.0, y: 712.012, text: "tempor invidunt ut labore et dolore magna" },
                 { x: 41.0, y: 698.14, text: "aliquyam erat, " },
                 { x: 41.0, y: 466.57909, text: "sed diam voluptua. At vero eos et accusam et" },
                 { x: 41.0, y: 452.70709, text: "justo duo dolores et ea rebum. " },
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
                 { x: 36.0, y: 433.83509, text: "Stet clita kasd gubergren, no sea takimata" },
                 { x: 36.0, y: 419.96309, text: "sanctus est Lorem ipsum dolor sit amet. Lorem" },
                 { x: 36.0, y: 406.09109, text: "ipsum dolor sit amet, consetetur sadipscing elitr," },
                 { x: 36.0, y: 392.21909, text: "sed diam nonumy eirmod tempor invidunt ut" },
                 { x: 36.0, y: 378.34709, text: "labore et dolore magna aliquyam erat, sed diam" },
                 { x: 36.0, y: 364.47509, text: "voluptua. At vero eos et accusam et justo duo" },
                 { x: 36.0, y: 350.60309, text: "dolores et ea rebum. Stet clita kasd gubergren," },
                 { x: 36.0, y: 336.73109, text: "no sea takimata sanctus est Lorem ipsum dolor" },
                 { x: 36.0, y: 322.85909, text: "sit amet." },
                 { x: 298.648, y: 433.83509, text: "Lorem ipsum dolor sit" },
                 { x: 298.648, y: 419.96309, text: "amet, consetetur" },
                 { x: 298.648, y: 406.09109, text: "sadipscing elitr, sed diam" },
                 { x: 298.648, y: 392.21909, text: "nonumy eirmod tempor" },
                 { x: 298.648, y: 378.34709, text: "invidunt ut labore et" },
                 { x: 298.648, y: 364.47509, text: "dolore magna aliquyam" },
                 { x: 298.648, y: 350.60309, text: "erat, sed diam voluptua." },
                 { x: 298.648, y: 336.73109, text: "At vero eos et accusam et" },
                 { x: 298.648, y: 322.85909, text: "justo duo dolores et ea" },
                 { x: 298.648, y: 308.98709, text: "rebum. Stet clita kasd" },
                 { x: 298.648, y: 295.11509, text: "gubergren, no sea" },
                 { x: 298.648, y: 281.24309, text: "takimata sanctus est L" },
                 { x: 437.324, y: 433.83509, text: "Lorem ipsum dolor sit" },
                 { x: 437.324, y: 419.96309, text: "amet, consetetur" },
                 { x: 437.324, y: 406.09109, text: "sadipscing elitr, sed diam" },
                 { x: 437.324, y: 392.21909, text: "nonumy eirmod tempor" },
                 { x: 437.324, y: 378.34709, text: "invidunt ut labore et" },
                 { x: 437.324, y: 364.47509, text: "dolore magna aliquyam" },
                 { x: 437.324, y: 350.60309, text: "erat, sed diam voluptua." },
                 { x: 437.324, y: 336.73109, text: "At vero eos et accusam et" },
                 { x: 437.324, y: 322.85909, text: "justo duo dolores et ea" },
                 { x: 437.324, y: 308.98709, text: "rebum. Stet clita kasd" },
                 { x: 437.324, y: 295.11509, text: "gubergren, no sea" },
                 { x: 437.324, y: 281.24309, text: "takimata sanctus est L" }])
    expect_pdf_images([
                        { x: 41.0, y: 525.75762, width: 183.85378, height: 145.38238 },
                        { x: 41.0, y: 487.32309, width: 250.00178, height: 197.68891 }])
  end
end
