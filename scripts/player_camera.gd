extends Node3D

const MOUSE_SENSITIVITY := 0.002
const PITCH_MIN         := -1.0472  # -60 degrees
const PITCH_MAX         :=  0.5236  #  30 degrees

@onready var pitch_pivot: Node3D = $PitchPivot


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y            -= event.relative.x * MOUSE_SENSITIVITY
		pitch_pivot.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		pitch_pivot.rotation.x  = clamp(pitch_pivot.rotation.x, PITCH_MIN, PITCH_MAX)
