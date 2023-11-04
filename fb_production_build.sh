#!/bin/sh
rm -f ./prodution_app.zip
rm -fr ./bundle
mkdir -p ./bundle/HTML5
# Bundle for HTML5 with architectures: js-web,wasm-web
./run_build.sh && /home/david/bin/Defold/packages/jdk-17.0.5+8/bin/java -cp "/home/david/bin/Defold/packages/defold-b364f346962cf24b6845a52c0c97beb5deb7a8f1.jar" com.dynamo.bob.Bob --archive --platform "js-web" --architectures "js-web,wasm-web" --bundle-output "./bundle/HTML5" --build-report-html "./bundle/HTML5/build-report.html" --email "dle.evans@gmail.com" --texture-compression true --variant release --with-symbols resolve distclean build bundle

cd  /home/david/DEFOLD/MinnietaurGame/bundle/HTML5/Minnietaur
zip -r /home/david/DEFOLD/MinnietaurGame/prodution_app.zip  *
