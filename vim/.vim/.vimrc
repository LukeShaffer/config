" Copied selectively from https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim

" Sections
"	-> General
"	-> VIM user interface
"	-> Colors and Fonts
"	-> Files and backups
"	-> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Avoid garbled characters in Chines language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" Configure backspaceso it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executine macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Add a bit of extra margin to the left
set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Set regular expression engine automatically
set regexpengine=0

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif

try
	colorscheme desert
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
	set guioptions-=T
	set guioptions-=e
	set t_Co=256
	set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
" set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap " Wrap lines



""""""""""""""""""""""""""""""
" => Visual mode related
" """"""""""""""""""""""""""""""
" " Visual mode pressing * or # searches for the current selection
" " Super useful! From an idea by Michael Naumann
noremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
noremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>








""""""""""""""""""""""""""""""
" => Status line
" """"""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
"
" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \Line:\ %l\ \ Column:\ %c



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
            return 'PASTE MODE  '
                endif
                    return ''
                    endfunction


" Edit filetype configuration files
" Usage: ':call Edit_ft_conf("file")'
" Purpose: open all scripts which get loaded implicitly by opening "file"
" (syntax highlighting, indentation, filetype plugins, ..)
" The order of windows reflects the order of script loading (but "file" is
" the topmost window)
fun! Edit_ft_conf(name)
  " we may not do this with a loaded file, since this won't trigger the
  " configuration file loading as desired.
  " try calling with 'call Edit_ft_conf("nonexistingfile.<EXT>")' if this
  " gives you troubles
  if bufexists(a:name) && bufloaded(a:name)
    echo "!Attention: buffer for " . a:name . " is loaded, unload first."
    return
  endif
  " split-open the file with verbose set, grab the output into a register
  " (without clobbering)
  let safereg = @u
  redir @u " redirect command output to register @u
  exec "silent 2verbose split " . a:name
  " verbose level 2 suffices to catch all scripts which get opened
  redir END
  " Parse register @u, looking for smth like: 'sourcing"/usr/local/share/vim/vim60/syntax/c.vim"'
  let pos = 0
  let regexp = 'sourcing "[^"]\+"'
  while match(@u,regexp,pos) >= 0
    let file = matchstr(@u,regexp,pos)
    let pos = matchend (@u,regexp,pos)
    let file = strpart(file,10,strlen(file)-11)
    exec "silent below split " . file
  endwhile
  " restore the register
  let @u = safereg
endfun
