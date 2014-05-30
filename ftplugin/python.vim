
nnoremap <buffer> ]] :<C-U>call pymode#motion#move('\v^\s*(class\|def)\s', '')<CR>
nnoremap <buffer> [[ :<C-U>call pymode#motion#move('\v^\s*(class\|def)\s', 'b')<CR>
nnoremap <buffer> ]C :<C-U>call pymode#motion#move('\v^\s*(class\|def)\s', '')<CR>
nnoremap <buffer> [C :<C-U>call pymode#motion#move('\v^\s*(class\|def)\s', 'b')<CR>
nnoremap <buffer> ]M :<C-U>call pymode#motion#move('\v^\s*def\s', '')<CR>
nnoremap <buffer> [M :<C-U>call pymode#motion#move('\v^\s*def\s', 'b')<CR>
onoremap <buffer> ]] :<C-U>call pymode#motion#move('\v^\s*(class\|def)\s', '')<CR>
onoremap <buffer> [[ :<C-U>call pymode#motion#move('\v^\s*(class\|def)\s', 'b')<CR>
onoremap <buffer> ]C :<C-U>call pymode#motion#move('\v^\s*(class\|def)\s', '')<CR>
onoremap <buffer> [C :<C-U>call pymode#motion#move('\v^\s*(class\|def)\s', 'b')<CR>
onoremap <buffer> ]M :<C-U>call pymode#motion#move('\v^\s*def\s', '')<CR>
onoremap <buffer> [M :<C-U>call pymode#motion#move('\v^\s*def\s', 'b')<CR>
vnoremap <buffer> ]] :<C-U>call pymode#motion#vmove('\v^\s*(class\|def)\s', '')<CR>
vnoremap <buffer> [[ :<C-U>call pymode#motion#vmove('\v^\s*(class\|def)\s', 'b')<CR>
vnoremap <buffer> ]M :<C-U>call pymode#motion#vmove('\v^\s*def\s', '')<CR>
vnoremap <buffer> [M :<C-U>call pymode#motion#vmove('\v^\s*def\s', 'b')<CR>
onoremap <buffer> C  :<C-U>call pymode#motion#select('\v^\s*class\s', 0)<CR>
onoremap <buffer> aC :<C-U>call pymode#motion#select('\v^\s*class\s', 0)<CR>
onoremap <buffer> iC :<C-U>call pymode#motion#select('\v^\s*class\s', 1)<CR>
vnoremap <buffer> aC :<C-U>call pymode#motion#select('\v^\s*class\s', 0)<CR>
vnoremap <buffer> iC :<C-U>call pymode#motion#select('\v^\s*class\s', 1)<CR>
onoremap <buffer> M  :<C-U>call pymode#motion#select('\v^\s*def\s', 0)<CR>
onoremap <buffer> aM :<C-U>call pymode#motion#select('\v^\s*def\s', 0)<CR>
onoremap <buffer> iM :<C-U>call pymode#motion#select('\v^\s*def\s', 1)<CR>
vnoremap <buffer> aM :<C-U>call pymode#motion#select('\v^\s*def\s', 0)<CR>
vnoremap <buffer> iM :<C-U>call pymode#motion#select('\v^\s*def\s', 1)<CR>

