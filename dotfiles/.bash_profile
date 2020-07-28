# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

export PATH_TO_PEM_KEY="/path/to/key.pem";
export SSH_LOGIN="username";

# =============================================================================
# FUNCTIONS
# =============================================================================

mcd() {
	mkdir -p -- "$1" && cd -P -- "$1";
}

__ssh() {
	ssh -i $PATH_TO_PEM_KEY -l $SSH_LOGIN $@;
}

@ssh_via_bastion() {
	ssh -i $PATH_TO_PEM_KEY "$1"@"$2" -o "proxycommand ssh -W %h:%p -i $PATH_TO_PEM_KEY ec2-user@bastion.xyz";
}
