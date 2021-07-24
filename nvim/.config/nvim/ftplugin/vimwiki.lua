vim.opt_local.wrap = false
vim.b.coc_pairs_disabled = { '[', '<' }
-- Use vimwiki's folding method instead vim-markdown's
vim.g.vim_markdown_folding_disabled = true

-- vim-zettel
vim.g.zettel_format = '%title-%y%m%d'
vim.g.zettel_default_mappings = false
vim.g.zettel_fzf_options = { '--exact', '--tiebreak=end', '--preview-window=up:60%' }

-- taskwiki
vim.g.taskwiki_disable_concealcursor = true
vim.g.taskwiki_data_location = '~/Documents/tasks'

require('note.markdown_vimwiki')
require('plenary.filetype').add_file('extra_filetypes')

vim.cmd[[
  augroup vimwiki_special
    autocmd!
    autocmd User visual_multi_start nunmap <buffer> w
    autocmd User visual_multi_start nunmap <buffer> b
    autocmd User visual_multi_exit imap <buffer> <c-d> <Plug>VimwikiDecreaseLvlSingleItem
    autocmd User visual_multi_exit nmap <silent><buffer> w <Plug>(coc-ci-w)
    autocmd User visual_multi_exit nmap <silent><buffer> b <Plug>(coc-ci-b)
  augroup END
]]

local success, wk = pcall(require, 'which-key')
if not success then
  return
end

wk.register({
  g = { '<cmd>VimwikiGenerateTagLinks<cr>', 'Generate tag links' },
  b = { '<cmd>VimwikiBacklinks<cr>', 'Search back links' },
  B = { '<cmd>ZettelBackLinks<cr>', 'Generate back links' },
  a = { ':<c-u>ZettelNew ', 'Add new wiki file' },
  i = { '<cmd>ZettelInsertNote<cr>', 'Insert note' },
  f = { '<cmd>ZettelOpen', 'Fuzzy find wiki file' },
  D = { '<Plug>VimwikiDeleteFile', 'Delete current wiki file' },
  r = 'Rename current wiki file',
  h = 'Convert to html',
  c = 'Colorize range of lines',
  hh = 'Open html in browser',
  t = {
    name = '+tag',
    t = { "<cmd>execute 'VimwikiSearchTags '.expand('<cword>')<cr>", 'Search tag under current cursor' },
    s = { ':<c-u>VimwikiSearchTags ', 'Search tags' }
  },
  ['<leader>'] = {
    name = '+diary',
    w = 'Open today diary',
    t = 'Open today diary in new tab',
    y = 'Open yesterday diary',
    m = 'Open tomorrow diary',
    i = 'Generate diary index'
  },
  ['<A-i>'] = { '<Plug>VimwikiNextLink', 'Go to next link' },
  ['<A-o>'] = { '<Plug>VimwikiPrevLink', 'Go to previous link' },
}, { prefix = '<leader>w', buffer = vim.api.nvim_get_current_buf() })

wk.register({
  sa = { require('xx.telescope').tags, 'Fuzzy find tags' },
  t = {
    name = '+taskwiki',
    a = 'Annotate',
    b = {
      name = '+burndown',
      d = 'Burndown daily',
      w = 'Burndown weekly',
      m = 'Burndown monthly',
    },
    c = {
      name = '+choose',
      p = 'Choose project',
      t = 'Choose tag',
    },
    C  = 'Calendar',
    d  = 'Done',
    D  = 'Delete',
    e  = 'Edit',
    g  = 'Grid',
    G = {
      name = '+ghistory',
      m = 'Month ghistory',
      a = 'Annual ghistory',
    },
    h = {
      name = '+history',
      m = 'Month history',
      a = 'Annual history',
    },
    i  = 'Info',
    l  = 'Back link',
    m  = 'Modify',
    p  = 'Projects',
    s  = 'Summary',
    S  = 'Stats',
    t  = 'Tags',
    ['.']  = 'Redo',
    ['+']  = 'Start',
    ['-']  = 'Stop',
  }
}, { prefix = '<leader>', buffer = vim.api.nvim_get_current_buf() })

wk.register({
  t = {
    name = '+taskwiki',
    a = 'Annotate',
    c = {
      name = '+choose',
      p = 'Choose project',
      t = 'Choose tag',
    },
    d  = 'Done',
    D  = 'Delete',
    e  = 'Edit',
    g  = 'Grid',
    i  = 'Info',
    l  = 'Back link',
    m  = 'Modify',
    ['.']  = 'Redo',
    ['+']  = 'Start',
    ['-']  = 'Stop',
  }
}, { mode = 'v', prefix = '<leader>', buffer = vim.api.nvim_get_current_buf() })

wk.register({
  l = {
    name = '+curent-list-item',
    t = { '<Plug>VimwikiRemoveSingleCB', 'Remove checkbox from list item' },
    r = 'Renumber list items',
    l = 'Increase item level',
    h = 'Decrease item level',
    n = 'Increase done status',
    p = 'Decrease done status',
    x = 'Toggle checkbox disabled/off',
    ['*'] = 'Add/change item symbol to *',
    ['-'] = 'Add/change item symbol to -',
    ['1'] = 'Add/change item symbol to 1',
  },
  L = {
    name = '+all-list-items',
    t = { '<Plug>VimwikiRemoveCBInList', 'Remove checkbox from all sibling items' },
    r = 'Renumber list items in whole file',
    R = 'Renumber list items in whole file',
    l = 'Increase list level and all children',
    L = 'Increase list level and all children',
    h = 'Decrease list level and all children',
    H = 'Decrease list level and all children',
    ['*'] = 'Change list symbol to *',
    ['-'] = 'Change list symbol to -',
    ['1'] = 'Change list symbol to number',
  }
}, { prefix = 'g', buffer = vim.api.nvim_get_current_buf() })

if vim.fn.expand('%:e') == 'wiki' then
  wk.register({
    b = { '**<Space><++><Esc>F*i', 'Bold' },
    B = { '*__*<Space><++><Esc>F_i', 'Bold italic' },
    d = { '~~~~<Space><++><Esc>F~hi', 'Delete' },
    i = { '__<Space><++><Esc>F_i', 'Italic' },
    C = { '{{{<CR>}}}<Esc>ka', 'Code' },
    p = { '{{<bar><++>}}<Space><++><Esc>F{a', 'Picture' },
    a = { '[[<bar><++>]]<Space><++><Esc>F[a', 'Link' },
    r = { '==<Space>Reference<Space>==<CR><Esc>', 'Reference' },
    M = { '{{$<CR>}}$<Esc>kA', 'Math block' },
    ['1'] = { '=<Space><Space>=<Space><++><Esc>F=hi', 'Header 1' },
    ['2'] = { '==<Space><Space>==<Space><++><Esc>F=2hi', 'Header 2' },
    ['3'] = { '===<Space><Space>===<Space><++><Esc>F=3hi', 'Header 3' },
    ['4'] = { '====<Space><Space>====<Space><++><Esc>F=4hi', 'Header 4' },
    z = { '[[<esc><cmd>ZettelSearch<cr>', 'Search link to insert' }
  }, { mode = 'i', prefix = ';', buffer = vim.api.nvim_get_current_buf() })
  wk.register({
    y = { '<Plug>ZettelYankNameMap', 'Yank current zettel name and tile' },
    z = { '<Plug>ZettelReplaceFileWithLink', 'Replace file with link' },
  }, { prefix = 'g', buffer = vim.api.nvim_get_current_buf() })
  wk.register({
    z = { '<Plug>ZettelNewSelectedMap', 'Create new zettel from selected' },
  }, { mode = 'x', prefix = 'g', buffer = vim.api.nvim_get_current_buf() })
end

vim.cmd [[hi! link Conceal Function]]
