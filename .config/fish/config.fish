if status is-interactive

	# Initialise zoxide
	zoxide init fish | source

	# Initialise oh my posh
	$HOME/.local/bin/oh-my-posh init fish --config $HOME/.config/omp/omp.toml | source

	# Start ssh
	# ssh-add $HOME/.ssh/github_rsa

end

# Set environment variables
set -gx EDITOR nvim
set -Ux WLR_RENDERER vulkan

# Add path
fish_add_path $HOME/.local/bin $HOME/repos/scripts
