<div align="center">
  
![Github stars](https://badgen.net/github/stars/studyfranco/palworld-docker?icon=github&label=stars)
![Github forks](https://badgen.net/github/forks/studyfranco/palworld-docker?icon=github&label=forks)
![Github issues](https://img.shields.io/github/issues/studyfranco/palworld-docker)
![Github last-commit](https://img.shields.io/github/last-commit/studyfranco/palworld-docker)
  
</div>

# Palworld Dedicated Server

Hello and welcome! Hopefully this can help anyone get up and running with Palwolrd!

Issues are welcome but pull requests are even more welcome if you can!

## Specials thanks

My work are based on the docker server of satisfactory from [wolveix](https://github.com/wolveix/satisfactory-server)

## Background

I spun this up initially because well like anyone else, I wanted to run a dedicated server, but with a docker images who can edit the configuration ini.

This image is based on cm2network/steamcmd image and built out using a combination of help from the satisfactory and valheim images using the same base.

I used my previous scripts from Frozen Flame, and now you have this image.

## Setup

For people who want use the image you can use [docker compose](https://docs.docker.com/compose/) up -d:
```yaml
version: "3.7"
services:
  palworld:
    container_name: palworld-server
    hostname: palworld-server
    image: ghcr.io/studyfranco/palworld-docker:master
    #network_mode: "host"
    volumes:
      - "/path/to/config:/config"
    ports:
      - 8211:8211/udp
      - 27017:27017/udp
    expose:
      - 8211/udp
      - 27017/udp
    environment:
      - "SERVER_NAME=PalworldServerByMe"
      - "SERVER_PORT=8211"
      - "SERVER_QUERY_PORT=27015"
      - "RCON_PORT=25575"
      - "RCON_PASSWORD=password"
      - "MAXPLAYERS=32"
      - "MAXPLAYERSCOOP=32"
      - "MAXPLAYERSGUILD=32"
      - "SERVERPASSWORD=password"
      - "SERVERADMINPASSWORD=password"
      - "PUID=2198"
      - "PGID=2198"
      - "TZ=Etc/UTC"
    tmpfs:
      - "/run:exec,mode=777"
      - "/tmp:exec,mode=777"
      - "/tmp/dumps:exec,mode=777"
      - "/var/tmp:exec,mode=777"
      - "/config/gamefiles/steamapps/temp:uid=2198,gid=2198"
    restart: "unless-stopped"
```
You can use the safer way with ports forwarding, or the network mod host.

Or you can use a quick and dirty `docker run`:
```bash
run -d --net=host -v </path/to/config>:/config --name=palworld-dedicated ghcr.io/studyfranco/palworld-docker:main 
```
This is currently using the host network simplicity but you should be able to map the ports how you wish without it, but that's untested by me.

## Environment Variables

| Parameter               |  Default  | Function                                            |
| ----------------------- | :-------: | --------------------------------------------------- |
| `SERVER_NAME` | `PalworldServerByMe` | set the name of the server in Frozen Flame          |
| `SERVER_PORT`           |   `8211`  | Sets custom Game port. This is used by client to connect |
| `SERVER_QUERY_PORT`     |  `27015`  | Sets custom Query Port. Used by Steam to get server info |
| `SERVERPASSWORD`        | `password`| Set server password                                 |
| `SERVERADMINPASSWORD`   | `password`| Set server Admin password                           |
| `RCON_PORT`             |  `25575`  | Set Rcon port                                       |
| `RCON_PASSWORD`         | `password`| Set Rcon password                                   |
| `MAXPLAYERS`            |    `32`   | set the player limit for your server                |
| `PGID`                  |   `2198`  | set the group ID of the user the server will run as |
| `PUID`                  |   `2198`  | set the user ID of the user the server will run as  |

## Features in this docker

 - Backup at each start
 - Automatic edition of basic server game configs

I am open to improve some features

## Improve your experiences

You can edit the /config/gameconfigs/PalWorldSettings.ini to choose somes other options.

## Last Update
2026-02-15
