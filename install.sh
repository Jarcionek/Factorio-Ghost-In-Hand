# prepare zip file
mkdir GhostInHand_1.0.5
cp info.json GhostInHand_1.0.5
cp README.md GhostInHand_1.0.5
cp LICENSE GhostInHand_1.0.5
cp thumbnail.png GhostInHand_1.0.5
cp *.lua GhostInHand_1.0.5
cp -R locale GhostInHand_1.0.5
cp changelog.txt GhostInHand_1.0.5
zip -r GhostInHand_1.0.5{.zip,}

# move zip to factorio mods folder (overriding existing one if present)
mv GhostInHand_1.0.5.zip "/cygdrive/c/Users/${USER}/AppData/Roaming/Factorio/mods"

# cleanup
rm -r GhostInHand_1.0.5
