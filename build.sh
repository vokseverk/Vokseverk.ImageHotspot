PACKAGE_NAME=ImageHotspot

# Get the current version
VERSION=`grep -o ' packageVersion \"\(.*\)\"' src/version.ent | awk '{print $2}' | sed 's/"//g'`

# Create the dist directory if needed
if [[ ! -d dist ]]
	then mkdir dist
fi
# Likewise, create the package dir
if [[ ! -d package ]]
	then mkdir package
fi

# Transform the package.xml file, pulling in the README
xsltproc --novalid --xinclude --output package/package.xml lib/packager.xslt src/package.xml

# Copy files into package
cp src/*.js package/
cp src/*.css package/
cp src/*.html package/
cp src/*.manifest package/

# Build the ZIP file
zip -j "dist/Vokseverk.$PACKAGE_NAME-$VERSION.zip" package/* -x \*.DS_Store
