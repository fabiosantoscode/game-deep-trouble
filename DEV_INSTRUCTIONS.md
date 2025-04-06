# adding/tweaking levels

(optional) clone an existing level (`level5.tscn` to `level6.tscn`)

open `elements/level_rotator.gd`

(optional) increase variable `level_count` if you're introducing a new level

to start the game in a level instead of the title, toggle commenting of these calls and edit the level number accordingly

```
    #_start_title_screen()
	_start_level(6)
```
