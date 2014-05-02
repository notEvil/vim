xcopy /Y %userprofile%\.vimrc .vimrc
call .\add_commit.bat
git pull https://github.com/notEvil/vim.git
xcopy .vimrc %userprofile%\.vimrc
