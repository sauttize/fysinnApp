extends Control

@export_category("Level Up System")
# Player data
@export var player_data : PlayerData
#@export var leveling_up : Dictionary
# Contains exp needed to level up
@export_group("Level up exp")
@export var exp_needed : Array[int] = [0, 300, 900, 2700, 6500, 14000, 23000, 34000, 48000, 64000, 85000, 100000, 120000, 140000, 165000, 195000, 225000, 265000, 305000, 355000] 

signal level_up()

#Check if exp to level up was obtained.
func _on_exp_exp_updated():
	for n in range(player_data.nivel, exp_needed.size(), 1):
		if player_data.exp >= exp_needed[n]:
			player_data.nivel = (n + 1) # Plus 1 bc is an array and starts in 0.
			emit_signal("level_up")

