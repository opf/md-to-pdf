require 'pdf_helpers'

describe MarkdownToPDF::Blockquote do
  include_context 'with pdf'

  it 'creates a blockquote' do
    generator.parse_file('blockquote/blockquote.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Blockquotes can also be nested…" },
                 { x: 56.0, y: 730.884, text: "…by using additional greater-than signs right next to each other…" },
                 { x: 76.0, y: 717.012, text: "…or with spaces between arrows." }])
  end

  it 'creates a blockquote with image' do
    generator.parse_file('blockquote/image.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Blockquotes can also contain images…" },
                 { x: 61.0, y: 725.884, text: "…before image" },
                 { x: 61.0, y: 290.822, text: "after image…" }])
  end

  it 'creates a blockquote with limited list support' do
    generator.parse_file('blockquote/list.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Lists in Blockquotes are currently only partly supported" },
                 { x: 36.0, y: 730.884, text: "entry 1" },
                 { x: 36.0, y: 717.012, text: "entry 2" },
                 { x: 36.0, y: 703.14, text: "entry 3" }])
  end

  it 'creates a blockquote with formatting' do
    generator.parse_file('blockquote/formatting.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Blockquotes can be f" },
                 { x: 147.156, y: 744.756, text: "or" },
                 { x: 159.156, y: 744.756, text: "m" },
                 { x: 169.152, y: 744.756, text: "att" },
                 { x: 182.496, y: 744.756, text: "ed " },
                 { x: 199.176, y: 744.756, text: "strikethrough" },
                 { x: 268.476, y: 744.756, text: " " },
                 { x: 271.812, y: 744.756, text: "underline" }])
  end

  def compile_alert_styles(color)
    {
      border_color: color,
      alert_color: color,
      padding: '4mm',
      border_width: 2,
      no_border_right: true,
      no_border_left: false,
      no_border_bottom: true,
      no_border_top: true
    }
  end

  it 'creates alert boxes' do
    generator.parse_file('blockquote/alerts.md',
                         {
                           blockquote: compile_alert_styles('000000'),
                           alerts: {
                             NOTE: compile_alert_styles('0969da'),
                             TIP: compile_alert_styles('1a7f37'),
                             IMPORTANT: compile_alert_styles('8250df'),
                             WARNING: compile_alert_styles('bf8700'),
                             CAUTION: compile_alert_styles('d1242f')
                           }
                         })
    expect_pdf([
                 { x: 47.33858, y: 731.83342, text: "" },
                 { x: 59.33858, y: 731.83342, text: " " },
                 { x: 62.67458, y: 731.83342, text: "Note" },
                 { x: 47.33858, y: 704.08942, text: "Useful information that users should know, even when skimming content." },
                 { x: 47.33858, y: 665.95625, text: "" },
                 { x: 59.33858, y: 665.95625, text: " " },
                 { x: 62.67458, y: 665.95625, text: "Tip" },
                 { x: 47.33858, y: 638.21225, text: "Helpful advice for doing things better or more easily." },
                 { x: 47.33858, y: 600.07909, text: "" },
                 { x: 59.33858, y: 600.07909, text: " " },
                 { x: 62.67458, y: 600.07909, text: "Important" },
                 { x: 47.33858, y: 572.33509, text: "Key information users need to know to achieve their goal." },
                 { x: 47.33858, y: 534.20192, text: "" },
                 { x: 59.33858, y: 534.20192, text: " " },
                 { x: 62.67458, y: 534.20192, text: "Warning" },
                 { x: 47.33858, y: 506.45792, text: "Urgent info that needs immediate user attention to avoid problems." },
                 { x: 47.33858, y: 468.32476, text: "" },
                 { x: 59.33858, y: 468.32476, text: " " },
                 { x: 62.67458, y: 468.32476, text: "Caution" },
                 { x: 47.33858, y: 440.58076, text: "Advises about risks or negative outcomes of certain actions." },
                 { x: 47.33858, y: 404.03159, text: "A normal quote in between" },
                 { x: 47.33858, y: 365.89843, text: "" },
                 { x: 59.33858, y: 365.89843, text: " " },
                 { x: 62.67458, y: 365.89843, text: "With an own title" },
                 { x: 47.33858, y: 338.15443, text: "Useful information that users should know, even when skimming content." },
                 { x: 47.33858, y: 301.60526, text: "[!UNKNOWN]" }])
  end
end
