extends Node3D
class_name Univers

var seed : int = 0
var radius : int = 15 
var planetesNumber : int = 20
var interplanetaryMinDistance: int = 10
var rng = RandomNumberGenerator.new()
#TODO: array of "Planet" objects, for now use Vector3 to save positions
var planeteArray: Array[Vector3]

func _init() -> void:
	rng.set_seed(seed)
	# Generate planeteArray
	for planeteIndex in planetesNumber:
		planeteArray.push_back(generateValidPosition())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for planeteIndex in planetesNumber:
		createShere(planeteArray[planeteIndex])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generateValidPosition() -> Vector3:
	var validPosition = false
	var generatedPosition 
	while (!validPosition):
		generatedPosition = Vector3(rng.randi_range(-radius,radius),rng.randi_range(-radius,radius),rng.randi_range(-radius,radius))
		validPosition = isValidPosition(generatedPosition)
	return generatedPosition


func isValidPosition(pPosition : Vector3) -> bool:
	# TODO : change interplanetaryMinDistance according to the size of the planet to generate
	for planete in planeteArray:
		if pPosition.distance_to(planete) < interplanetaryMinDistance:
			return false
	return true
	
# DEBUG FUNCTION TO GENERATE SPHERE
func createShere(pPosition : Vector3) -> void :  
	var planeteMesh = SphereMesh.new()
	var planeteInstance = MeshInstance3D.new()
	planeteMesh.set_radius(0.5 + rng.randi_range(0,2)*2 )
	planeteMesh.set_height(planeteMesh.get_radius()*2)
	planeteInstance.set_mesh(planeteMesh)
	add_child(planeteInstance)
	planeteInstance.set_position(pPosition)
