extends Area


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_make_readable()

func _make_readable():
	var body = self.get_overlapping_bodies()
	var mdt = MeshDataTool.new()
	for i in body.size():
		var colShape = body[i].get_child(0)
		var shape = colShape.get_shape()
		var pos = colShape.global_transform.origin
		var rot = colShape.global_transform.basis
		
		var moveDir = Vector3(1,0,0).normalized() #placeholder
		
		var contactPoint = Vector3()
	
	
		if shape is ConcavePolygonShape:
			shape.get_faces()
		
		elif shape is CapsuleShape:
			rot = rot.z
			rot = _rot_correcter(rot,moveDir)
			contactPoint = (rot * shape.get_height()*0.5) + (-moveDir * shape.get_radius()) + pos
		
		elif shape is BoxShape:
			contactPoint = pos
			print(shape.get_extents()*0.5)
		
		elif shape is SphereShape:
			contactPoint = -moveDir * shape.get_radius() + pos
			#fix stuff, check point position ...
		
		elif shape is CylinderShape:
			rot = rot.y
			rot = _rot_correcter(rot,moveDir)
			var replacethisstoopidfunction = -moveDir.rotated(moveDir.cross(rot).normalized(),cos(rot.dot(Vector3.UP)))
			contactPoint = rot * shape.get_height()*0.5 + replacethisstoopidfunction * shape.get_radius() + pos
		
		elif shape is HeightMapShape:
			pass
		
		elif shape is ConvexPolygonShape:
			shape.get_faces()
		
		
		if contactPoint != Vector3():
			$Pointer.visible = true
		$Pointer.global_transform.origin = contactPoint
		#var world = get_world().direct_space_state


func _rot_correcter(rot,dir) -> Vector3:
	if rot.dot(dir) > 0:
		rot = -rot
	return rot
