extends Resource
class_name SaveFilesManager

## Resource to manage the saveFiles

@export var save_files : Array[PlayerData]
var numberOfSaves : int = 0:
	get:
		return save_files.size()
