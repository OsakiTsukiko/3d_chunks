extends KinematicBody

const SPEED = 3

onready var r_hz = $r_hz
onready var r_vr = $r_hz/r_vr

func _ready():
	pass
	
func _physics_process(delta):
	var vel = Vector3.ZERO
	if Input.is_action_pressed("ui_left"):
		vel += Vector3(-1, 0, 0)
	if Input.is_action_pressed("ui_right"):
		vel += Vector3(1, 0, 0)
	if Input.is_action_pressed("ui_up"):
		vel += Vector3(0, 0, -1)
	if Input.is_action_pressed("ui_down"):
		vel += Vector3(0, 0, 1)
	if Input.is_action_pressed("ui_y_up"):
		vel += Vector3(0, 1, 0)
	if Input.is_action_pressed("ui_y_down"):
		vel += Vector3(0, -1, 0)
		
	self.translate(vel.normalized() * delta * SPEED)
	
	if Input.is_action_pressed("cam_left"):
		r_hz.rotate_y(-PI/50)
	if Input.is_action_pressed("cam_right"):
		r_hz.rotate_y(PI/50)
	if Input.is_action_pressed("cam_up"):
		r_vr.rotate_x(-PI/50)
	if Input.is_action_pressed("cam_down"):
		r_vr.rotate_x(PI/50)
		
#	print(self.global_transform.origin)
