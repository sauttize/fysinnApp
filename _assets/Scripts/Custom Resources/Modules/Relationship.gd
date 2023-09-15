extends Resource
class_name Relationship

@export_enum("person", "other") var creature_type : String
@export var rel_name : String = ""
@export var age : int = 0
@export_enum("male", "female", "other") var sex : String = "male"
@export var sex_emoji : String :
	get:
		match sex:
			"male":
				return "♂"
			"female":
				return "♀"
			_:
				return "○"
@export var picture : ImageTexture
@export_range(1, 10) var hearts : int = 0
@export var full_hearts : int = 0 :
	get:
		return floori(hearts / 2)
@export var half_hearts : int = 0 :
	get:
		return int(hearts % 2)
@export var empty_hearts : int = 0:
	get:
		return (5 - (full_hearts + half_hearts))
@export var type : String = "Desconocidx"
@export_multiline var extra_info : String = ""
