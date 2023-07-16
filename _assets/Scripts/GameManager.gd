extends Node

const DATA_DUMP_ROUTE = "user://data/DataContainer.tres"
const DATA_DUMP_BACKUP = "res://_assets/Scripts/Custom Resources/Data/CurrentData.tres"

const SAVES_FOLDER_ROUTE = "user://saves/files/"
const SAVE_ROUTE = "user://saves/CurrentPlayer.tres"

const EFFECTS_ROUTE = "res://_assets/Scripts/Custom Resources/Effects/"
const INFO_ROUTE = "res://_assets/Scripts/Custom Resources/Data/Information/Blocks/"

var saving : bool = false

# If it doesnt exist, it creates it.
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
func verify_save_file(path : String, createFile : bool = false):
	if FileAccess.file_exists(path): return true
	elif createFile:
		print("save file created because it didn't exist")
		NewSave(PlayerData.new())
	print(DirAccess.get_open_error())
	return false

#MenuBar Options
func _on_menu_bar_save_file():
	$SaveResource.popup_centered_clamped()

func _on_menu_bar_load_file():
	$LoadResource.popup_centered_clamped()

# SAVE FILE FROM MENU
func _on_menu_bar_re_save_file():
	UpdateOriginalSaveFile()

# SAVE NEW FILE IN CUSTOM PATH
func _on_save_resource_file_selected(save_path):
	var data = GetCurrentSaveManager().saveFile
	data.newSave()
	ResourceSaver.save(data, save_path)

# LOAD FILE FROM DISK
func _on_load_resource_file_selected(load_path):
	var playerData = ResourceLoader.load(load_path).duplicate(true)
	playerData.newSave()
	UpdateCurrentPD(playerData)
	NewSave(playerData)
	
	get_tree().reload_current_scene()

func NewSave(data : PlayerData):
	var numberOfSaves = GetAllSaves().size()
	var newName = "playerData" + str(numberOfSaves) + ".tres"
	while verify_save_file(SAVES_FOLDER_ROUTE + newName):
		numberOfSaves = numberOfSaves + 1
		newName = "playerData" + str(numberOfSaves) + ".tres"
	var path = SAVES_FOLDER_ROUTE + newName
	UpdateFilePath(data, path)
	ResourceSaver.save(data, path)
	return path

func DeleteSave(saveFile : PlayerData):
	var saveManager = GetCurrentSaveManager()
	if saveFile == saveManager.saveFile: 
		saveManager.saveFile = null
		ResourceSaver.save(saveManager, SAVE_ROUTE)
		saveManager.take_over_path(SAVE_ROUTE)
	DirAccess.remove_absolute(saveFile.PATH)

func GetCurrentSaveManager() -> CurrentSaveFile:
	if !verify_save_file(SAVE_ROUTE): return CurrentSaveFile.new()
	var currentSaveManager = ResourceLoader.load(SAVE_ROUTE)
	return currentSaveManager

func GetCurrentSaveFile() -> PlayerData:
	if !verify_save_file(SAVE_ROUTE): 
		print("ERROR LOADING FROM MANAGER")
		return PlayerData.new()
	var currentSave = ResourceLoader.load(SAVE_ROUTE)
	if currentSave.saveFile: return currentSave.saveFile
	else: return PlayerData.new()

func GetAllSaves() -> Array[PlayerData]:
	var allSaves : Array[PlayerData] = []
	var pathList : PackedStringArray = DirAccess.get_files_at(SAVES_FOLDER_ROUTE)
	pathList = updatePathList(pathList)
	for path in pathList:
		var playerData
		playerData = ResourceLoader.load(path)
		if playerData is PlayerData:
			playerData.PATH = path
			ResourceSaver.save(playerData, playerData.PATH)
			allSaves.push_back(playerData)
	return allSaves

func GetAllInfoBlocks() -> Array[InfoBlock]:
	var allBlocks : Array[InfoBlock]
	var pathList : PackedStringArray = DirAccess.get_files_at(INFO_ROUTE)
	for path in pathList:
		var infoBlock
		infoBlock = ResourceLoader.load(INFO_ROUTE + path)
		if infoBlock is InfoBlock:
			allBlocks.push_back(infoBlock)
	return allBlocks

func updatePathList(array : PackedStringArray) -> PackedStringArray:
	for n in array.size():
		array[n] = SAVES_FOLDER_ROUTE + array[n]
	return array

func GetSaveFileAt(path):
	var saveFile : PlayerData
	saveFile = ResourceLoader.load(path)
	if saveFile: return saveFile

func GetDataDump() -> DataFile:
	var getDataDump : DataFile
	if !verify_save_file(DATA_DUMP_ROUTE): 
		getDataDump = ResourceLoader.load(DATA_DUMP_BACKUP)
	else:
		getDataDump = ResourceLoader.load(DATA_DUMP_ROUTE)
	return getDataDump

func GetMainDataDump() -> DataFile:
	var dataDumpOG : DataFile
	dataDumpOG = ResourceLoader.load(DATA_DUMP_ROUTE)
	return dataDumpOG

func UpdateOriginalSaveFile():
	var currentManager : CurrentSaveFile = GetCurrentSaveManager()
	var currentSave : PlayerData = currentManager.saveFile
	var allSaves = GetAllSaves()
	for save in allSaves:
		if save == currentSave: 
			print("Save found")
			ResourceSaver.save(currentSave, save.PATH)
			currentSave.take_over_path(save.PATH)
#	var search = PlayerData.new() # I don't even think it's necessary but I don't want to delete it bc idk who knows
#	if GetSaveFileAt(currentSave.PATH): search = GetSaveFileAt(currentSave.PATH)
#	if (currentSave == search):
#		print("got here")
#		ResourceSaver.save(currentSave, currentSave.PATH)
#		currentSave.take_over_path(currentSave.PATH)

func UpdateFilePath(data : PlayerData, path : String):
	data.PATH = path

func UpdateCurrentPD(data : PlayerData):
	var currentSave = GetCurrentSaveManager();
	currentSave.saveFile = data;
	ResourceSaver.save(currentSave, SAVE_ROUTE)
	currentSave.take_over_path(SAVE_ROUTE)

# Full lists of data
func GetAllEffects() -> Array[Effect]:
	var allEffects : Array[Effect] = []
	var pathList : PackedStringArray = DirAccess.get_files_at(EFFECTS_ROUTE)
	for path in pathList:
		var thisEffect
		thisEffect = ResourceLoader.load(EFFECTS_ROUTE + path)
		if thisEffect is Effect:
			allEffects.push_back(thisEffect)
	return allEffects
