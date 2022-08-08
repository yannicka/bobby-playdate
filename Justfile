version := `cat Source/pdxinfo | grep 'version' | sed 's/version=//'`

run:
    pdc Source Bobby.pdx && PlaydateSimulator Bobby.pdx

build:
    pdc -s Source Bobby.pdx
    find Bobby.pdx -name "*.kra" -type f -delete
    find Bobby.pdx -name "*~" -type f -delete
    rm -r Bobby.pdx/scenes
    mv Bobby.pdx Bobby-{{version}}.pdx
