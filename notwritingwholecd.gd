extends Area

onready var spaceState = get_world().direct_space_state

export var inputVelocity = Vector3()

var x = 0
var y = 0


func _input(event):
	x = -Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right")
	y = -Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")

func _process(delta):
	inputVelocity = Vector3(x,0,y) * delta * 5

	if inputVelocity != Vector3():
		var colShape = $CollisionShape
		var shape = colShape.get_shape()
		var shapeQuery = PhysicsShapeQueryParameters.new()
		shapeQuery.set_shape(shape)
		shapeQuery.set_transform(colShape.global_transform)
		var moveFraction = spaceState.cast_motion(shapeQuery,inputVelocity)
		global_transform.origin += inputVelocity*moveFraction[1]
		if moveFraction[1] != 1:
			global_transform.origin += inputVelocity.normalized()*shape.get_radius()
		var remainder = inputVelocity*(1-moveFraction[1])
		for i in 1:
			shapeQuery.set_transform(colShape.global_transform)
			var intersections = spaceState.collide_shape(shapeQuery,32)
			
			#for debug purposes
			
			for p in intersections.size():
				
			print(intersections)
