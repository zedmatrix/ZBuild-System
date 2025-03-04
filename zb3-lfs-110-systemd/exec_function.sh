EXEC() {
	chmod +x $1
	./$1
}
export -f EXEC
