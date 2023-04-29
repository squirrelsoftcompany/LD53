extends Node3D
class_name Univers

var planeteNode = preload("res://nodes/planete.tscn")

#TODO : Expose variables
var seed : int = 0
var radius : int = 15 
var tinyPlanetesNumber : int = 15
var mediumPlanetesNumber : int = 5
var bigPlanetesNumber : int = 2
var interplanetaryMinDistance: int = 10
var rng = RandomNumberGenerator.new()
#TODO: array of "Planet" objects, for now use Vector3 to save positions
var planeteArray: Array[Node3D]


func _init() -> void:
	rng.set_seed(seed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Feed the planeteArray
	for planeteIndex in bigPlanetesNumber:
		createBigPlanete(generateValidPosition())
	for planeteIndex in mediumPlanetesNumber:
		createMediumPlanete(generateValidPosition())
	for planeteIndex in tinyPlanetesNumber:
		createTinyPlanete(generateValidPosition())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
		if pPosition.distance_to(planete.position) < interplanetaryMinDistance:
			return false
	return true
	
func createTinyPlanete(pPosition : Vector3) -> void : 
	var planeteInstance = planeteNode.instantiate()
	planeteInstance.radius = 1
	add_child(planeteInstance)
	planeteInstance.set_position(pPosition)
	planeteArray.push_back(planeteInstance)
	
func createMediumPlanete(pPosition : Vector3) -> void : 
	var planeteInstance = planeteNode.instantiate()
	planeteInstance.radius = 3
	add_child(planeteInstance)
	planeteInstance.set_position(pPosition)
	planeteArray.push_back(planeteInstance)
	
func createBigPlanete(pPosition : Vector3) -> void : 
	var planeteInstance = planeteNode.instantiate()
	planeteInstance.radius = 6
	add_child(planeteInstance)
	planeteInstance.set_position(pPosition)
	planeteArray.push_back(planeteInstance)
	
# DEBUG FUNCTION TO GENERATE SPHERE
func createShere(pPosition : Vector3) -> void :  
	var planeteMesh = SphereMesh.new()
	var planeteInstance = MeshInstance3D.new()
	planeteMesh.set_radius(0.5 + rng.randi_range(0,2)*2 )
	planeteMesh.set_height(planeteMesh.get_radius()*2)
	planeteInstance.set_mesh(planeteMesh)
	add_child(planeteInstance)
	planeteInstance.set_position(pPosition)



