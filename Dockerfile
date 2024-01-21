FROM cm2network/steamcmd:root

LABEL maintainer="studyfranco@hotmail.fr"

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y gosu wget --no-install-recommends\
    && rm -rf /var/lib/apt/lists/*  \
    && gosu nobody true

RUN mkdir -p /config \
 && chown steam:steam /config

COPY init.sh /

COPY --chown=steam:steam *.ini run.sh /home/steam/

WORKDIR /config

ENV SERVER_NAME="PalworldServerByMe" \
    SERVER_PORT=7779 \
    SERVER_QUERY_PORT=7780 \
    RCON_PORT=27017 \
    RCON_PASSWORD="password" \
    STEAMAPPID=2394010 \
    MAXPLAYERS=32 \
    MAXPLAYERSCOOP=32 \
    SERVERPASSWORD="password" \
    DAYDURATION=3600 \
    PUID=1000 \
    PGID=1000 \
    GAMECONFIGDIR="/config/gamefiles/Pal/Saved/Config/LinuxServer" \
    GAMESAVESDIR="/config/gamefiles/Pal/Saved/SaveGames" \
    SKIPUPDATE="false"


ENTRYPOINT [ "/init.sh" ]
