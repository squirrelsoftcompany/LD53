extends WorldEnvironment
class_name Univers

var planetNode = preload("res://nodes/planet.tscn")
var sunNode = preload("res://nodes/sun.tscn")

var dustTexture = preload("res://materials/dustBallMat.tres")
var iceTexture = preload("res://materials/iceBallMat.tres")
var lifeTexture = preload("res://materials/lifeBallMat.tres")

var textureArray = [dustTexture,iceTexture,lifeTexture]

#TODO : Expose variables
var rng_seed : int = 0
var radius : int = 15 
var tinyPlanetsNumber : int = 15
var mediumPlanetsNumber : int = 5
var bigPlanetsNumber : int = 2
var interplanetaryMinDistance: int = 5
var rng = RandomNumberGenerator.new()
var planetArray: Array[Node3D]

func _init() -> void:
	rng.set_seed(rng_seed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Feed the planetArray. Sun and big planets before smaller
	createSun(generateValidPosition(radius/2.0))
	for planetIndex in bigPlanetsNumber:
		createBigPlanet(generateValidPosition())
	for planetIndex in mediumPlanetsNumber:
		createMediumPlanet(generateValidPosition())
	for planetIndex in tinyPlanetsNumber:
		createTinyPlanet(generateValidPosition())

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func generateValidPosition(pDistanceMinToCenter := 0.0) -> Vector3:
	var validPosition = false
	var generatedPosition 
	while (!validPosition):
		generatedPosition = Vector3(rng.randi_range(-radius,radius),rng.randi_range(-radius,radius),rng.randi_range(-radius,radius))
		validPosition = isValidPosition(generatedPosition, pDistanceMinToCenter)
	return generatedPosition


func isValidPosition(pPosition : Vector3, pDistanceMinToCenter := 0.0) -> bool:
	# TODO : change interplanetaryMinDistance according to the size of the planet to generate
	# Check distance to center if needed
	if pDistanceMinToCenter != 0 and pPosition.length() < pDistanceMinToCenter:
		return false
	# Check distance between planets
	for planet in planetArray:
		if pPosition.distance_to(planet.position) < interplanetaryMinDistance :
			return false
	return true
	
func createTinyPlanet(pPosition : Vector3) -> void : 
	var planet = instantiatePlanet(1)
	planet.set_position(pPosition)
	
func createMediumPlanet(pPosition : Vector3) -> void : 
	var planet = instantiatePlanet(3)
	planet.set_position(pPosition)
	
func createBigPlanet(pPosition : Vector3) -> void : 
	var planet = instantiatePlanet(6)
	planet.set_position(pPosition)
	
func createSun(pPosition : Vector3) -> void :
	# TODO : instantiate a sun node.
	var planet = instantiateSun(6)
	var sunMesh = planet.get_child(0)
	# TODO : Change material and shadow behavior directly in the sun scene
	sunMesh.set_cast_shadows_setting(MeshInstance3D.SHADOW_CASTING_SETTING_OFF)
	planet.set_position(pPosition)
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = Color(0.92, 0.69, 0.13, 1.0)
	sunMesh.material_override = newMaterial
	
func instantiatePlanet(pRadius : int = 1)-> Node3D :
	var planetInstance = planetNode.instantiate()
	var planetMesh = planetInstance.get_child(0)
	planetMesh.set_material_override(textureArray[rng.randi_range(0,2)])
	planetInstance.radius = pRadius
	add_child(planetInstance)
	planetArray.push_back(planetInstance)
	return planetInstance
	
func instantiateSun(pRadius : int = 1)-> Node3D : 
	var sunInstance = sunNode.instantiate()
	sunInstance.radius = pRadius
	add_child(sunInstance)
	planetArray.push_back(sunInstance)
	return sunInstance
	
# DEBUG FUNCTION TO GENERATE SPHERE
func createShere(pPosition : Vector3) -> void :  
	var planetMesh = SphereMesh.new()
	var planetInstance = MeshInstance3D.new()
	planetMesh.set_radius(0.5 + rng.randi_range(0,2)*2 )
	planetMesh.set_height(planetMesh.get_radius()*2)
	planetInstance.set_mesh(planetMesh)
	add_child(planetInstance)
	planetInstance.set_position(pPosition)
