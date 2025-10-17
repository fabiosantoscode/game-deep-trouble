extends Node2D
class_name LevelRotator

@onready var level_container: LetterboxedViewport = $LetterboxedViewport
var _current_level_node: Node

const LEVEL_LORE_DUMP = preload("res://levels/level_lore_dump.tscn")
const LEVEL_TITLE_SCREEN = preload("res://levels/level_title_screen.tscn")
const LEVEL_END_SCREEN = preload("res://levels/level_end_screen.tscn")
const ON_DEATH = preload("res://elements/on_death.tscn")
const ON_LEVEL_COMPLETE = preload("res://elements/on_level_complete.tscn")
const PAUSE_MENU = preload("res://elements/pause_menu.tscn")

const SAVEKEY_DEVELOPER_AUTO_JUMP = "developer_auto_jump"

## level files are "res://levels/level" {any digit} {anything} ".tscn"
static var all_level_files = _find_all_levels()
static var test_level_files = _find_test_levels()

## Index into all_level_files
var current_level: String = ""

func _ready():
	_load_game_file()
	_ready_pause_menu()

	if not _dev_auto_jump():
		_low_level_set_level(LEVEL_TITLE_SCREEN)

## Skip to a level because we're a dev and we asked. See dev_change_level
func _dev_auto_jump():
	var skip_to_lvl = SaveGame.get_saved_state().get(SAVEKEY_DEVELOPER_AUTO_JUMP, "")
	if skip_to_lvl != "":
		LevelRotator.dev_change_level(self, skip_to_lvl)
		return true
	return false

static func is_in_title_screen(from_child: Node):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		return level_rot._current_level_node is LevelTitleScreen

## When we click "start" on the title screen
static func start_game(from_child: Node):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		if level_rot.current_level == "":
			level_rot._low_level_set_level(LEVEL_LORE_DUMP)
		else:
			# Load game!
			level_rot._start_level(level_rot.current_level)
		ParticlePreload.preload_particles()

## On death we restart
static func restart_level(from_child: Node):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		level_rot._low_level_set_level(ON_DEATH)
		await level_rot.get_tree().create_timer(0.75).timeout
		level_rot._start_level(level_rot.current_level)

## Go to the next level. Might be the first level.
static func next_level(from_child: Node, play_jingle = true):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		if test_level_files.has(level_rot.current_level):
			# It's a developer level. Just restart it
			level_rot._start_level(level_rot.current_level)
			return

		if play_jingle:
			level_rot._low_level_set_level(ON_LEVEL_COMPLETE)
			await level_rot.get_tree().create_timer(1.5).timeout

		var level_idx = all_level_files.find(level_rot.current_level)
		if level_idx + 1 < len(all_level_files):
			level_rot._start_level(all_level_files[level_idx + 1])
		else:
			print("Starting level ", "_beat_game")
			level_rot.current_level = ""
			level_rot._beat_game()
		level_rot._save_game_file()

## After the player beat the game and saw/skipped credits they go back to the title screen
static func after_credits(from_child: Node):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		print("Starting level ", "_start_title_screen")
		level_rot._low_level_set_level(LEVEL_TITLE_SCREEN)

## Used for developer menu
static func dev_change_level(from_child: Node, level_name: String):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		level_rot._start_level(level_name)
		level_rot._save_game_file()

static func dev_set_auto_jump(auto_jump=""):
	SaveGame.save_game(func(state: Dictionary):
		state[SAVEKEY_DEVELOPER_AUTO_JUMP] = auto_jump)

static func _find_level_rotator(from_child: Node) -> LevelRotator:
	if from_child is LevelRotator: return from_child
	return from_child.find_parent("LevelRotator")

func _load_game_file():
	var saved = SaveGame.get_saved_state()
	if (
		saved is Dictionary
		and saved.get("current_level") is String
		and all_level_files.has(saved["current_level"])
	):
		self.current_level = saved["current_level"]

func _save_game_file():
	SaveGame.save_game(func(old_state):
		old_state["current_level"] = self.current_level)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_F6:
		self._start_level(self.current_level)

func _clear_current_level():
	if _current_level_node != null:
		level_container.inner_viewport.remove_child(_current_level_node)
		_current_level_node.queue_free()
		_current_level_node = null

func _start_level(level_file: String):
	_clear_current_level()

	self.current_level = level_file
	print("Starting level ", level_file)

	assert(_current_level_node == null)
	_current_level_node = load(level_file).instantiate()
	level_container.inner_viewport.add_child(_current_level_node)

func _beat_game():
	_low_level_set_level(LEVEL_END_SCREEN)

func _low_level_set_level(packed_scene):
	_clear_current_level()
	assert(_current_level_node == null)
	_current_level_node = packed_scene.instantiate()
	level_container.inner_viewport.add_child(_current_level_node)

static func _find_all_levels():
	var ret = []
	for file in ResourceLoader.list_directory("res://levels/"):
		if file.begins_with("level") and file.ends_with(".tscn"):
			var digit = file[len("level")]
			if "0123456789".contains(digit):
				ret.push_back("res://levels/" + file)
	return ret

## Levels for the developer only
static func _find_test_levels():
	var ret = []
	for file in ResourceLoader.list_directory("res://levels/test/"):
		if file.begins_with("level") and file.ends_with(".tscn"):
			ret.push_back("res://levels/test/" + file)
	return ret

func _ready_pause_menu():
	await get_tree().physics_frame
	Utils.spawn(level_container.inner_viewport, PAUSE_MENU.instantiate())
