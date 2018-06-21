Digital edition of Mozart piano sonatas
==========================================

This repository is a digital edition of 17 piano sonatas
composed by Wolfgang Amadeus Mozart, encoded in the
Humdrum file format.  The reference edition is the [Alte
Mozart-Ausgabe](https://en.wikipedia.org/wiki/Alte_Mozart-Ausgabe), volume
20 published in 1878 by Breitkopf &amp; H&auml;rtel, Leipzig, Germany.

Downloading
==================

The files can be downloaded by clicking on the green "Clone or download" 
button that should be near the top right corner of this page.  Then
choose "Download ZIP" in the drop-down menu that appears.

To download with `git`:

```bash
git clone https://github.com/craigsapp/mozart-piano-sonatas
```

To update your copy with any new changes to the data, type this command
within the mozart-piano-sonatas directory:

```bash
git pull
```


Online viewing
==================

Graphical notation for the data files can be viewed online at 
[Verovio Humdrum Viewer](http://verovio.humdrum.org/?file=mozart/sonatas&k=e).  Here are links to the individual movements:


| Number  | NMA | key | K<sup>1</sup>  | K<sup>6</sup>  | mvmt. 1  | mvmt. 2  | mvmt. 3 | 
|---|---|---|---|---|---|---|---|
| 1 | 1 | C major       | 279  | 189d  | Allegro                   | Andante                           | Allegro                      |
| 2 | 2 | F major       | 280  | 189e  | Allegro assai             | Adagio                            | Presto                       |
| 3 | 3 | B-flat major  | 281  | 189f  | Allegro                   | Andante amoroso                   | Rondo: Allegro               |
| 4 | 4 | E-flat major  | 282  | 189g  | Allegro                   | Menuett I &amp; II                | Allegro                      |
| 5 | 5 | G major       | 283  | 189h  | Allegro                   | Andante                           | Presto                       |
| 6 | 6 | D major       | 284  | 205b  | Allegro                   | Rondeau en polonaise: Andante     | Thema                        |
| 7 | 7 | C major       | 309  | 284b  | Allegro con spirito       | Andante un poco adagio            | Rondo: Allegretto grazioso   |
| 8 | 8 | A minor       | 310  | 300d  | Allegro maestoso          | Andante cantabile con expressione | Presto                       |
| 9 | 9 | D major       | 311  | 284c  | Allegro con spirito       | Andante con expressione           | Rondo: Allegro               |
|10 |10 | C major       | 330  | 300h  | Allegro moderato          | Andante cantabile                 | Allegretto                   |
|11 |11 | A major       | 331  | 300i  | Thema: Andante grazioso   | Menuetto &amp; Trio               | Alla Turca: Allegretto       |
|12 |12 | F major       | 332  | 300k  | Allegro                   | Adagio                            | (Allegro assai)              |
|13 |13 | B-flat major  | 333  | 315c  | Allegro                   | Andante cantabile                 | Allegretto grazioso          |
|14 |14 | C minor       | 457  |       | Allegro                   | Adagio                            | Molto allegro                |
|15 |16 | C major       | 545  |       | Allegro                   | Andante                           | Rondo: Allegretto            |
|16 |17 | B-flat major  | 570  |       | Allegro                   | Adagio                            | Allegretto                   |
|17 |18 | D major       | 576  |       | Allegro                   | Adagio                            | Allegretto                   |


`NMA` stands for [Neue Mozart-Ausgabe](https://en.wikipedia.org/wiki/Neue_Mozart-Ausgabe).


Analysis & Manipulation tools
=================================


Tools for
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



