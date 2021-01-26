extends Area


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_make_readable()


func _make_readable():
	#var world = get_world().direct_space_state
	var body = self.get_overlapping_bodies()
	
	for i in body.size():
		var colShape = body[i].get_child(0)
		var shape = colShape.get_shape()
		var pos = colShape.global_transform.origin
		var rot = colShape.global_transform.basis
		var colScale = colShape.get_scale()
		
		var moveDir = Vector3(1,0,0).normalized() #placeholder
		
		var contactPoint = Vector3()
	
	
		if shape is ConcavePolygonShape:
			shape.get_faces()
		
		
		elif shape is CapsuleShape:
			rot = rot.z
			rot = _rot_correcter(rot,moveDir)
			contactPoint = (rot * shape.get_height()*0.5) + (-moveDir * shape.get_radius()) + pos
		
		
		elif shape is BoxShape:
			var offset = Vector3(1,1,1).length() * rot.x
			var ext = shape.get_extents() * colScale
			print(offset*ext)
			
			var corners := [Vector3(1,1,1),Vector3(1,1,-1),Vector3(1,-1,1),Vector3(1,-1,-1),Vector3(-1,1,1),Vector3(-1,1,-1),Vector3(-1,-1,1),Vector3(-1,-1,-1)]
			for b in corners.size():
				contactPoint = (corners[b]+ offset) * ext
		
		
		elif shape is SphereShape:
			print(shape.get_radius())
			contactPoint = -moveDir * shape.get_radius() * colScale.x + pos
			#fix stuff, check point position ...
		
		
		elif shape is CylinderShape:
			rot = rot.y
			rot = _rot_correcter(rot,moveDir)
			var cylinderPointFinder = -moveDir.rotated(moveDir.cross(rot).normalized(),cos(rot.dot(Vector3.UP)))
			contactPoint = rot * shape.get_height()*0.5 + cylinderPointFinder * shape.get_radius() + pos
		
		
		elif shape is HeightMapShape:
			#learn about scale and general usage
			pass
		
		
		elif shape is ConvexPolygonShape:
			shape.get_faces()
		
		
		
		if contactPoint != Vector3():
			$Pointer.visible = true
		$Pointer.global_transform.origin = contactPoint


func _rot_correcter(rot,dir) -> Vector3:
	if rot.dot(dir) > 0:
		rot = -rot
	return rot
