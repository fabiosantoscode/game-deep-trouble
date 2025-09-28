# versions used

 - Aseprite 1.3.13
 - Godot 4.4.1
 - Ableton live 11 (music)

# adding/tweaking levels

Levels are played in alphanumerical order, so we can add/remove levels and reorder easily by adding more digits. Use 2 digits always, then maybe add letters. This is to make sure order level is the same as the order in the file explorer (the file explorer knows that level20 is higher than level3, but DirAccess sorts normally).

(optional) clone an existing level (`level5.tscn` to `level6.tscn`)

open `elements/level_rotator.gd`

to start the game in a level instead of the title, pause the game, click "auto-jump" checkbox and pick a level from the dropdown. You will jump when the game starts.

# folder structure

- `sub/` stuff related to the submarine, and enemy subs. The sub (the `Sub` class) has many children whose names start by `Sub*` and manage several aspects of the submarine. The enemy sub used to be cut from the same class, so it ended up here as well.
- `elements/` a bunch of scenes that are functional elements or fragments of other elements
- `levels/level[0-9]*.tscn` this is loaded by LevelRotator
- `levels/test/level*.tscn` in developer mode, we can pause and skip to it

# BUILDING

Use the godot Export window to export to the web/ folder. Then run deploy.sh. It should work with linux, mac and bash-for-windows as long as git is installed

