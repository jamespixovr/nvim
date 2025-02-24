return {
  name = 'maven build',
  builder = function()
    return {
      cmd = { 'mvn' },
      args = { 'clean', 'install', '-DskipTests' },
      components = {
        {
          'on_output_parse',
          parser = {
            diagnostics = {
              'sequence',
              {
                'extract',
                {
                  append = true,
                },
                -- Match Maven output with line numbers
                '^%[([^%]]+)%]%s+([^:]+):(%d+):[%d]+:%s+(.+)$',
                'type',
                'filename',
                'lnum',
                'text',
              },
              {
                'extract',
                {
                  append = true,
                },
                -- Match Maven output without line numbers
                '^%[([^%]]+)%]%s+([^:]+):%s+(.+)$',
                'type',
                'filename',
                'text',
              },
            },
          },
        },
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'java' },
  },
}
