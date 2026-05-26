extends CharacterBody3D

# --- Existing Sprint 1 constants (DO NOT CHANGE) ---
const WALK_SPEED      := 5.0   # m/s
const RUN_SPEED       := 9.0   # m/s
const JUMP_VELOCITY   := 6.0   # m/s
const GRAVITY         := 20.0  # m/s^2
const GROUND_ACCEL    := 40.0  # m/s^2
const GROUND_FRICTION := 30.0  # m/s^2
const AIR_CONTROL     := 8.0   # m/s^2

# --- Sprint 2: wall-run constants ---
const WALL_RUN_GRAVITY_SCALE    := 0.15   # fraction of GRAVITY applied while wall-running
const WALL_RUN_SLIDE_SPEED_MAX  := 2.0    # m/s — max downward speed while wall-running
const WALL_MIN_SPEED            := 3.0    # m/s — min horizontal speed to initiate wall-run
const WALL_EXIT_SPEED           := 2.0    # m/s — fall off wall below this horizontal speed
const WALL_RUN_MAX_TIME         := 2.5    # s   — hard cap per D-017
const WALL_RAY_LENGTH           := 0.65   # m   — capsule radius 0.4 + 0.25 clearance
const WALL_RUN_REATTACH_DELAY   := 0.1    # s   — min airborne time before wall-run can trigger
const WALL_FRICTION             := 3.5    # m/s^2 — horizontal speed bleed while wall-running

# --- State ---
enum State { GROUND, AIR, WALL_RUN }
var _state := State.GROUND

# --- Wall-run tracking ---
var _wall_run_timer               := 0.0
var _wall_run_dir                 := Vector3.ZERO
var _wall_normal                  := Vector3.ZERO
var _was_grounded_since_wall_run  := true
var _time_since_left_floor        := 0.0

# --- Node refs ---
@onready var yaw_pivot:  Node3D   = $YawPivot
@onready var ray_left:   RayCast3D = $RayLeft
@onready var ray_right:  RayCast3D = $RayRight

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
	# Update raycasts to track yaw-left and yaw-right each frame
	var cam_basis := yaw_pivot.global_transform.basis
	ray_left.target_position  = -cam_basis.x * WALL_RAY_LENGTH
	ray_right.target_position =  cam_basis.x * WALL_RAY_LENGTH

	match _state:
		State.GROUND:
			_physics_ground(delta)
		State.AIR:
			_physics_air(delta)
		State.WALL_RUN:
			_physics_wall_run(delta)

	move_and_slide()

	# Post-slide state transitions: landing
	if _state == State.AIR or _state == State.WALL_RUN:
		if is_on_floor():
			_set_state(State.GROUND)


# ---------------------------------------------------------------------------
# GROUND — identical to Sprint 1 logic
# ---------------------------------------------------------------------------
func _physics_ground(delta: float) -> void:
	# Gravity: none on floor
	# Jump
	if _jump_requested:
		velocity.y = JUMP_VELOCITY
		_jump_requested = false
		_set_state(State.AIR)
		return

	_jump_requested = false

	# Horizontal movement (exact Sprint 1 logic)
	var dir_x := float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A))
	var dir_z := float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	var input_dir := Vector2(dir_x, dir_z)
	if input_dir.length_squared() > 1.0:
		input_dir = input_dir.normalized()

	var direction := cam_basis_horizontal() * Vector3(input_dir.x, 0.0, input_dir.y)
	direction.y = 0.0
	if direction.length_squared() > 0.0:
		direction = direction.normalized()

	var speed := RUN_SPEED if Input.is_key_pressed(KEY_SHIFT) else WALK_SPEED

	if direction.length_squared() > 0.0:
		velocity.x = move_toward(velocity.x, direction.x * speed, GROUND_ACCEL * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, GROUND_ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, GROUND_FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0.0, GROUND_FRICTION * delta)

	# Fall off edge
	if not is_on_floor():
		_set_state(State.AIR)


# ---------------------------------------------------------------------------
# AIR — identical to Sprint 1 logic + wall-run check
# ---------------------------------------------------------------------------
func _physics_air(delta: float) -> void:
	_time_since_left_floor += delta
	_jump_requested = false  # jump buffering not used in air

	# Gravity (exact Sprint 1)
	velocity.y -= GRAVITY * delta

	# Horizontal air control (exact Sprint 1)
	var dir_x := float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A))
	var dir_z := float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	var input_dir := Vector2(dir_x, dir_z)
	if input_dir.length_squared() > 1.0:
		input_dir = input_dir.normalized()

	var direction := cam_basis_horizontal() * Vector3(input_dir.x, 0.0, input_dir.y)
	direction.y = 0.0
	if direction.length_squared() > 0.0:
		direction = direction.normalized()

	var speed := RUN_SPEED if Input.is_key_pressed(KEY_SHIFT) else WALK_SPEED
	velocity.x = move_toward(velocity.x, direction.x * speed, AIR_CONTROL * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, AIR_CONTROL * delta)

	# Wall-run initiation check
	_check_wall_run_initiation()


# ---------------------------------------------------------------------------
# WALL_RUN
# ---------------------------------------------------------------------------
func _physics_wall_run(delta: float) -> void:
	_wall_run_timer += delta

	# Reduced gravity with downward cap
	velocity.y -= GRAVITY * WALL_RUN_GRAVITY_SCALE * delta
	velocity.y = max(velocity.y, -WALL_RUN_SLIDE_SPEED_MAX)

	# Correction A: bleed horizontal speed along wall
	var h_speed := Vector2(velocity.x, velocity.z).length()
	h_speed = move_toward(h_speed, 0.0, WALL_FRICTION * delta)
	velocity.x = _wall_run_dir.x * h_speed
	velocity.z = _wall_run_dir.z * h_speed

	# Jump-off exit
	if _jump_requested:
		_jump_requested = false
		velocity.y = JUMP_VELOCITY
		_set_state(State.AIR)
		return

	_jump_requested = false

	# Exit conditions
	var still_on_wall := (ray_left.is_colliding() and _wall_side_left()) \
		or (ray_right.is_colliding() and not _wall_side_left())
	if _wall_run_timer >= WALL_RUN_MAX_TIME \
			or h_speed < WALL_EXIT_SPEED \
			or not still_on_wall:
		_set_state(State.AIR)


# ---------------------------------------------------------------------------
# Wall-run initiation (Correction B)
# ---------------------------------------------------------------------------
func _check_wall_run_initiation() -> void:
	if not _was_grounded_since_wall_run:
		return
	if _time_since_left_floor < WALL_RUN_REATTACH_DELAY:
		return

	var h_vel := Vector3(velocity.x, 0.0, velocity.z)
	if h_vel.length() < WALL_MIN_SPEED:
		return

	var hit_ray: RayCast3D = null
	if ray_left.is_colliding():
		hit_ray = ray_left
	elif ray_right.is_colliding():
		hit_ray = ray_right
	if hit_ray == null:
		return

	var raw_normal := hit_ray.get_collision_normal()
	if abs(raw_normal.y) >= 0.3:
		return  # not a vertical wall

	var wall_normal_h := Vector3(raw_normal.x, 0.0, raw_normal.z).normalized()
	var along := wall_normal_h.cross(Vector3.UP).normalized()
	var h_vel_norm := h_vel.normalized()

	# Must be moving INTO the wall
	if h_vel_norm.dot(-wall_normal_h) < 0.2:
		return

	# Must have a clear along-wall component (Correction B: reject dead-on hits)
	var along_dot := h_vel_norm.dot(along)
	if abs(along_dot) < 0.15:
		return

	_wall_run_dir = along * sign(along_dot)
	_wall_normal  = wall_normal_h
	_set_state(State.WALL_RUN)


# ---------------------------------------------------------------------------
# Helper: which side triggered the wall-run
# ---------------------------------------------------------------------------
var _wall_started_on_left := false

func _wall_side_left() -> bool:
	return _wall_started_on_left


# ---------------------------------------------------------------------------
# State setter
# ---------------------------------------------------------------------------
func _set_state(new_state: State) -> void:
	match new_state:
		State.GROUND:
			_was_grounded_since_wall_run = true
			_time_since_left_floor = 0.0
		State.AIR:
			if _state == State.GROUND:
				_time_since_left_floor = 0.0
		State.WALL_RUN:
			_wall_run_timer = 0.0
			_wall_started_on_left = ray_left.is_colliding()
	_state = new_state


# ---------------------------------------------------------------------------
# Helper: yaw-pivot camera basis (horizontal plane only)
# ---------------------------------------------------------------------------
func cam_basis_horizontal() -> Basis:
	return yaw_pivot.global_transform.basis
