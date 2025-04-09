return ---- pixo related plugins ----
{
  'jamespixovr/pixovr.nvim',
  enabled = false,
  event = 'VeryLazy',
  cmd = { 'Pixovr' },
  dependencies = {
    'stevearc/overseer.nvim',
    'MunifTanjim/nui.nvim',
  },
  config = true,
}
