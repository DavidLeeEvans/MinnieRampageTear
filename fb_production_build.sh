#!/bin/sh
rm -f ./prodution_app.zip
rm -fr ./bundle
mkdir -p ./bundle/HTML5
# Bundle for HTML5 with architectures: js-web,wasm-web
./run_build.sh && /home/david/bin/Defold/packages/jdk-17.0.5+8/bin/java -cp "/home/david/bin/Defold/packages/defold-7e5c022ee89d625257f3e22797f49b51d60ba2ef.jar" com.dynamo.bob.Bob --archive --platform "js-web" --architectures "js-web,wasm-web" --bundle-output "./bundle/HTML5" --build-report-html "./bundle/HTML5/build-report.html" --email "dle.evans@gmail.com" --texture-compression true --variant release --with-symbols resolve distclean build bundle &&
#zip -r prodution_app.zip  /home/david/DEFOLD/8/Rili/bundle/HTML5/RailRoad\ Runner/*

#cd  /home/david/DEFOLD/8/Rili/bundle/HTML5/RailRoad\ Runner/
#zip -r /home/david/DEFOLD/8/Rili/prodution_app.zip  *
