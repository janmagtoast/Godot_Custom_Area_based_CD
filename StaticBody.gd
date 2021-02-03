extends StaticBody


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		global_transform.origin = Vector3()
