extends MeshInstance3D

func recoil():
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position:z", 0.5, 0.1);
	var chain = tween.chain();
	tween.tween_property(self, "position:z", 0, 0.3);
	
