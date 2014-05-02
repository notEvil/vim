xcopy /Y %userprofile%\.vimrc .vimrc
call .\add_commit.bat
git push --set-upstream https://github.com/notEvil/vim.git master
