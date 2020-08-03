# Upgrade Music
SourceMod plugin for TF2 that re-enables the unused Upgrade Station music.

## CVARs
_**changing these CVARs requires a map change to take effect!**_

`sm_upgrademusic_enable [1]/0` - enable or disable plugin functionality

`sm_upgrademusic_method 1/[2]` - Change play method

Method 1 plays the sound ambiently from the upgrade stations themselves, but if a player isn't nearby the music stops and they must wait until the next loop before hearing it again.

Method 2 plays the sound to each player individually when they enter the buy zone. This guarantees that they'll hear the music when interaction with the Upgrade Station, and it will continue playing from the station as they exit it until it hits the loop point of the song.

Method 1, as long as you stay in range, sounds better as it loops and does not require you to interact with it, but method 2 is logistically better as it guarantees players will hear the music, and it will continue playing from the station even after they leave.