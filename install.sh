# prepare zip file
mkdir GhostInHand_1.0.6
cp info.json GhostInHand_1.0.6
cp README.md GhostInHand_1.0.6
cp LICENSE GhostInHand_1.0.6
cp thumbnail.png GhostInHand_1.0.6
cp *.lua GhostInHand_1.0.6
cp -R locale GhostInHand_1.0.6
cp changelog.txt GhostInHand_1.0.6
zip -r GhostInHand_1.0.6{.zip,}

# move zip to factorio mods folder (overriding existing one if present)
mv GhostInHand_1.0.6.zip "/cygdrive/c/Users/${USER}/AppData/Roaming/Factorio/mods"

# cleanup
rm -r GhostInHand_1.0.6
