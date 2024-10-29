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
    nnoremap <Leader>s <Cmd>lua require('vscode-neovim').action('workbench.action.files.saveAll')<CR>
    " nnoremap <Space> <Cmd>call VSCodeNotify('git.refresh')<CR>

    nnoremap gh <Cmd>lua require('vscode-neovim').action('editor.action.showDefinitionPreviewHover')<CR>
    vnoremap gh <Cmd>lua require('vscode-neovim').action('editor.action.showDefinitionPreviewHover')<CR>

    nnoremap gd <Cmd>lua require('vscode-neovim').action('editor.action.revealDefinition')<CR>
    nnoremap <Leader>gd <Cmd>lua require('vscode-neovim').action('references-view.findReferences')<CR>
    "nnoremap <Leader><Leader> <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
    nnoremap <Leader>dc <Cmd>lua require('vscode-neovim').action('workbench.action.debug.continue')<CR>
    nnoremap <Leader>ds <Cmd>lua require('vscode-neovim').action('workbench.action.debug.start')<CR>
    nnoremap <Leader>dS <Cmd>lua require('vscode-neovim').action('workbench.action.debug.stop')<CR>

    nnoremap <Leader>cc <Cmd>lua require('vscode-neovim').action('gitlens.compareWith')<CR>
    nnoremap <Leader>cw <Cmd>lua require('vscode-neovim').action('gitlens.compareWorkingWith')<CR>
    nnoremap <Leader>ch <Cmd>lua require('vscode-neovim').action('gitlens.compareHeadWith')<CR>

    nnoremap <Leader>l <Cmd>lua require('vscode-neovim').action('aichat.newchataction')<CR>
    nnoremap <Leader>k <Cmd>lua require('vscode-neovim').action('aipopup.action.modal.generate')<CR>
    vnoremap <Leader>l <Cmd>lua require('vscode-neovim').action('aichat.newchataction')<CR>
    vnoremap <Leader>k <Cmd>lua require('vscode-neovim').action('aipopup.action.modal.generate')<CR>

    nnoremap ]e <Cmd>lua require('vscode-neovim').action('editor.action.marker.nextInFiles')<CR>
    nnoremap [e <Cmd>lua require('vscode-neovim').action('editor.action.marker.prevInFiles')<CR>
    nnoremap ]c <Cmd>lua require('vscode-neovim').action('workbench.action.editor.nextChange')<CR>
    nnoremap [c <Cmd>lua require('vscode-neovim').action('workbench.action.editor.previousChange')<CR>
    nnoremap ]C <Cmd>lua require('vscode-neovim').action('workbench.action.compareEditor.nextChange')<CR>
    nnoremap [C <Cmd>lua require('vscode-neovim').action('workbench.action.compareEditor.previousChange')<CR>
    nnoremap ]f <Cmd>lua require('vscode-neovim').action('editor.gotoNextFold')<CR>
    nnoremap [f <Cmd>lua require('vscode-neovim').action('editor.gotoPreviousFold')<CR>
    nnoremap ]b <Cmd>lua require('vscode-neovim').action('editor.debug.action.goToNextBreakpoint')<CR>
    nnoremap [b <Cmd>lua require('vscode-neovim').action('editor.debug.action.goToPreviousBreakpoint')<CR>
    vnoremap ]b <Cmd>lua require('vscode-neovim').action('editor.debug.action.goToNextBreakpoint')<CR>
    vnoremap [b <Cmd>lua require('vscode-neovim').action('editor.debug.action.goToPreviousBreakpoint')<CR>

    nnoremap << <Cmd>lua require('vscode-neovim').action('workbench.action.moveEditorLeftInGroup')<CR>
    nnoremap >> <Cmd>lua require('vscode-neovim').action('workbench.action.moveEditorRightInGroup')<CR>

    vnoremap u <Cmd>lua require('vscode-neovim').action('git.revertSelectedRanges')<CR>

    nnoremap <Leader>f <Cmd>lua require('vscode-neovim').action('editor.toggleFold')<CR>
    nnoremap <Leader><Leader>f <Cmd>lua require('vscode-neovim').action('editor.foldAll')<CR>
    nnoremap <Leader><Leader>F <Cmd>lua require('vscode-neovim').action('editor.unfoldAll')<CR>

    nnoremap <Leader>b <Cmd>lua require('vscode-neovim').action('editor.debug.action.toggleBreakpoint')<CR>
    nnoremap <Leader>B <Cmd>lua require('vscode-neovim').action('workbench.debug.viewlet.action.toggleBreakpointsActivatedAction')<CR>
    nnoremap <Leader>db <Cmd>lua require('vscode-neovim').action('workbench.debug.viewlet.action.removeAllBreakpoints')<CR>

    nnoremap <Leader>xo <Cmd>lua require('vscode-neovim').action('workbench.action.closeOtherEditors')<CR>
endif
