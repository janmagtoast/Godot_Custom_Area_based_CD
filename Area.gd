extends Area


func _physics_process(_delta):
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
		var colScale = colShape.global_transform.basis.get_scale()
		
		var moveDir = Vector3(1,0,0).normalized() #placeholder
		var lastPos = Vector3(-2,0,0) #placeholder
		
		var contactPoint = Vector3()
	
	
		if shape is ConcavePolygonShape:
			shape.get_faces()
		
		
		elif shape is CapsuleShape:
			rot = rot.z
			rot = _rot_correcter(rot,moveDir)
			contactPoint = colScale.x * (rot.normalized()*shape.get_height()*0.5 - moveDir*shape.get_radius()) + pos
		
		
		elif shape is BoxShape:
			rot = rot.x
			var ext = shape.get_extents() * colScale
			var compare := Vector3(1,0,0)
			var boxAngle = compare.angle_to(rot)
			var boxDir = compare.cross(rot).normalized()
			
			var corners := [Vector3(1,1,1),Vector3(1,1,-1),Vector3(1,-1,1),Vector3(1,-1,-1),Vector3(-1,1,1),Vector3(-1,1,-1),Vector3(-1,-1,1),Vector3(-1,-1,-1)]
			var actualCorners :PoolVector3Array = []
			for b in corners.size():
				contactPoint = (corners[b] * ext).rotated(boxDir,boxAngle) + pos
				actualCorners.append(contactPoint)
		
		
		elif shape is SphereShape:
			contactPoint = -moveDir*shape.get_radius()*colScale.x + pos
			#fix stuff, check point position ...
		
		
		elif shape is CylinderShape:
			rot = rot.y
			rot = _rot_correcter(rot,moveDir)
			var cylinderLid = rot.rotated(moveDir.cross(rot).normalized(),PI/2)
			contactPoint = rot.normalized()*shape.get_height()*0.5*colScale.y + cylinderLid.normalized()*shape.get_radius()*colScale.x + pos
		
		
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
