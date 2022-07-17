nmap <Leader>b <Cmd>CocCommand explorer --no-toggle --sources=buffer+,file+<CR>

nmap <Leader>er <Cmd>call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<CR>

