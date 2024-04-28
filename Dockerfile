FROM cm2network/steamcmd:root

LABEL maintainer="studyfranco@hotmail.fr"

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y gosu pigz --no-install-recommends\
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /var/log/* \
    && gosu nobody true

RUN mkdir -p /config \
 && chown steam:steam /config

COPY init.sh /

COPY --chown=steam:steam *.ini run.sh /home/steam/

WORKDIR /config

ENV SERVER_NAME="PalworldServerByMe" \
    SERVER_PORT=8211 \
    SERVER_QUERY_PORT=27015 \
    RCON_PORT=25575 \
    RCON_PASSWORD="password" \
    STEAMAPPID=2394010 \
    MAXPLAYERS=32 \
    MAXPLAYERSCOOP=32 \
    MAXPLAYERSGUILD=32 \
    SERVERPASSWORD="password" \
    SERVERADMINPASSWORD="password" \
    PUID=2198 \
    PGID=2198 \
    GAMEBASECONFIGDIR="/config/gamefiles/Pal/Saved/Config" \
    GAMECONFIGDIR="/config/gamefiles/Pal/Saved/Config/LinuxServer" \
    GAMESAVESDIR="/config/gamefiles/Pal/Saved/SaveGames" \
    SKIPUPDATE="false"


ENTRYPOINT [ "/init.sh" ]
