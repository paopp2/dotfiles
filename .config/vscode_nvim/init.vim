set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

function! s:saveAllAndRefreshGit(...) abort
    call VSCodeNotify('workbench.action.files.saveAll')
    call VSCodeNotify('git.refresh')
endfunction

if exists('g:vscode')
    nnoremap <Leader>s <Cmd>call <SID>saveAllAndRefreshGit()<CR>
    "nnoremap <Space> <Cmd>call <SID>saveAllAndRefreshGit()<CR>
    " nnoremap <Space> <Cmd>call VSCodeNotify('workbench.action.files.saveAll')<CR>
    " nnoremap <Space> <Cmd>call VSCodeNotify('git.refresh')<CR>

    nnoremap gh <Cmd>call VSCodeNotify('editor.action.showDefinitionPreviewHover')<Cr>
    nnoremap gd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
    nnoremap <Leader>gd <Cmd>call VSCodeNotify('references-view.findReferences')<CR>
    "nnoremap <Leader><Leader> <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
    nnoremap <Leader>d <Cmd>call VSCodeNotify('workbench.action.debug.continue')<CR>
    nnoremap <Leader><Leader>d <Cmd>call VSCodeNotify('workbench.action.debug.start')<CR>
    nnoremap <Leader><Leader>D <Cmd>call VSCodeNotify('workbench.action.debug.stop')<CR>

    nnoremap <Leader>cc <Cmd>call VSCodeNotify('gitlens.compareWith')<CR>
    nnoremap <Leader>cw <Cmd>call VSCodeNotify('gitlens.compareWorkingWith')<CR>
    nnoremap <Leader>ch <Cmd>call VSCodeNotify('gitlens.compareHeadWith')<CR>

    nnoremap ]e <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
    nnoremap [e <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
    nnoremap ]c <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
    nnoremap [c <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
    "nnoremap <Leader>ne <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
    "nnoremap <Leader>pe <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
    "nnoremap <Leader>nc <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
    "nnoremap <Leader>pc <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
    "nnoremap <Leader>nc <Cmd>call VSCodeNotify('editor.action.dirtydiff.next')<CR>

    nnoremap << <Cmd>call VSCodeNotify('workbench.action.moveEditorLeftInGroup')<CR>
    nnoremap >> <Cmd>call VSCodeNotify('workbench.action.moveEditorRightInGroup')<CR>

    "nnoremap / <Cmd>call VSCodeNotify('actions.find')<CR>
    "nnoremap n <Cmd>call VSCodeNotify('editor.action.nextMatchFindAction')<CR>
    "nnoremap N <Cmd>call VSCodeNotify('editor.action.previousMatchFindAction')<CR>
endif
