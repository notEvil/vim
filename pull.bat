xcopy %userprofile%/.vimrc .vimrc
call ./add_commit
git pull https://github.com/notEvil/vim.git
xcopy .vimrc %userprofile%/.vimrc
