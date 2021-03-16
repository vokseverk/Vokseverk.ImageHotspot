VERSION=`grep -o ' packageVersion \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`
NAMESPACE=`grep -o ' orgNamespace \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`
PACKAGE=`grep -o ' propertyEditorAlias \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`
PKG_NAME="${NAMESPACE}.${PACKAGE}"

# Create the dist directory if needed
if [[ ! -d dist ]]
	then mkdir -p dist/package
else
	rm dist/package/*.*
fi

# Copy files
cp src/*.css dist/package/
cp src/*.js dist/package/
cp src/*.html dist/package/
cp src/lang/*.xml dist/package/

# Copy the Value Converters to the dist/ folder
cp src/*.cs dist/

# Transform the package.xml file
xsltproc --novalid --xinclude --output dist/package/package.xml lib/packager.xslt src/package.xml

# Transform the manifest.xml file
xsltproc --novalid --xinclude --output dist/package/package.manifest lib/manifester.xslt src/manifest.xml


# Build the ZIP file
zip -j "dist/${PKG_NAME}-${VERSION}.zip" dist/package/* -x \*.DS_Store
