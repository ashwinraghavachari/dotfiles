dir=$(pwd)
oldfiles=$(pwd)/old
files=".vimrc .gitconfig .bash_profile"

mkdir -p $oldfiles

echo "moving old files to $oldfiles"

for file in $files; do
    echo "setting up $file"
    mv ~/$file $oldfiles/ 2>/dev/null
    ln -sf $dir/$file ~/$file
done
