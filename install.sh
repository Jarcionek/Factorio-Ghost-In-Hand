# prepare zip file
mkdir GhostInHand_1.0.4
cp info.json GhostInHand_1.0.4
cp README.md GhostInHand_1.0.4
cp LICENSE GhostInHand_1.0.4
cp thumbnail.png GhostInHand_1.0.4
cp *.lua GhostInHand_1.0.4
cp -R locale GhostInHand_1.0.4
cp changelog.txt GhostInHand_1.0.4
zip -r GhostInHand_1.0.4{.zip,}

# move zip to factorio mods folder (overriding existing one if present)
mv GhostInHand_1.0.4.zip "/cygdrive/c/Users/${USER}/AppData/Roaming/Factorio/mods"

# cleanup
rm -r GhostInHand_1.0.4
