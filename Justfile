version := `sed -n -e 's/^version=//p' src/pdxinfo`

run:
    pdc src Bobby.pdx && PlaydateSimulator Bobby.pdx

build:
    pdc -s src Bobby.pdx
    find Bobby.pdx -name "*.kra" -type f -delete
    find Bobby.pdx -name "*~" -type f -delete
    rm -r Bobby.pdx/scenes
    mv Bobby.pdx Bobby-{{version}}.pdx
