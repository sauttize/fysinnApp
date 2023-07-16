extends Resource
class_name InfoBlock

## Resource linked with console help to quickly access information about different aspects of DnD or
## Fysinn.

@export var infoCalls : Array[String] ## Should be one line calls. Use the method "has" of arrays.
@export_multiline var info : String ## Can use BBCode.
@export_group("Extended")
@export_multiline var infoExtended : String
@export_group("More resources")
@export var textLink : String = ""
@export var videoLink : String = ""
