#!/bin/bash

print_options () {
	echo -e \
"Usage: latexc <options> <source files>
where possible options include:
  -help                      Print a synopsis of standard options
  -version                   Version information
  -pdf                       Compile the LaTeX source files using PDFLaTeX
  -xe                        Compile the LaTeX source files using XeLaTeX
  -lua                       Compile the LaTeX source files using LuaLaTeX
  -v                         Verbose: Output all warnings/errors from compiler
  -c                         Don't clean up the directory after compiling
  -d <directory>             Specify where to place generated PDF files"

	exit 0
}

version="latexc, version 0.8.1 (alpha release)

Copyright © 2015-2016 Chirag Bharadwaj, Cornell University.

There is NO warranty. This software may be freely redistributed with attribution
to the original author in all cases. This software may also be modified from its
original version and redistributed as long as all changes made are stated very
clearly in the redistributed version and attribution to the original author is
provided. You may not use ANY part of this software for commercial purposes. All
rights reserved. Please report any bugs to Chirag at cb625@cornell.edu.

Written in bash."

pdf=0
xe=0
lua=0
verbose=0
clean=1
args=""
dir=""
output=""
error=0

while true; do
	case "$1" in
		"")
			break
			;;
		-help)
			print_options
			break
			;;
		-version)
			echo -e "$version"
			exit 0
			;;
		-pdf)
			if [[ "$pdf" -eq 1 ]]; then
				echo "Warning: You are already compiling with PDFLaTeX."
				shift
			elif [[ "$xe" -eq 1 ]]; then
				echo "Error: Only one method of compilation can be specified. You have already chosen XeLaTeX, so you cannot use PDFLaTeX."
				error=1
				break
			elif [[ "$lua" -eq 1 ]]; then
				echo "Error: Only one method of compilation can be specified. You have already chosen LuaLaTeX, so you cannot use PDFLaTeX."
				error=1
				break
			else
				pdf=1
			fi
			shift
			;;
		-xe)
			if [[ "$pdf" -eq 1 ]]; then
				echo "Error: Only one method of compilation can be specified. You have already chosen PDFLaTeX, so you cannot use XeLaTeX."
				error=1
				break
			elif [[ "$xe" -eq 1 ]]; then
				echo "Warning: You are already compiling with XeLaTeX."
				shift
			elif [[ "$lua" -eq 1 ]]; then
				echo "Error: Only one method of compilation can be specified. You have already chosen LuaLaTeX, so you cannot use XeLaTeX."
				error=1
				break
			else
				xe=1
			fi
			shift
			;;
		-lua)
			if [[ "$pdf" -eq 1 ]]; then
				echo "Error: Only one method of compilation can be specified. You have already chosen PDFLaTeX, so you cannot use LuaLaTeX."
				error=1
				break
			elif [[ "$xe" -eq 1 ]]; then
				echo "Error: Only one method of compilation can be specified. You have already chosen XeLaTeX, so you cannot use LuaLaTeX."
				error=1
				break
			elif [[ "$lua" -eq 1 ]]; then
				echo "Warning: You are already compiling with LuaLaTeX."
				shift
			else
				lua=1
			fi
			shift
			;;
		-v)
			verbose=1
			shift
			;;
		-c)
			clean=0
			shift
			;;
		-d)
			shift
			if [[ -d "$1" ]]; then
				dir="$1"
				shift
			else
				echo "Error: The -d option must be followed by a directory to which to move files."
				echo "  • $1 is not a valid directory"
				error=1
				break
			fi
			shift
			;;
		*)
			if [[ "$1" == *.tex ]]; then
				args="$args $1"
				name=$(basename "$1" .tex)
				out=$name.pdf
				output="$output $out"
				shift
			else
				echo "Error: Source files must be TeX files that end with .tex."
				echo "  • $1 is not a TeX source file"
				error=1
				shift
			fi
			;;
	esac
done

if [[ "$error" -eq 1 ]]; then
	print_options
	exit 1
else
	args=$(echo "$args" | xargs)
	set -- $args
	output=$(echo "$output" | xargs)
	if [[ -z "$args" ]]; then
		echo "Error: No source files were specified."
		print_options
		exit 1
	elif [[ "$pdf" -eq 1 ]]; then
		echo "Compiling using PDFLaTeX... Press [CTRL+D] if it hangs (~30 seconds)."
		if [[ "$verbose" -eq 1 ]]; then
			for i in "$@"
			do
				pdflatex $i
			done
		else
			for i in "$@"
			do
				pdflatex $i > /dev/null
			done
		fi
	elif [[ "$xe" -eq 1 ]]; then
		"Compiling using XeLaTeX... Press [CTRL+D] if it hangs (~30 seconds)."
		if [[ "$verbose" -eq 1 ]]; then
			for i in "$@"
			do
				xelatex $i
			done
		else
			for i in "$@"
			do
				xelatex $i > /dev/null
			done
		fi
	elif [[ "$lua" -eq 1 ]]; then
		"Compiling using LuaLaTeX... Press [CTRL+D] if it hangs (~30 seconds)."
		if [[ "$verbose" -eq 1 ]]; then
			for i in "$@"
			do
				lualatex $i
			done
		else
			for i in "$@"
			do
				lualatex $i > /dev/null
			done
		fi
	else
		echo "Warning: No compiler was specified. Assuming the default of PDFLaTeX..."
		echo "Press [CTRL+D] if it hangs (~30 seconds)."
		if [[ "$verbose" -eq 1 ]]; then
			for i in "$@"
			do
				pdflatex $i
			done
		else
			for i in "$@"
			do
				pdflatex $i > /dev/null
			done
		fi
	fi

	if [[ "$clean" -eq 1 ]]; then
		rm *.aux *.log
	fi

	if ! [[ -z "$dir" || -z "$output" ]]; then
		mv "$output" "$dir"
	fi
	exit 0
fi
