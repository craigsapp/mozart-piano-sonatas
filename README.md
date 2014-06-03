Digital edition of Mozart piano sonatas
==========================================

This repository is a digital edition of the 32 piano sonatas composed
by Wolfgang Amadeus Mozart, encoded in the Humdrum file format.  Tools for
processing the encodings in this format on the command-line can be found
online at https://github.com/humdrum-tools

The encodings are located in the 'kern' directory.
Scans of the source edition can be downloaded from 
[kernScores](http://kern.humdrum.org) with this command:
```bash
   make reference
```

Data processing tools and other resources
=========================================

These digital scores may also be found on the kernScores website:
*    http://kernscores.stanford.edu/browse?l=mozart/sonatas

with mirrors at:
*    http://kern.humdrum.org/browse?l=mozart/sonatas
*    http://kern.ccarh.org/browse?l=mozart/sonatas

which includes dynamic conversions to other data formats.  

The [Humdrum Extras](http://extras.humdrum.org) command-line programs 
can download these files from kernScores.  A quick method of downloading:
```bash
    mkdir -p mozart/piano-sonatas
    cd mozart/piano-sonatas
    humsplit h://mozart/sonatas
```
To get online access to a single movement, for example to transpose the first 
movement of the first sonata from to B major:
```bash
   transpose -k b h://mozart/sonatas/sonata01-1.krn
```

To interface to the Humdrum Toolkit commands, use the humcat command to download to standard input (the -s option is needed when downloading multiple files):
```bash
   humcat -s h://mozart/sonatas | census -k
```


Makefile
========

The makefile provided in the base directory includes example data
processing commands.  Type ```make``` when in the same directory as the
makefile to list commands that can be run with the makefile.

If the command ```which make``` reports that the make command cannot
be found, then you must install it.  In linux, this command might
install it:
```bash
   sudo apt-get install build-essential
   # or
   sudo yum install build-essential
```

In OS X Mavericks or later, install the Xcode command-line tools:
```bash
   xcode-select --install
```

In Cygwin on MS Windows, re-run the cygwin install program and make sure
that the development tools are included in the installation packages.



