# versions used

 - Aseprite 1.3.13
 - Godot 4.4.1
 - Ableton live 11 (music)

# adding/tweaking levels

(optional) clone an existing level (`level5.tscn` to `level6.tscn`)

open `elements/level_rotator.gd`

(optional) increase variable `level_count` if you're introducing a new level

to start the game in a level instead of the title, toggle commenting of these calls and edit the level number accordingly

```
    #_start_title_screen()
	_start_level(6)
```

# folder structure

`sub/` stuff related to the submarine, and enemy subs. The sub (the `Sub` class) has many children whose names start by `Sub*` and manage several aspects of the submarine. The enemy sub used to be cut from the same class, so it ended up here as well.
`elements/` a bunch of scenes that are functional elements or fragments of other elements
`levels/level#.tscn` this is loaded by LevelRotator

# BUILDING

Use the godot Export window to export to the web/ folder. Then run deploy.sh. It should work with linux, mac and bash-for-windows as long as git is installed

