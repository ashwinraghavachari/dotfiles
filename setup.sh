dir=$(pwd)
oldfiles=$(pwd)/old
files=".vimrc .gitconfig .bashrc .bash_aliases"

mkdir -p $oldfiles

echo "moving old files to $oldfiles"

for file in $files; do
    echo "setting up $file"
    mv ~/$file $oldfiles/ 2>/dev/null
    ln -sf $dir/$file ~/$file
done
