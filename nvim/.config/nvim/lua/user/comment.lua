local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

-- Set the comment strings for C/C++
local ft = require('Comment.ft')
ft.set('c', '//%s')
ft.set('cpp', '//%s') 
ft.set('h', '//%s')
ft.set('hpp', '//%s')

comment.setup {
  -- No pre_hook needed!
}
