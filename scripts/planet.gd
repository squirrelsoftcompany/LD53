extends Node3D


@export_range(0, 100) var radius = 1
var facilitiesArray: Array[Node3D]
var punchableArray: Array[Node3D]
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
	@warning_ignore("unused_variable")
	var punchableCount : int = 0
	var deliveryZoneCount : int = 0
	var isPunchable = false

	# A bit complexe way to dispatch delivary zones and punchable stuff but it should works as expected (too lazy to rework the algo)
	if pCount == 1:
		var flipcoin = rng.randi_range(0,1)
		if flipcoin:
			deliveryZoneCount = 1
		else:
			punchableCount = 1
	else:
		@warning_ignore("integer_division")
		deliveryZoneCount = pCount/2 + pCount%2
		@warning_ignore("integer_division")
		punchableCount = pCount/2

	while facilityGeneratedCount < pCount:
		var facilityInstance
		if deliveryZoneCount > 0 :
			facilityInstance = randomDeliveryZoneSelection()
			deliveryZoneCount -= 1
		else:
			facilityInstance = randomPunchableSelection()
			isPunchable = true
			punchableCount -= 1
		
		add_child(facilityInstance)
		var validPosition = false
		var radialVector
		var maxTryCount = 1000 #Stop trying after too much tries. Safer considering the random generation.
		while (!validPosition) and maxTryCount >= 0:
			validPosition = true
			radialVector = generatePolarVector() * 0.5
			for facility in facilitiesArray:
				if radialVector.distance_to(facility.position) < 0.2 or radialVector.cross(Vector3.RIGHT) == Vector3.ZERO:
					validPosition = false
					maxTryCount -= 1
		
		var rotateBasis = Basis(Vector3.LEFT, PI/2)
		var base = facilityInstance.global_transform.basis.looking_at(radialVector.normalized(),Vector3.RIGHT)
		facilityInstance.basis = base*rotateBasis
		
		facilityInstance.set_position(radialVector)
		facilityInstance.scale = Vector3.ONE/(radius*2)

		# If it's a punchable stuff we have to detach the facilityInstance from the planet  
		if isPunchable :
			@warning_ignore("unused_variable")
			var savedGlobalTranform = facilityInstance.get_global_transform()
#			var grandParent = facilityInstance.get_parent().get_parent()
#			facilityInstance.get_parent().remove_child(facilityInstance)
#			grandParent.add_child(facilityInstance)
#			facilityInstance.set_global_transform(savedGlobalTranform)
		else :
			facilitiesArray.push_back(facilityInstance)
			
		facilityGeneratedCount = facilityGeneratedCount + 1


func randomDeliveryZoneSelection() -> Node3D:
	var newDeliveryZone : Node3D = null
	while !newDeliveryZone:
		var index = rng.randi_range(0,Global.globalDeliveryZoneAssetArray.size()-1)
		var deliveryZoneInstance = Global.globalDeliveryZoneAssetArray[index].instantiate()
		# Small planet can only used small facility
		if radius == ProjectSettings.get_setting("specific/univers_generator/tiny_planet_size", 0):
			if deliveryZoneInstance.get_meta("size") > 1:
				continue
		newDeliveryZone = deliveryZoneInstance
	return newDeliveryZone


func randomPunchableSelection() -> Node3D:
	var newPunchable : Node3D = null
	while !newPunchable:
		var index = rng.randi_range(0,Global.globalPunchableAssetArray.size()-1)
		var punchableInstance = Global.globalPunchableAssetArray[index].instantiate()
		newPunchable = punchableInstance
	return newPunchable


func generatePolarVector() -> Vector3:
	var generatedPosition = Vector3(rng.randf_range(-1,1),rng.randf_range(-1,1),rng.randf_range(-1,1))
	while generatedPosition == Vector3(0,0,0):
		generatedPosition = Vector3(rng.randf_range(-1,1),rng.randf_range(-1,1),rng.randf_range(-1,1))
	var squareLenght = generatedPosition.x * generatedPosition.x + generatedPosition.y * generatedPosition.y +generatedPosition.z * generatedPosition.z
	var x : float = generatedPosition.x * 1/ sqrt(squareLenght)
	var y : float = generatedPosition.y * 1/ sqrt(squareLenght)
	var z : float = generatedPosition.z * 1/ sqrt(squareLenght)
	return Vector3(x,y,z)
