version := `sed -n -e 's/^version=//p' src/pdxinfo` # récupère le numéro de version

run:
    pdc src Bobby.pdx && PlaydateSimulator Bobby.pdx

build:
    rm -rf Bobby.pdx Bobby-{{version}}.pdx
    sed -i -r 's/(buildNumber=)([0-9]+)/echo "\1$((\2+1))"/ge' src/pdxinfo # incrémente buildNumber
    pdc --strip --skip-unknown src Bobby.pdx
    rm -r Bobby.pdx/scenes
    zip Bobby-{{version}}.pdx.zip -r Bobby.pdx
