# grid-A-Iron Dungeon

![grid-A-Iron Dungeon splash](docs/splash_collage.png)

Live demo (ephemeral ngrok tunnel — only up while my dev box is running it):
**https://306e-2600-4040-219a-1a00-6f5e-71b-9aa1-ef2.ngrok-free.app**

A grid-based first-person dungeon crawler ("blobber") in the spirit of Atari/Intellivision-era D&D titles. Built with three.js in a single `index.html`.

## Movement

- `W` / `↑` — step forward one room
- `A` / `←` — turn 90° counter-clockwise
- `D` / `→` — turn 90° clockwise
- `E` — open / close the door directly in front of you
- `Space` — descend the stairs (when standing on them)
- `T` — take the top item on the floor
- `F` — attack the current enemy

## Rules

- 8×8 grid level, DFS-carved with extra loops
- Walls between rooms are one of: solid wall, open passage, or door (open/closed)
- Fog of war: you only see your current room and the next room ahead **if** the wall in front is an open passage or an open door
- Doors mirror state on both sides
- One weapon at a time (`Wpn:` slot, defaults to Fists/atk 1; picking up a different weapon auto-drops the current one onto the floor)
- Combat is turn-based; attack or flee. Enemies stay in their rooms and don't chase
- Stairs down are rendered as a black slab + green down-arrow
- Compass shows facing direction, current-room layout, and a discovered-as-you-go top-down ASCII map

## Run locally

```
python3 -m http.server 8765
# then open http://localhost:8765/index.html
```
