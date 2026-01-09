# CivExplore

### Run commands 

mix run -e "CivExplore.run_server()"
mix run -e "CivExplore.run_client()"

## Description

1. Users join and are dropped into the world map 
2. Users can navigate the world map using the keyboard, the world map is 100x100. Players can see if there are other players on the tile they want to enter.
3. Each world map tile is 360 x 360.
4. Map tiles are generated once they are visited for the first time.
5. Tiles run on a tick bases, tick moves the npcs. There are two modes, immediate (1 tick = 1ms) and combat (1 tick = 1 move).
