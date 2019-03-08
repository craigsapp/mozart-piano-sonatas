## mozart-piano-sonatas Makefile
##
## Programmer:    Craig Stuart Sapp <craig@ccrma.stanford.edu>
## Creation Date: Tue Jun  3 16:52:17 PDT 2014
## Last Modified: Sat Jun 23 11:21:48 PDT 2018
## Filename:      Makefile
## Syntax:        GNU/BSD makefile
##
## Description:   Makefile for basic processing Humdrum data files 
##                for the piano sonatas of Wolfgang Amadeus Mozart.
##
## To run this makefile, type "make" (without quotes) to see a list 
## of the makefile actions which can be done.
##

# targets which don't actually refer to files:
.PHONY : ctonic ckeyscape keyscape lilypond mei midi midi-norep musedata musicxml notearray pdf-lilypond pdf-musedata

all:
	@echo ''
	@echo 'Run this makefile with one of the following labels:'
	@echo '   "[0;32mmake update[0m"      : download any new changes from online repository.'
	@echo '   "[0;32mmake reference[0m"   : download PDF scans of reference editions.'
	@echo '   "[0;32mmake clean[0m"       : delete data directories created by this makefile.'
	@echo ''
	@echo 'Commands requiring the Humdrum Toolkit to be installed:'
	@echo '   "[0;32mmake census[0m"      : run the census command on all files.'
	@echo ''
	@echo 'Commands requiring Humdrum Extras to be installed.'
	@echo '   "[0;32mmake ctonic[0m"      : transpose scores to C major/minor.'
	@echo '   "[0;32mmake keyscape[0m"    : generate keyscape plots by movement.'
	@echo '   "[0;32mmake ckeyscape[0m"   : generate keyscape plots by movement in C major/minor.'
	@echo '   "[0;32mmake mei[0m"         : convert to MEI files.'
	@echo '   "[0;32mmake midi[0m"        : convert to MIDI files (full repeats).'
	@echo '   "[0;32mmake midi-norep[0m"  : convert to MIDI files (no repeats).'
	@echo '   "[0;32mmake musedata[0m"    : convert to MuseData files.'
	@echo '   "[0;32mmake musicxml[0m"    : convert to MusicXML files.'
	@echo '   "[0;32mmake notearray[0m"   : create notearray files.'
	@echo '   "[0;32mmake searchindex[0m" : create themax search index.'
	@echo ''
	@echo 'Commands requiring other software to be installed.'
	@echo '   "[0;32mmake pdf-lilypond[0m": convert to PDF files with lilypond.'
	@echo '   "[0;32mmake pdf-musedata[0m": convert to PDF files with muse2ps.'
	@echo ''


############################################################################
##
## General make commands:
##

##############################
#
# make update -- Download any changes in the Github repositories for
#      each composer.  To download for the first time, type:
#           git clone https://github.com/craigsapp/mozart-piano-sonatas
#

update:       github-pull
pull:         github-pull
github:       github-pull
githubupdate: github-pull
githubpull:   github-pull
github-pull: git-check git-repository-check
	git pull



##############################
#
# make clean -- Remove all automatically generated or downloaded data files.  
#     Make sure that you have not added your own content into the directories 
#     in which these derivative files are located; otherwise, these will be 
#     deleted as well.
#

clean:
	-rm -rf kernscores
	-rm -rf keyscape
	-rm -rf ckeyscape
	-rm -rf ctonic
	-rm -rf lilypond
	-rm -rf mei
	-rm -rf midi
	-rm -rf midi-norep
	-rm -rf musedata
	-rm -rf musicxml
	-rm -rf notearray
	-rm -rf pdf-lilypond
	-rm -rf pdf-musedata
	-rm searchindex.dat



############################################################################
##
## Humdrum Extras related make commands:
##

##############################
#
# make midi -- Create midi files for music, expanding repeats.
#

midi: humdrum-extras-check
	mkdir -p midi
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;                                \
	   echo Creating midi/$$TBASE.mid;				\
	   thrux $$file | hum2mid -o midi/$$TBASE.mid;			\
	done
	@echo "[0;32m"
	@echo "*** Created midi data in '[0;31mmidi[0;32m' directory."
	@echo "[0m"



##############################
#
# make midi-norep -- Create midi files for music, taking only second
#     endings (performance sequence with minimal repeats).
#

norep:      midi-norep
midinorep:  midi-norep
midi-norep: humdrum-extras-check
	mkdir -p midi-norep
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;                                \
	   echo Creating midi/$$TBASE.mid;				\
	   thrux -v norep $$file | hum2mid -o midi-norep/$$TBASE.mid;	\
	done
	@echo "[0;32m"
	@echo "*** Created midi data in '[0;31mmidi-norep[0;32m' directory."
	@echo "[0m"



##############################
#
# make notearray -- Create notearray files (useful for processing data
# in matlab).  Output is stored in a directory called "notearray".
#

notearray: humdrum-extras-check
	mkdir -p notearray
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;                                \
	   echo Creating notearray/$$TBASE.dat;				\
	   notearray -jicale --mel $$file 				\
		> notearray/$$TBASE.dat;				\
	done
	@echo "[0;32m"
	@echo "*** Created notearray data in '[0;31mnotearray[0;32m' directory."
	@echo "[0m"



##############################
#
# make keyscape -- Create keyscape plots of each movement/variation.
# Output is stored in a directory called "keyscape".
#

keyscape: humdrum-extras-check convert-check
	mkdir -p keyscape
	for file in kern/*.krn;                          \
	do                                               \
	   TBASE=`basename $$file .krn`;                 \
	   echo Creating keyscape/$$TBASE.png;           \
	   thrux -v norep $$file | mkeyscape -n --trim  \
	   | convert - keyscape/$$TBASE.png;             \
	done
	@echo "[0;32m"
	@echo "*** Created keyscape images in '[0;31mkeyscape[0;32m' directory."
	@echo "[0m"



##############################
#
# make ckeyscape -- Create keyscape plots of each movement/variation with
# the music transposed to C major first (green = tonic, blue = dominant, etc.).
# Output is stored in a directory called "ckeyscape".
#

ckeyscape: humdrum-extras-check convert-check
	mkdir -p ckeyscape
	for file in kern/*.krn;                                        \
	do                                                             \
	   TBASE=`basename $$file .krn`;                               \
	   echo Creating ckeyscape/$$TBASE.png;                        \
	   transpose -kc $$file | thrux -v norep | mkeyscape -n --trim  \
	   | convert - ckeyscape/$$TBASE.png;                          \
	done
	@echo "[0;32m"
	@echo "*** Created keyscape images in '[0;31mckeyscape[0;32m' directory."
	@echo "[0m"



##############################
#
# make ctonic -- Transpose all music into C major (primary key of each movement).
# Output is stored in a directory called "ctonic".
#

ctonic: humdrum-extras-check
	mkdir -p ctonic
	for file in kern/*.krn;                              \
	do                                                   \
	   TBASE=`basename $$file .krn`;                     \
	   echo Creating ctonic/$$TBASE.png;                 \
	   transpose -kc $$file > ctonic/$$TBASE-ctonic.krn; \
	done
	@echo "[0;32m"
	@echo "*** Created C-major scores in '[0;31mctonic[0;32m' directory."
	@echo "[0m"



##############################
#
# make musedata -- Create musedata files (useful for printing with muse2ps).
# Output is stored in a directory called "musedata".
#

musedata: humextra-check
	mkdir -p musedata
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;				\
	   echo Creating musedata/$$TBASE.msd;				\
	   autostem $$file | hum2muse   				\
		> musedata/`basename $$file .krn`.msd;			\
	done
	@echo "[0;32m"
	@echo "*** Created musedata data in '[0;31mmusedata[0;32m' directory."
	@echo "[0m"



##############################
#
# make pdf-musedata -- Create PDF files of graphical notation using muse2ps:
#     http://muse2ps.ccarh.org
#     https://github.com/musedata/muse2ps
# Output is stored in a directory called "pdf-musedata".
#
# To print with this method, you need to install muse2ps from the above
# website, as well as the GhostScript package.  In linux, the ps2pdf
# program can be installed with "yum install ghostscript", or 
# "apt-get install ghostscript".  In OS X if you have installed homebrew:
# "brew install ghostscript", or "port install ghostscript" if you are
# using MacPorts.
#

pdf-musedata: ps2pdf-check muse2ps-check humdrum-extras-check
	mkdir -p pdf-musedata
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;			        \
	   echo Creating pdf-musedata/$$TBASE.pdf;			\
	   autostem $$file | hum2muse | muse2ps =z16j 			\
	      | ps2pdf -sPAPERSIZE=letter - 				\
		> pdf-musedata/$$TBASE.pdf;				\
	done
	@echo "[0;32m"
	@echo "*** Created PDF files in '[0;31mpdf-musedata[0;32m' directory."
	@echo "[0m"



##############################
#
# make mei -- Create MEI files (useful for printing with verovio).
# Output is stored in a directory called "mei".
#

MEI: mei
mei: humdrum-extras-check
	mkdir -p mei
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;                                \
	   echo Creating mei/$$TBASE.mei;				\
	   autostem $$file | hum2mei > mei/$$TBASE.mei;			\
	done
	@echo "[0;32m"
	@echo "*** Created MEI data in '[0;31mmei[0;32m' directory."
	@echo "[0m"



##############################
#
# make musicxml -- Create MusicXML files, which are useful for processing with
# various programs/systems.  Output is stored in a directory called "musicxml".
#

musicxml: humdrum-extras-check
	mkdir -p musicxml
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;				\
	   echo Creating musicxml/$$TBASE.xml;				\
	   autostem $$file | hum2xml > musicxml/$$TBASE.xml;		\
	done
	@echo "[0;32m"
	@echo "*** Created MusicXML data in '[0;31mmusicxml[0;32m' directory."
	@echo "[0m"



##############################
#
# make lilypond -- Create lilypond files.
# Output is stored in a directory called "lilypond".
#

lilypond: humdrum-extras-check
	mkdir -p lilypond
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;				\
	   echo Creating lilypond/$$TBASE.ly;				\
	   autostem $$file | hum2xml | musicxml2ly - -o-   		\
	       > lilypond/$$TBASE.ly;					\
	done
	@echo "[0;32m"
	@echo "*** Created lilypond data in '[0;31mlilypond[0;32m' directory."
	@echo "[0m"



##############################
#
# make pdf-lilypond -- Create lilypond files.
# Output is stored in a directory called "lilypond".
#

pdf-lilypond: humdrum-extras-check lilypond-check
	mkdir -p pdf-lilypond
	for file in kern/*.krn;						\
	do								\
	   TBASE=`basename $$file .krn`;				\
	   echo Creating pdf-lilypond/%%TBASE.pdf;			\
	   autostem $$file | hum2xml | musicxml2ly - -o-   		\
	   | lilypond -f pdf -o pdf-lilypond/$$TBASE - ;		\
	done
	@echo "[0;32m"
	@echo "*** Created PDF data in '[0;31mpdf-lilypond[0;32m' directory."
	@echo "[0m"



##############################
#
# make searchindex -- Create a themax search index file.  The searchindex.dat
# file can be used with the themax program to search for melodic/rhythmic 
# patterns in the data, such as searching for two successive rising 
# perfect fourths:
#
# Counting the number of occurrences within the data (all voices):
#    themax -I "+P4 +P4" searchindex.dat --total
#
# Count the number of matches by each voice separately:
#    grep ::1 searchindex.dat | themax -I "+P4 +P4" --count
#       (finds 53 matches in the bass part)
#    grep ::2 searchindex.dat | themax -I "+P4 +P4" --count
#       (finds 9 matches in the tenor part)
#    grep ::3 searchindex.dat | themax -I "+P4 +P4" --count
#       (finds 0 matches in the alto part)
#    grep ::4 searchindex.dat | themax -I "+P4 +P4" --count
#       (finds 2 matches in the soprano part)
#
# Counting the number of matches in a file:
#    themax -I "+P4 +P4" searchindex.dat --count
#
# Showing the note-number location of the matches:
#    themax -I "+P4 +P4" searchindex.dat --loc
#
# Resolve note-number locations to measure/beat locations:
#    themax -I "+P4 +P4" searchindex.dat --loc | theloc
#
# Extract measures which contain the matches in a particular work:
#    tindex kern/sonata01-1.krn | themax -I "+P4 +P4" --loc | theloc --mark | myank --marks
#
#

search:	     	searchindex
search-index:	searchindex
searchindex: humdrum-extras-check
	tindex kern/*.krn > searchindex.dat
	@echo "[0;32m"
	@echo "*** Try the command:"
	@echo "***    [0;31mthemax -P \"e- d f e- d c\" searchindex.dat --loc | theloc[0;32m"
	@echo "*** To search for a melodic fragment from the start of sonata no. 4."
	@echo "*** The result should be:"
	@echo "***     [0;31mkern/sonata04-1.krn::1	41=14B7-46=15B5.5[0;32m"
	@echo "***     [0;31mkern/sonata04-1.krn::2	12=6B1-17=6B8.5 866=194B1-871=194B8.5[0;32m"
	@echo "***     [0;31mkern/sonata04-3.krn::2	65=20B3.5-70=21B3[0;32m"
	@echo "***     [0;31mkern/sonata05-3.krn::2	19=3B2-24=3B4.5 423=60B2-428=60B4.5[0;32m"
	@echo "***     [0;31mkern/sonata08-1.krn::2	87=9B1.625-92=9B1.9375[0;32m"
	@echo "***     [0;31mkern/sonata08-3.krn::2	172=35B2.66667-177=36B1.5 313=57B2.66667-318=58B2.83333[0;32m"
	@echo "***     [0;31mkern/sonata11-2.krn::1	326=43B7.75-331=43B11.5[0;32m"
	@echo "***     [0;31mkern/sonata11-2.krn::2	173=44B8.5-178=44B12.25[0;32m"
	@echo "***     [0;31mkern/sonata19-1.krn::2	110=25B2.25-115=26B1.5 223=45B2.25-228=46B2.75 420=88B2.75-425=89B2.5[0;32m"
	@echo "***     [0;31mkern/sonata31-3.krn::2	371=154B5.5-376=155B2.5[0;32m"
	@echo "***"
	@echo "*** The string [0;32m41=14B7-46=15B5.5[0;32m in the first match line means that"
	@echo "*** the match starts at note 32 of the part at measure 17, beat 7"
	@echo "*** and goes to note 46 in measure 15, beat 5.5 (should make compound meter beats)."
	@echo "[0m"
	



############################################################################
##
## standard Humdrum Toolkit related make commands:
##

##############################
#
# make census -- Count notes in all score for all composers.
#

census: humdrum-toolkit-check
	extractx -i kern kern/*krn | census -k 



############################################################################
##
## Check to see if various software packages are installed.
##

##############################
##
## make git-check -- Check to see if the git program is available.
##    If not, then make suggestions for how to install.
##

git-check:
ifeq ($(shell which git),)
	@echo "[0;31m"
	@echo "*** Error: You must first install the git program."
	@echo "*** In Linux, try:"
	@echo "***    [0;32sudo yum install git0;31m"
	@echo "*** or"
	@echo "***    [0;32sudo apt-get install git0;31m"
	@echo "*** In OS X, install Homebrew ([0;31mhttps://brew.sh[0;31m) and then type:"
	@echo "***    [0;32brew install git0;31m"
	@echo "[0m"
	exit 1
endif



##############################
##
## make git-repository-check -- Check to see if the directory is part of
##    a git repository.
##

git-repository-check:
ifeq ($(wildcard .git),)
	@echo "[0;31m"
	@echo "*** Error: To automatically update, you need to have installed"
	@echo "*** this directory with the git command:"
	@echo "***    [0;32mgit clone https://github.com/craigsapp/mozart-piano-sonatas[0;31m"
	@echo "[0m"
	exit 1
endif



##############################
##
## make ps2pdf-check -- Check to see if the ps2pdf program, which is a script
##    in the GhostScript software package, is available.  If not, then make
##    suggestions for how to install.
##

ps2pdf-check:
ifeq ($(shell which ps2pdf),)
	@echo "[0;31m"
	@echo "*** Error: You must first install ps2pdf from the GhostScript package".
	@echo "*** In Linux, try:"
	@echo "***    [0;32sudo yum install ghostscript0;31m"
	@echo "*** or"
	@echo "***    [0;32sudo apt-get install ghostscript0;31m"
	@echo "*** In OS X, install Homebrew ([0;31mhttps://brew.sh[0;31m) and then type:"
	@echo "***    [0;32brew install ghostscript0;31m"
	@echo "[0m"
	exit 1
endif



##############################
##
## make abcm2ps-check -- Check to see if the abcm2ps program is available.
##    If not, then make suggestions for how to install.
##

abcm2ps-check:
ifeq ($(shell which abcm2ps),)
	@echo "[0;31m"
	@echo "*** Error: You must first install abcm2ps from:"
	@echo "***    [0;32mhttp://moinejf.free.fr[0;31m"
	@echo "[0m"
	exit 1
endif



##############################
##
## make muse2ps-check -- Check to see if the muse2ps program is available.
##    If not, then make suggestions for how to install.
##

muse2ps-check:
ifeq ($(shell which muse2ps),)
	@echo "[0;31m"
	@echo "*** Error: You must first install muse2ps from:"
	@echo "***    [0;32mhttp://muse2ps.ccarh.org[0;31m"
	@echo "[0m"
	exit 1
endif



##############################
##
## make lilypond-check -- Check to see if the lilypond program is available.
##    If not, then make suggestions for how to install.
##

lilypond-check:
ifeq ($(shell which lilypond),)
	@echo "[0;31m"
	@echo "*** Error: You must first install lilypond."
	@echo "*** In Linux, try:"
	@echo "***    [0;32sudo yum install lilypond0;31m"
	@echo "*** or"
	@echo "***    [0;32sudo apt-get install lilypond0;31m"
	@echo "*** In OS X, install Homebrew ([0;31mhttps://brew.sh[0;31m) and then type:"
	@echo "***    [0;32brew install lilypond0;31m"
	@echo "[0m"
	exit 1
endif



##############################
##
## make humdrum-toolkit-check -- Check to see if the Humdrum Toolkit package
##    is available.  If not, then make suggestions for how to install.
##

humdrum-toolkit-check:
ifeq ($(shell which humdrum),)
	@echo "[0;31m"
	@echo "*** Error: You must first install the Humdrum Toolkit. See:"
	@echo "***    [0;32mhttps://github.com/humdrum-tools/humdrum-tools[0;31m"
	@echo "[0m"
	exit 1
endif



##############################
##
## make humdrum-extras-check -- Check to see if the Humdrum Extras package
##    is available.  If not, then make suggestions for how to install.
##

humextra-check:      humdrum-extras-check
humdrumextra-check:  humdrum-extras-check
humdrum-extra-check: humdrum-extras-check
humdrum-extras-check:
ifeq ($(shell which keycor),)
	@echo "[0;31m"
	@echo "*** Error: You must first install the Humdrum Extras. See:"
	@echo "***    [0;32mhttps://github.com/humdrum-tools/humdrum-tools[0;31m"
	@echo "[0m"
	exit 1
endif


##############################
##
## make convert-check -- Check to see if the convert command is available.
##    If not, then make suggestions for how to install.
##

convert-check:
ifeq ($(shell which convert),)
	@echo "[0;31m"
	@echo "*** Error: You must first install ImageMagick tools. See:"
	@echo "***    [0;32mhttp://www.besavvy.com/documentation/4-5/Editor/031350_installimgk.htm[0;31m"
	@echo "[0m"
	exit 1
endif

###########################################################################
##
## non-general targets.
##

import:
	cp ../*.krn kern




