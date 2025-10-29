extends Node

@export var saved_state: Dictionary = {}
@export var has_saved_state = false

static var SAVE_FILE = "user://deep-trouble-save.json"
static var SAVE_FILE_SCRAP = "user://deep-trouble-save.json.new"

func _enter_tree() -> void:
	var saved = _read_dict(SAVE_FILE)
	if saved != null:
		print("Loaded game ", saved)
		saved_state = saved
		has_saved_state = true

func get_saved_state():
	return saved_state

func save_game(file_transform: Callable) -> bool:
	file_transform.call(saved_state)
	DirAccess.remove_absolute(SAVE_FILE_SCRAP)
	if not _write_dict(SAVE_FILE_SCRAP, saved_state):
		DirAccess.remove_absolute(SAVE_FILE_SCRAP)
		print("Error writing file")
		return false
	else:
		DirAccess.rename_absolute(SAVE_FILE_SCRAP, SAVE_FILE)
		return true

func delete_saved_game():
	DirAccess.remove_absolute(SAVE_FILE)
	saved_state = {}
	has_saved_state = false

func _read_dict(filename: String):
	var file = FileAccess.open(filename, FileAccess.READ)
	if file:
		var dict = JSON.parse_string(file.get_as_text())
		file.close()
		if dict is Dictionary:
			return dict
	return null

func _write_dict(filename: String, dict: Dictionary) -> bool:
	var file = FileAccess.open(filename, FileAccess.WRITE)
	if file:
		var json = JSON.stringify(dict)
		var success = file.store_string(json)
		file.close()
		return success
	else:
		return false
