_G.user = _G.user or {}

function P(v)
  vim.cmd.echom({ args = { vim.fn.string(vim.inspect(v)) }, mods = { unsilent = true } })
end

vim.filetype.add({
  -- Match specific Docker Compose filenames explicitly
  filename = {
    ['docker-compose.yml'] = 'yaml.docker-compose',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
    ['compose.yml'] = 'yaml.docker-compose',
    ['compose.yaml'] = 'yaml.docker-compose',
  },
  extension = {
    cconf = 'python',
    rbi = 'ruby',
    -- Go templates
    gotmpl = 'gotmpl',
    gohtml = 'gohtml',
    gowork = 'gowork',

    -- JavaScript / Web Ecosystem
    hbs = 'handlebars',
    ejs = 'ejs',
    postcss = 'postcss',

    -- Python / Django
    ['django-html'] = 'htmldjango', -- Use brackets because of the hyphen

    -- ASP.NET Core Razor / Blazor
    cshtml = 'aspnetcorerazor',
    razor = 'aspnetcorerazor',

    -- React / JSX Compound Types
    ['typescript.tsx'] = 'typescriptreact',
    ['javascript.jsx'] = 'javascriptreact',
  },
  pattern = {
    ['.*/%.vscode/.*%.json'] = 'json5', -- These json files frequently have comments
    ['.*%.go%.tmpl'] = 'gotmpl',
  },
})
