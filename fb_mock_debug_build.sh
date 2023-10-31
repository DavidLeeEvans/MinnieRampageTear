#!/bin/sh

rm -fr ./bundle
mkdir -p ./bundle/HTML5
./run_build.sh && /home/david/bin/Defold/packages/jdk-17.0.5+8/bin/java -cp "/home/david/bin/Defold/packages/defold-b364f346962cf24b6845a52c0c97beb5deb7a8f1.jar" com.dynamo.bob.Bob --archive --platform "js-web" --architectures "js-web,wasm-web" --bundle-output "./bundle/HTML5" --build-report-html "./bundle/HTML5/build-report.html" --email "dle.evans@gmail.com" --texture-compression false --variant debug --with-symbols resolve distclean build bundle

# /home/david/DEFOLD/Minnietaur
#cp ~/python_server.py "/home/david/DEFOLD/Minnietaur"
#cp ./mock_index.html "/home/david/DEFOLD/Minnietuar/bundle/HTML5/Minnietaur/index.html" 
#cp -r common/css "/home/david/DEFOLD/Minnietuar/bundle/HTML5/Minnietaur/" 
#cp -r common/img "/home/david/DEFOLD/Minnietaur/bundle/HTML5/Minnietaur/" 
#cp -r common/js "/home/david/DEFOLD/Minnietuar/bundle/HTML5/Minnietaur/" 
#cp  common/fbapp-config.json "/home/david/DEFOLD/bundle/HTML5/Minnietuar/"
