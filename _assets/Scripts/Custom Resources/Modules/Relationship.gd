extends Resource
class_name Relationship

@export_enum("person", "other") var creature_type : String
@export var name : String = ""
@export var picture : ImageTexture
@export_range(1, 10) var hearts : int = 0
@export var type : String = "Desconocidx"
@export_multiline var extra_info : String = ""
