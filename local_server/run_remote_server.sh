#!/bin/sh
cd ..
rm -f ./prodution_app.zip
rm -fr ./bundle
mkdir -p ./bundle/HTML5
# Bundle for HTML5 with architectures: js-web,wasm-web
./run_build.sh && /home/david/bin/Defold/packages/jdk-17.0.5+8/bin/java -cp "/home/david/bin/Defold/packages/defold-7e5c022ee89d625257f3e22797f49b51d60ba2ef.jar" com.dynamo.bob.Bob --archive --platform "js-web" --architectures "js-web,wasm-web" --bundle-output "./bundle/HTML5" --build-report-html "./bundle/HTML5/build-report.html" --email "dle.evans@gmail.com" --texture-compression true --variant release --with-symbols resolve distclean build bundle &&

cd  /home/david/DEFOLD/8/Rili/bundle/HTML5/RailRoad\ Runner/
cp -r *  /home/david/DEFOLD/8/Rili/local_server
cd /home/david/DEFOLD/8/Rili/local_server

# Starts to serve via HTTPS, with cache disabled
/home/david/DEFOLD/8/Rili/node_modules/http-server/bin/http-server --ssl -c-1 -p 8080 -a 127.0.0.1 

#https://www.facebook.com/embed/instantgames/867251081556940/player?game_url=https://localhost:8080


##Note: You must have played your game at least once on fb.gg/play/867251081556940 for the embedded player to work properly.
