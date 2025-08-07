function batman -d "Calls man throuhg bat"
	man $argv | col -bx | bat -l man -p
end
