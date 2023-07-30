extends Node

const DATA_DUMP_ROUTE = "user://data/DataContainer.tres"
const DATA_DUMP_BACKUP = "res://_assets/Scripts/Custom Resources/Data/CurrentData.tres"

const SAVES_FOLDER_ROUTE = "user://saves/files/"
const SAVE_ROUTE = "user://saves/CurrentPlayer.tres"

const EFFECTS_ROUTE = "res://_assets/Scripts/Custom Resources/Effects/"
const INFO_ROUTE = "res://_assets/Scripts/Custom Resources/Data/Information/Blocks/"
const SPELLS_ROUTE = "res://_assets/Scripts/Custom Resources/Spells/"

const RACE_NONE = "res://_assets/Scripts/Custom Resources/Modules/Races/_none.tres"

var saving : bool = false

var conversionDIC : Dictionary = {
	"PCPC": 1.0, "PPPP": 1.0, "PEPE": 1.0, "POPO": 1.0, "PPTPPT": 1.0,
	"PCPP" : 0.1, "PCPE" : 0.02, "PCPO" : 0.01, "PCPPT" : 0.001,
	"PPPC" : 10.0, "PPPE" : 0.2, "PPPO" : 0.1, "PPPPT" : 0.01,
	"PEPC" : 50.0, "PEPP" : 5.0, "PEPO" : 0.5, "PEPPT" : 0.05,
	"POPC" : 100.0, "POPP" : 10.0, "POPE" : 2.0, "POPPT" : 0.1,
	"PPTPC" : 1000.0, "PPTPP" : 100.0, "PPTPE" : 20.0, "PPTPO" : 10.0
}

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
	if playerData is PlayerData:
		playerData.newSave()
		UpdateCurrentPD(playerData)
		NewSave(playerData)
	else:
		Utilities.create_PopUp("Ese archivo no es del tipo correcto. Vuelve a intentarlo.")
	
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

## Way of saving the data
func UpdateOriginalSaveFile():
	var currentManager : CurrentSaveFile = GetCurrentSaveManager()
	var currentSave : PlayerData = currentManager.saveFile
	var allSaves = GetAllSaves()
	for save in allSaves:
		if save == currentSave: 
			if OS.is_debug_build(): print("Save found")
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

# Get specific kind of data
func GetRaceNone() -> Race:
	var raceNone : Race
	raceNone = ResourceLoader.load(RACE_NONE)
	return raceNone

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

func GetAllInfoBlocks() -> Array[InfoBlock]:
	var allBlocks : Array[InfoBlock]
	var pathList : PackedStringArray = DirAccess.get_files_at(INFO_ROUTE)
	for path in pathList:
		var infoBlock
		infoBlock = ResourceLoader.load(INFO_ROUTE + path)
		if infoBlock is InfoBlock:
			allBlocks.push_back(infoBlock)
	return allBlocks

func GetAllSpells() -> Array[Spell]:
	var allSpells : Array[Spell]
	var pathList : PackedStringArray = DirAccess.get_files_at(SPELLS_ROUTE)
	for path in pathList:
		var spell
		spell = ResourceLoader.load(SPELLS_ROUTE + path)
		if spell is Spell:
			allSpells.push_back(spell)
	return allSpells

# Functionalities
# Currency related
func money_needed(to_int : int, from_str : String, to_str : String) -> int:
	var from_to : String = from_str + to_str
	var needed_money : float
	
	needed_money = to_int / conversionDIC[from_to]
	if floorf(needed_money) != needed_money:
		return ceil(needed_money)
	else: return int(needed_money)

func money_returned(from_int : int, from_str : String, to_str : String) -> int:
	var from_to : String = from_str + to_str
	var returned_money: int
	
	returned_money = int(from_int * conversionDIC[from_to])
	
	return returned_money
