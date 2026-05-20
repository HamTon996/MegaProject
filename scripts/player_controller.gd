extends CharacterBody3D

const WALK_SPEED    := 5.0
const RUN_SPEED     := 9.0
const JUMP_VELOCITY := 6.0
const GRAVITY       := 20.0
const GROUND_ACCEL  := 40.0
const GROUND_FRICTION := 30.0
const AIR_CONTROL   := 8.0

@onready var yaw_pivot: Node3D = $YawPivot

var _jump_requested := false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.echo:
		if event.physical_keycode == KEY_SPACE and event.pressed:
			_jump_requested = true
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if _jump_requested:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		_jump_requested = false

	var dir_x := float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A))
	var dir_z := float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	var input_dir := Vector2(dir_x, dir_z)
	if input_dir.length_squared() > 1.0:
		input_dir = input_dir.normalized()

	var cam_basis    := yaw_pivot.global_transform.basis
	var direction    := cam_basis * Vector3(input_dir.x, 0.0, input_dir.y)
	direction.y = 0.0
	if direction.length_squared() > 0.0:
		direction = direction.normalized()

	var speed := RUN_SPEED if Input.is_key_pressed(KEY_SHIFT) else WALK_SPEED

	if is_on_floor():
		if direction.length_squared() > 0.0:
			velocity.x = move_toward(velocity.x, direction.x * speed, GROUND_ACCEL * delta)
			velocity.z = move_toward(velocity.z, direction.z * speed, GROUND_ACCEL * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, GROUND_FRICTION * delta)
			velocity.z = move_toward(velocity.z, 0.0, GROUND_FRICTION * delta)
	else:
		velocity.x = move_toward(velocity.x, direction.x * speed, AIR_CONTROL * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, AIR_CONTROL * delta)

	move_and_slide()
