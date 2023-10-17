set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

"function! s:saveAllAndRefreshGit(...) abort
    "call VSCodeNotify('workbench.action.files.saveAll')
    "call VSCodeNotify('git.refresh')
"endfunction

if exists('g:vscode')
    " nnoremap <Leader>s <Cmd>call <SID>saveAllAndRefreshGit()<CR>
    "nnoremap <Space> <Cmd>call <SID>saveAllAndRefreshGit()<CR>
    nnoremap <Leader>s <Cmd>call VSCodeNotify('workbench.action.files.saveAll')<CR>
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
    nnoremap ]f <Cmd>call VSCodeNotify('editor.gotoNextFold')<CR>
    nnoremap [f <Cmd>call VSCodeNotify('editor.gotoPreviousFold')<CR>

    nnoremap << <Cmd>call VSCodeNotify('workbench.action.moveEditorLeftInGroup')<CR>
    nnoremap >> <Cmd>call VSCodeNotify('workbench.action.moveEditorRightInGroup')<CR>

    vnoremap u <Cmd>call VSCodeNotify('git.revertSelectedRanges')<CR>

    nnoremap <Leader>f <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
    nnoremap <Leader><Leader>f <Cmd>call VSCodeNotify('editor.foldAll')<CR>
    nnoremap <Leader><Leader>F <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>

    nnoremap <Leader>b <Cmd>call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>
    nnoremap <Leader><Leader>b <Cmd>call VSCodeNotify('workbench.debug.viewlet.action.toggleBreakpointsActivatedAction')<CR>
    nnoremap <Leader><Leader>B <Cmd>call VSCodeNotify('workbench.debug.viewlet.action.removeAllBreakpoints')<CR>
endif
