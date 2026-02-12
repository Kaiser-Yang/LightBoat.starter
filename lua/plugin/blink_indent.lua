return {
  'saghen/blink.indent',
  opts = {
    mappings = {
      object_scope = '<plug>(blink-indent-inside)',
      object_scope_with_border = '<plug>(blink-indent-around)',
      goto_top = '<plug>(blink-indent-top)',
      goto_bottom = '<plug>(blink-indent-bottom)',
    },
    static = {
      whitespace_char = '·',
      char = '│',
    },
    scope = {
      enabled = true,
      char = '│',
      priority = 1000,
      highlights = {
        'BlinkIndentViolet',
        'BlinkIndentCyan',
        'BlinkIndentBlue',
        'BlinkIndentGreen',
        'BlinkIndentYellow',
        'BlinkIndentOrange',
        'BlinkIndentRed',
      },
      underline = {
        enabled = true,
        highlights = {
          'BlinkIndentVioletUnderline',
          'BlinkIndentCyanUnderline',
          'BlinkIndentBlueUnderline',
          'BlinkIndentGreenUnderline',
          'BlinkIndentYellowUnderline',
          'BlinkIndentOrangeUnderline',
          'BlinkIndentRedUnderline',
        },
      },
    },
  },
}
