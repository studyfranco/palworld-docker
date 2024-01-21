#!/bin/bash

set -e

set_ini_prop() {
    sed "/\[$2\]/,/^\[/ s/$3\=.*/$3=$4/" -i "${GAMECONFIGDIR}/$1"
}

set_ini_val() {
    sed "/\[$2\]/,/^\[/ s/((\"$3\",.*))/((\"$3\", $4))/" -i "/home/steam/$1"
}

NUMCHECK='^[0-9]+$'
launchDate=`date +"%Y_%m_%d_%H_%M_%s"`

if [ -f "${GAMECONFIGDIR}/PalWorldSettings.ini" ]; then
    tar cf "/config/backups/${launchDate}.tar" "/config/saves" "/config/gameconfigs"
fi

## Initialise and update files
if ! [[ "${SKIPUPDATE,,}" == "true" ]]; then

    space=$(stat -f --format="%a*%S" .)
    space=$((space/1024/1024/1024))
    printf "Checking available space...%sGB detected\\n" "${space}"

    if [[ "$space" -lt 8 ]]; then
        printf "You have less than 8GB (%sGB detected) of available space to download the game.\\nIf this is a fresh install, it will probably fail.\\n" "${space}"
    fi

    printf "Downloading the latest version of the game...\\n"

    /home/steam/steamcmd/steamcmd.sh +force_install_dir /config/gamefiles +login anonymous +app_update "$STEAMAPPID" +quit
else
    printf "Skipping update as flag is set\\n"
fi

mkdir -p "${GAMEBASECONFIGDIR}"

if [ ! -L "${GAMECONFIGDIR}" ]; then
    ln -sf "/config/gameconfigs" "${GAMECONFIGDIR}"
fi

if [ ! -f "${GAMECONFIGDIR}/PalWorldSettings.ini" ]; then
    cp "/config/gamefiles/DefaultPalWorldSettings.ini" "/config/gameconfigs/PalWorldSettings.ini"
    sed -i "s/AdminPassword=\"[^\"]*\"/AdminPassword=\"${SERVERADMINPASSWORD}\"/" "/config/gameconfigs/PalWorldSettings.ini"
    sed -i "s/ServerPassword=\"[^\"]*\"/ServerPassword=\"${SERVERPASSWORD}\"/" "/config/gameconfigs/PalWorldSettings.ini"
    sed -i "s/ServerName=\"[^\"]*\"/ServerName=\"${SERVER_NAME}\"/" "/config/gameconfigs/PalWorldSettings.ini"
fi

if [ ! -L "${GAMESAVESDIR}" ]; then
    ln -sf "/config/saves" "${GAMESAVESDIR}"
fi

if ! [[ "$MAXPLAYERS" =~ $NUMCHECK ]] ; then
    printf "Invalid max players number given: %s\\n" "${MAXPLAYERS}"
    MAXPLAYERS=32
fi
sed -i "s/ServerPlayerMaxNum=[0-9]*/ServerPlayerMaxNum=${MAXPLAYERS}/" "/config/gameconfigs/PalWorldSettings.ini"

if ! [[ "$MAXPLAYERSCOOP" =~ $NUMCHECK ]] ; then
    printf "Invalid max players number given: %s\\n" "${MAXPLAYERSCOOP}"
    MAXPLAYERSCOOP=32
fi
sed -i "s/CoopPlayerMaxNum=[0-9]*/CoopPlayerMaxNum=${MAXPLAYERSCOOP}/" "/config/gameconfigs/PalWorldSettings.ini"

if ! [[ "$SERVER_PORT" =~ $NUMCHECK ]] ; then
    printf "Invalid max players number given: %s\\n" "${SERVER_PORT}"
    SERVER_PORT=8211
fi
sed -i "s/PublicPort=[0-9]*/PublicPort=${SERVER_PORT}/" "/config/gameconfigs/PalWorldSettings.ini"

if ! [[ "$MAXPLAYERSGUILD" =~ $NUMCHECK ]] ; then
    printf "Invalid max players number given: %s\\n" "${MAXPLAYERSGUILD}"
    MAXPLAYERSGUILD=32
fi
sed -i "s/GuildPlayerMaxNum=[0-9]*/GuildPlayerMaxNum=${MAXPLAYERSGUILD}/" "/config/gameconfigs/PalWorldSettings.ini"

#bEnablePlayerToPlayerDamage=False,bEnableFriendlyFire=False

cd /config/gamefiles || exit 1

exec ./PalServer.sh -log -ServerName="${SERVER_NAME}" -RconPassword="${RCON_PASSWORD}" -RconPort="${RCON_PORT}" -PublicPort="${SERVER_PORT}" -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS