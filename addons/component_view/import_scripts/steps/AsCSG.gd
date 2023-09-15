@tool
extends "../ImportStep.gd"


func post_process(child:Node3D):
	var csg = CSGMesh.new()
	csg.mesh = child.mesh
	child.queue_free()
	return csg
