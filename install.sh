# prepare zip file
mkdir GhostInHand_1.0.3
cp info.json GhostInHand_1.0.3
cp README.md GhostInHand_1.0.3
cp LICENSE GhostInHand_1.0.3
cp thumbnail.png GhostInHand_1.0.3
cp *.lua GhostInHand_1.0.3
zip -r GhostInHand_1.0.3{.zip,}

# move zip to factorio mods folder (overriding existing one if present)
mv GhostInHand_1.0.3.zip "/cygdrive/c/Users/${USER}/AppData/Roaming/Factorio/mods"

# cleanup
rm -r GhostInHand_1.0.3
