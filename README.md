**My Linux Dotfile**
---------------------------


[Atlassian Dotfiles Repo tutorial](https://www.atlassian.com/git/tutorials/dotfiles) 

- alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
- git clone --bare git@gitlab.com:PinkieBoi/dotfiles.git $HOME/.dotfiles
- mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{
- config checkout
- config config --local status.showUntrackedFiles no
