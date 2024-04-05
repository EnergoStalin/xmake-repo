local overseer = require('overseer')

overseer.register_template({
  name = 'create',
  builder = function(params)
    local pkgdir = vim.fn.join({ 'packages', params.name:sub(1, 1), params.name }, '/')
    local xmake = vim.fn.join({ pkgdir, 'xmake.lua' }, '/')
    return {
      cmd = 'mkdir -p ' .. pkgdir .. ' && touch ' .. xmake,
      components = { 'default', 'unique' },
    }
  end,
  params = {
    name = {
      type = 'string',
    },
  },
})
