extends Node3D
class_name Univers

var planeteNode = preload("res://nodes/planet.tscn")
var sunNode = preload("res://nodes/sun.tscn")

#TODO : Expose variables
var seed : int = 0
var radius : int = 15 
var tinyPlanetesNumber : int = 15
var mediumPlanetesNumber : int = 5
var bigPlanetesNumber : int = 2
var interplanetaryMinDistance: int = 5
var rng = RandomNumberGenerator.new()
var planeteArray: Array[Node3D]

func _init() -> void:
	rng.set_seed(seed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Feed the planeteArray. Sun and big planets before smaller
	createSun(generateValidPosition(radius/2))
	for planeteIndex in bigPlanetesNumber:
		createBigPlanete(generateValidPosition())
	for planeteIndex in mediumPlanetesNumber:
		createMediumPlanete(generateValidPosition())
	for planeteIndex in tinyPlanetesNumber:
		createTinyPlanete(generateValidPosition())

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generateValidPosition(pDistanceMinToCenter = 0) -> Vector3:
	var validPosition = false
	var generatedPosition 
	while (!validPosition):
		generatedPosition = Vector3(rng.randi_range(-radius,radius),rng.randi_range(-radius,radius),rng.randi_range(-radius,radius))
		validPosition = isValidPosition(generatedPosition, pDistanceMinToCenter)
	return generatedPosition


func isValidPosition(pPosition : Vector3, pDistanceMinToCenter = 0) -> bool:
	# TODO : change interplanetaryMinDistance according to the size of the planet to generate
	# Check distance to center if needed
	if pDistanceMinToCenter != 0 and pPosition.length() < pDistanceMinToCenter:
		return false
	# Check distance between planetes
	for planete in planeteArray:
		if pPosition.distance_to(planete.position) < interplanetaryMinDistance :
			return false
	return true
	
func createTinyPlanete(pPosition : Vector3) -> void : 
	var planete = instantiatePlanete(1)
	planete.set_position(pPosition)
	
func createMediumPlanete(pPosition : Vector3) -> void : 
	var planete = instantiatePlanete(3)
	planete.set_position(pPosition)
	
func createBigPlanete(pPosition : Vector3) -> void : 
	var planete = instantiatePlanete(6)
	planete.set_position(pPosition)
	
func createSun(pPosition : Vector3) -> void :
	# TODO : instantiate a sun node.
	var planete = instantiateSun(6)
	var sunMesh = planete.get_child(0)
	# TODO : Change material and shadow behavior directly in the sun scene
	sunMesh.set_cast_shadows_setting(MeshInstance3D.SHADOW_CASTING_SETTING_OFF)
	planete.set_position(pPosition)
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = Color(0.92, 0.69, 0.13, 1.0)
	sunMesh.material_override = newMaterial
	
func instantiatePlanete(pRadius : int = 1)-> Node3D : 
	var planeteInstance = planeteNode.instantiate()
	planeteInstance.radius = pRadius
	add_child(planeteInstance)
	planeteArray.push_back(planeteInstance)
	return planeteInstance
	
func instantiateSun(pRadius : int = 1)-> Node3D : 
	var sunInstance = sunNode.instantiate()
	sunInstance.radius = pRadius
	add_child(sunInstance)
	planeteArray.push_back(sunInstance)
	return sunInstance
	
# DEBUG FUNCTION TO GENERATE SPHERE
func createShere(pPosition : Vector3) -> void :  
	var planeteMesh = SphereMesh.new()
	var planeteInstance = MeshInstance3D.new()
	planeteMesh.set_radius(0.5 + rng.randi_range(0,2)*2 )
	planeteMesh.set_height(planeteMesh.get_radius()*2)
	planeteInstance.set_mesh(planeteMesh)
	add_child(planeteInstance)
	planeteInstance.set_position(pPosition)
