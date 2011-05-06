colores ()
{
	normal="\\033[0;39m";
	for j in 0 1;
	do
		for i in $(seq 30 36) $(seq 43 47);
		do
			color="\\033[${j};${i}m";
			echo -ne "${color}\\\\\\${color}";
			echo -e "$normal";
		done;
	done;
	echo -ne "\n${normal}\\\\\\${normal} NORMAL\n"
}

colores

