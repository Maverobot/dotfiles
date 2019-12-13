cd() {
	if [ $# -eq 0 ]; then
		pushd "$HOME" >/dev/null
	else
		pushd "$@" >/dev/null
	fi
}
