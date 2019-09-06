
cd myflutter

flutter packages get


flutter build ios  --debug --no-codesign

cd ..

cp -rf myflutter/.ios/Flutter/App.framework Config/
