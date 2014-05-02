xcopy /Y %userprofile%\.vimrc .vimrc
call .\add_commit.bat
git pull https://github.com/notEvil/vim.git
xcopy /Y .vimrc %userprofile%\.vimrc
