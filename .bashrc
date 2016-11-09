alias emacs="emacs -nw"
alias ls='ls -FhG'
alias less='less -M'
alias cemacs="/Applications/Emacs.app/Contents/MacOS/Emacs"

alias leading_gpu1="ssh tawara@133.9.8.197"
alias leading_gpu2="ssh tawara@133.9.8.198"
function scpleading_gpu2 {
  rsync  -auvzP  tawara@133.9.8.198:$1 $2
};

alias leading_dell1="ssh tawara@133.9.8.193"
alias leading_dell2="ssh tawara@133.9.8.194"
alias leading_dell3="ssh tawara@133.9.8.195"
alias leading="ssh tawara@133.9.66.135"

alias image="ssh -p 55821  133.9.14.115"
function scpkoba {
  rsync -e "ssh -p 55821" -auvzP  ssh.pcl.cs.waseda.ac.jp:$1 $2
};
function scpkoba_in {
 rsync -e "ssh -p 55821" -auvzP  --include='*/' --include='$3' --exclude='*' ssh.pcl.cs.waseda.ac.jp:$1 $2
}
function scpkobaup {
  rsync -e "ssh -p 55821" -auvzP  $1 ssh.pcl.cs.waseda.ac.jp:$2 
};

alias svnadd="svn status | grep ^? | awk '{print $2}' | xargs svn add"
alias koba="ssh tawara@ssh.pcl.cs.waseda.ac.jp -p 55821"

alias matlab=" /Applications/MATLAB_R2013a_Student.app/bin/matlab -nodesktop -nojvm -nosplash"
export svnserv=http://svn-gw.pcl.cs.waseda.ac.jp/svn/tawara/
alias kobo_private="ssh -N  -D 1080 133.9.66.202"

#COWS=( `cowsay -l | grep -v ^Cow | cut -f1-` )
#fortune | cowsay -f ${COWS[$((RANDOM%${#COWS[@]}))]} $@
#fortune | cowsay -f ghostbusters
#fortune | ~/.pokemonsay/pokemonsay.sh >&2
fortune | ~/.pokemonsay/pokemonsay.sh -n --think  >&2
printf '     /  \n    / \n' >&2; echo ' __________________________________________'>&2;printf "/ Welcome to ">&2;printf `hostname`>&2;printf "!  \\ \n">&2; echo '\__________________________________________/' >&2

PERL_MB_OPT="--install_base \"/Users/tawara/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/tawara/perl5"; export PERL_MM_OPT;

export PATH=/usr/local/bin:/usr/bin/usr/sbin:/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/texbin:$PATH

alias gouda="ssh tawara@gouda.uchicago.edu"
alias slurm="ssh tawara@slurm.ttic.edu"

function scpslurm {
  rsync  -auvzP  tawara@slurm.ttic.edu:$1 $2
};
function scpslurmup {
  rsync  -auvzP  $1 tawara@slurm.ttic.edu:$2 
};

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias fuck='eval $(thefuck $(fc -ln -1))'
alias FUCK='fuck'

alias s="source ~/.bashrc"

function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
	! is_exists 'tmux' && return 1

	if is_tmux_runnning; then
	    echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
	    echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
	    echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
	    echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
	    echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
	elif is_screen_running; then
	    echo "This is on screen."
	fi
    else
	if shell_has_started_interactively && ! is_ssh_running; then
	    if ! is_exists 'tmux'; then
		echo 'Error: tmux command not found' 2>&1
		return 1
	    fi

	    if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
		# detached session exists
		tmux list-sessions
		echo -n "Tmux: attach? (y/N/num) "
		read
		if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
		    tmux attach-session
		    if [ $? -eq 0 ]; then
			echo "$(tmux -V) attached session"
			return 0
		    fi
		elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
		    tmux attach -t "$REPLY"
		    if [ $? -eq 0 ]; then
			echo "$(tmux -V) attached session"
			return 0
		    fi
		fi
	    fi

	    if is_osx && is_exists 'reattach-to-user-namespace'; then
		# on OS X force tmux's default command
		# to spawn a shell in the user's namespace
		tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
		tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
	    else
		tmux new-session && echo "tmux created new session"
	    fi
	fi
    fi
}
tmux_automatically_attach_session
