extends Node2D
class_name LevelRotator

@onready var level_container: LetterboxedViewport = $LetterboxedViewport
var _current_level_node: Node

const LEVEL_LORE_DUMP = preload("res://levels/level_lore_dump.tscn")
const LEVEL_TITLE_SCREEN = preload("res://levels/level_title_screen.tscn")
const LEVEL_END_SCREEN = preload("res://levels/level_end_screen.tscn")
const ON_DEATH = preload("res://elements/on_death.tscn")
const ON_LEVEL_COMPLETE = preload("res://elements/on_level_complete.tscn")

## level files are "res://levels/level" {any digit} {anything} ".tscn"
static var all_level_files = _find_all_levels()
## Index into all_level_files
var current_level = -1

static func restart_level(from_child: Node):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		level_rot._low_level_set_level(ON_DEATH)
		await level_rot.get_tree().create_timer(0.75).timeout
		level_rot._start_level(level_rot.current_level)

static func title_screen(from_child: Node):
	var level_rot = _find_level_rotator(from_child)
	print("Starting level ", "_start_title_screen")
	if level_rot != null:
		level_rot._low_level_set_level(LEVEL_TITLE_SCREEN)

## Go to the next level. Might be the first level.
static func next_level(from_child: Node):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		# Jingle does not apply to level -1 which is the lore dump
		if level_rot.current_level > -1:
			level_rot._low_level_set_level(ON_LEVEL_COMPLETE)
			await level_rot.get_tree().create_timer(1.5).timeout

		if level_rot.current_level >= len(all_level_files) - 1:
			print("Starting level ", "_beat_game")
			level_rot.current_level = -1
			level_rot._beat_game()
		else:
			level_rot._start_level(level_rot.current_level + 1)

static func story_level(from_child: Node):
	var level_rot = _find_level_rotator(from_child)
	if level_rot != null:
		level_rot._low_level_set_level(LEVEL_LORE_DUMP)
		ParticlePreload.preload_particles()

static func _find_level_rotator(from_child: Node) -> LevelRotator:
	return from_child.find_parent("LevelRotator")

func _ready():
	# To test a level when you press F5: comment the next line
	# and uncomment the one after
	_low_level_set_level(LEVEL_TITLE_SCREEN)
	# _start_level(10)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_F6:
		self._start_level(self.current_level)

func _clear_current_level():
	if _current_level_node != null:
		level_container.inner_viewport.remove_child(_current_level_node)
		_current_level_node.queue_free()
		_current_level_node = null

func _start_level(level_num: int):
	_clear_current_level()

	current_level = level_num
	print("Starting level ", all_level_files[level_num])

	assert(_current_level_node == null)
	_current_level_node = load(all_level_files[level_num]).instantiate()
	level_container.inner_viewport.add_child(_current_level_node)

func _start_title_screen():
	_low_level_set_level(LEVEL_TITLE_SCREEN)

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
