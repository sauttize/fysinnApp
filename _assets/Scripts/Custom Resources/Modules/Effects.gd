extends Resource
class_name Effect

@export var effectName : String = "title"
@export var functionName : StringName = 'helloWorld'
var effectAction : Callable = Callable(self, functionName)
