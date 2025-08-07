if status is-interactive
	# Initialise zoxide
	zoxide init fish | source
	# Initialise oh my posh
	$HOME/.local/bin/oh-my-posh init fish --config $HOME/.config/omp/omp.toml | source
	# Start ssh
	# ssh-add ~/.ssh/github_rsa
end
