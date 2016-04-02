# scripts
A collection of useful scripts that I have written.

---

## `latexc`

### Description

This script is a wrapper around standard the `LaTeX` compilers under a convenient user-interface. The interface is modeled after similar interfaces found for wrappers like `ocamlc` and `javac` for OCaml and Java, respectively. There are TWO files provided above:
 + `latexc`: This is the actual executable file that needs to be installed on your computer. To install it, follow the installation directions below.
 + `latexc.sh`: This is the source code that can be examined if you would like to discover potential sources of bugs and report what could be wrong (by line number). All suggestions are welcome! Do **not** use this file when following the installation directions below.

A significant advantage of `latexc` over the standard `pdflatex` and similar compilers is that `latexc` automatically cleans up useless files unless specified otherwise. Also, specifying the output directory for target PDF files happens with much cleaner syntax.

### Usage

You can invoke `latexc` by following these standard commands (with options):

```
Usage: latexc <options> <source files>
where possible options include:
  -help                      Print a synopsis of standard options
  -version                   Version information
  -pdf                       Compile the LaTeX source files using PDFLaTeX
  -xe                        Compile the LaTeX source files using XeLaTeX
  -lua                       Compile the LaTeX source files using LuaLaTeX
  -v                         Verbose: Output all warnings/errors from compiler
  -c                         Don't clean up the directory after compiling
  -d <directory>             Specify where to place generated PDF files
```

Note that you must have `PDFLaTeX`, `XeLaTeX`, and/or `LuaLaTeX` actually installed on your local machine to be able to use `latexc`. This is **purely** a wrapper on those commands; it is not a standalone compiler!

### Installation

In the future, a Makefile will be available that automatically does the following steps. For now, please follow them carefully.

To install `latexc` as a command on your UNIX machine, clone the `latexc` executable file onto your local machine and move it into your scripts binary directory through the command below, assuming that `latexc` is in your current directory:

```
$ mv latexc /usr/bin
```

Then, you can copy this directory into your `$PATH` environment variable if it is not already set globally by opening the `.bash_profile` hidden file in your home directory as follows:

```
$ vim ~/.bash_profile
```

Then, at the bottom of the file (assuming you know how to use Vim), adding the following line should add `latexc` to the `$PATH`:

```
$ export PATH=$PATH:/usr/bin/
```

Then, once you've left the file, you can either quit your Terminal and restart it OR run the following command to "reset" everything:

```
$ source ~/.bash_profile
```

From here, you should be able to call `latexc` as you could `javac` or `ocamlc` from any context/directory.

---

Other scripts to come.

Copyright © 2015-2016 Chirag Bharadwaj, Cornell University.

There is NO warranty. This software may be freely redistributed with attribution to the original author in all cases. This software may also be modified from its original version and redistributed as long as all changes made are stated very clearly in the redistributed version and attribution to the original author is provided. You may not use ANY part of this software for commercial purposes. All rights reserved. Please report any bugs to Chirag at cb625@cornell.edu.
