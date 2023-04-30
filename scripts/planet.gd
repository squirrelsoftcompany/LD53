extends Node3D


@export_range(0, 100) var radius = 1
var facilitiesArray: Array[Node3D]
var rng

@onready var gravity_area = $%GravityArea
@onready var gravity_shape = $%GravityShape


func _init() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = Global._rng
	# planet radius
	scale = Vector3.ONE * radius*2
	gravity_area.gravity_point_unit_distance = radius
	
	# area radius
	var area_radius_scale = ProjectSettings.get_setting("specific/gravity/area_radius_scale", 0)
	gravity_shape.scale = Vector3.ONE * area_radius_scale
	
	# scale gravity by radius
	var base_gravity = ProjectSettings.get_setting("specific/gravity/base_gravity", 0)
	var base_radius = ProjectSettings.get_setting("specific/gravity/base_radius_4_base_gravity", 0)
	var gravity_scale = radius / base_radius if base_radius != 0 else radius
	gravity_area.gravity = base_gravity * gravity_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func generateFacilities(pCount: int) -> void:
	var facilityGeneratedCount : int = 0
	while facilityGeneratedCount < pCount:

		# Real implemantation, waiting for facilities
		var facilityInstance = randomFacilitySelection()
		add_child(facilityInstance)
		
		var validPosition = false
		var radialVector
		while (!validPosition):
			validPosition = true
			radialVector = generatePolarVector() * 0.5
			for facility in facilitiesArray:
				if radialVector.distance_to(facility.position) < 0.8 or radialVector.cross(Vector3.RIGHT) == Vector3.ZERO:
					validPosition = false
		
		var rotateBasis = Basis(Vector3.LEFT, PI/2)
		var base = facilityInstance.global_transform.basis.looking_at(radialVector.normalized(),Vector3.RIGHT)
		facilityInstance.basis = base*rotateBasis
		
		facilityInstance.set_position(radialVector)
		facilityInstance.scale = Vector3.ONE/(radius*2)
		
		facilitiesArray.push_back(facilityInstance)
		facilityGeneratedCount = facilityGeneratedCount + 1
		
func randomFacilitySelection() -> Node3D:
	var newFacility : Node3D = null
	while !newFacility:
		var index = rng.randi_range(0,Global._globalFacilitiesAssetArray.size()-1)
		var facilityInstance = Global._globalFacilitiesAssetArray[index].instantiate()
		# Small planet can only used small facility
		if radius == ProjectSettings.get_setting("specific/univers_generator/tiny_planet_size", 0):
			if facilityInstance.get_meta("size") > 1:
				continue
		newFacility = facilityInstance
	return newFacility
	
func generatePolarVector() -> Vector3:
	var generatedPosition = Vector3(rng.randf_range(-1,1),rng.randf_range(-1,1),rng.randf_range(-1,1))
	while generatedPosition == Vector3(0,0,0):
		generatedPosition = Vector3(rng.randf_range(-1,1),rng.randf_range(-1,1),rng.randf_range(-1,1))
	var squareLenght = generatedPosition.x * generatedPosition.x + generatedPosition.y * generatedPosition.y +generatedPosition.z * generatedPosition.z
	var x : float = generatedPosition.x * 1/ sqrt(squareLenght)
	var y : float = generatedPosition.y * 1/ sqrt(squareLenght)
	var z : float = generatedPosition.z * 1/ sqrt(squareLenght)
	return Vector3(x,y,z)
