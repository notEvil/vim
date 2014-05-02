xcopy /Y %userprofile%\.vimrc .vimrc
call .\add_commit.bat
git push https://github.com/notEvil/vim.git
