extends Node

@export var health_component: Node
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial
@export var shake_magnitude: float = 5.0  # Define a magnitude para o movimento de "shake"

var hit_flash_tween: Tween
var shake_tween: Tween

func _ready():
	health_component.health_changed.connect(on_health_changed)
	sprite.material = hit_flash_material

func on_health_changed():
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	if shake_tween != null and shake_tween.is_valid():
		shake_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	shake_tween = create_tween()
	
	# Flash effect
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.25)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	# Change color to red and then back to white
	hit_flash_tween.tween_property(sprite, "modulate", Color(1, 0, 0, 1), 0.1)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	hit_flash_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.1).set_delay(0.1)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	# Shake position
	var original_position = sprite.position
	shake_tween.tween_property(sprite, "position", original_position + Vector2(shake_magnitude, 0), 0.05)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	shake_tween.tween_property(sprite, "position", original_position - Vector2(shake_magnitude, 0), 0.05).set_delay(0.05)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	shake_tween.tween_property(sprite, "position", original_position, 0.05).set_delay(0.1)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
