#! /bin/bash
clear
echo "    .___.       __.           ,"
echo "      |   _ \./(__  _.._.*._ -+-"
echo "      |  (/,/'\.__)(_.[  |[_) | "
echo "                          |  "
echo ""
echo ""

rootFile=$1

latex -interaction=nonstopmode $rootFile > build.log

tmpErr=$?

if [ $tmpErr == 0 ]; then
  echo "--> DVI build successfull"
  echo "--> Now Starting PDF build..."
  echo ""
else
  echo "--> latex failed with errorcode $tmpErr"  
  echo "--> Aborting Script!"
  exit $tmpErr
fi

if [[ "$rootFile" == *"."* ]]; then
  urlFile=`echo $rootFile | cut -d '.' -f 1`
else
  echo "--> Everythings gonna be allright..."
  echo ""
fi  

dvipdfm $urlFile &>> build.log

tmpErr=$?

if [ $tmpErr == 0 ]; then
  echo "--> PDF build successfull"
  echo "--> Building Bibtex..."
  echo ""
else
  echo "--> dvipdfm failed with errorcode $tmpErr"  
  echo "--> Aborting Script!"
  exit $tmpErr
fi

bibtex "$urlFile.aux" &>> build.log

tmpErr=$?

if [ $tmpErr == 0 ]; then
  echo "--> BibTex build successfull"
  echo "--> Now Generating second Latex output..."
  echo ""
else
  echo "--> BibTex failed with errorcode $tmpErr"  
  echo "--> Aborting Script!"
  exit $tmpErr
fi

latex -interaction=nonstopmode $rootFile > build.log

tmpErr=$?

if [ $tmpErr == 0 ]; then
  echo "--> DVI build successfull"
  echo "--> Now Starting PDF build..."
  echo ""
else
  echo "--> Latex failed with errorcode $tmpErr"  
  echo "--> Aborting Script!"
  exit $tmpErr
fi

dvipdfm $urlFile &>> build.log

tmpErr=$?

if [ $tmpErr == 0 ]; then
  echo "--> PDF build successfull"
  echo "--> All builds successfull"
  echo ""
else
  echo "Dvipdfm failed with errorcode $tmpErr"  
  echo "Aborting Script!"
  exit $tmpErr
fi

mv "$urlFile.pdf" Gsoc2014_grtrellis_proposal.pdf
tmpErr=$?
if [ $tmpErr != 0 ]; then
  echo "Error: could not rename proposal.pdf!"
fi

echo "Exiting Script"

