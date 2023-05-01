extends WorldEnvironment
class_name Univers

var planetNode = preload("res://nodes/planet.tscn")
var sunNode = preload("res://nodes/sun.tscn")

var asteroid_a_node := preload("res://nodes/asteroids/asteroid_a.tscn")
var asteroid_b_node := preload("res://nodes/asteroids/asteroid_b.tscn")
var asteroid_c_node := preload("res://nodes/asteroids/asteroid_c.tscn")

var dustTexture = preload("res://materials/dustBallMat.tres")
var iceTexture = preload("res://materials/iceBallMat.tres")
var lifeTexture = preload("res://materials/lifeBallMat.tres")

var textureArray = [dustTexture,iceTexture,lifeTexture]
var planetArray: Array[Node3D]
var rng

@onready var radius = ProjectSettings.get_setting("specific/univers_generator/univers_radius", 0)
@onready var tinyPlanetsNumber = ProjectSettings.get_setting("specific/univers_generator/tiny_planet_numbers", 0)
@onready var mediumPlanetsNumber = ProjectSettings.get_setting("specific/univers_generator/medium_planet_numbers", 0)
@onready var bigPlanetsNumber = ProjectSettings.get_setting("specific/univers_generator/big_planet_numbers", 0)
@onready var asteroidsNumber = ProjectSettings.get_setting("specific/univers_generator/asteroids_numbers", 0)
@onready var interplanetaryMinDistance = ProjectSettings.get_setting("specific/univers_generator/interplanetary_min_distance", 0)
@onready var tinyPlanetsSize = ProjectSettings.get_setting("specific/univers_generator/tiny_planet_size", 0)
@onready var mediumPlanetsSize = ProjectSettings.get_setting("specific/univers_generator/medium_planet_size", 0)
@onready var bigPlanetsSize = ProjectSettings.get_setting("specific/univers_generator/big_planet_size", 0)



func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = Global._rng
	# Feed the planetArray. Sun and big planets before smaller
	createSun(generateValidPosition(radius/2.0))
	for planetIndex in bigPlanetsNumber:
		createBigPlanet(generateValidPosition())
	for planetIndex in mediumPlanetsNumber:
		createMediumPlanet(generateValidPosition())
	for planetIndex in tinyPlanetsNumber:
		createTinyPlanet(generateValidPosition())
	for asteroidIndex in asteroidsNumber:
		createAsteroid(generateValidPosition())

		
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
	var planet = instantiatePlanet(tinyPlanetsSize)
	planet.generateFacilities(1)
	planet.set_position(pPosition)
	
func createMediumPlanet(pPosition : Vector3) -> void : 
	var planet = instantiatePlanet(mediumPlanetsSize)
	planet.generateFacilities(2)
	planet.set_position(pPosition)
	
func createBigPlanet(pPosition : Vector3) -> void : 
	var planet = instantiatePlanet(bigPlanetsSize)
	planet.generateFacilities(3)
	planet.set_position(pPosition)

func createAsteroid(pPosition : Vector3) -> void :
	var asteroid = null
	match(rng.randi_range(0,2)):
		0:
			asteroid = asteroid_a_node.instantiate()
		1:
			asteroid = asteroid_b_node.instantiate()
		2:
			asteroid = asteroid_c_node.instantiate()
	asteroid.linear_velocity.x = rng.randi_range(-10,10)
	asteroid.linear_velocity.y = rng.randi_range(-10,10)
	asteroid.linear_velocity.z = rng.randi_range(-10,10)
	asteroid.angular_velocity.x = rng.randi_range(-10,10)
	asteroid.angular_velocity.y = rng.randi_range(-10,10)
	asteroid.angular_velocity.z = rng.randi_range(-10,10)
	asteroid.inertia.x = rng.randi_range(-0,10)
	asteroid.inertia.y = rng.randi_range(-0,10)
	asteroid.inertia.z = rng.randi_range(-0,10)
	asteroid.set_position(pPosition)
	add_child(asteroid)

func createSun(pPosition : Vector3) -> void :
	# TODO : instantiate a sun node.
	var planet = instantiateSun(bigPlanetsSize)
	var sunMesh = planet.get_child(0)
	# TODO : Change material and shadow behavior directly in the sun scene
	sunMesh.set_cast_shadows_setting(MeshInstance3D.SHADOW_CASTING_SETTING_OFF)
	planet.set_position(pPosition)
	
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
