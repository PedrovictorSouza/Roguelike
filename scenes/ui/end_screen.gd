extends CanvasLayer

@onready var panel_container = $%PanelContainer
@onready var defeat_timer = Timer.new()
var is_defeated = false

func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	$%ContinueButton.pressed.connect(on_continue_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)
	
	add_child(defeat_timer)
	defeat_timer.one_shot = true
	defeat_timer.wait_time = 0.5


func set_defeat():
	if is_defeated:
		return 
		
	is_defeated = true
	$%TitleLabel.text = "Defeat"
	$%DescriptionLabel.text = "You lost!"
	play_jingle(true)
	
	get_tree().paused = true  # Congela o jogo
	defeat_timer.start()
	await defeat_timer.timeout
	
	show_game_over_screen()


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()


func on_continue_button_pressed():
	close_game_over_screen()


func on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func show_game_over_screen():
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	$%ContinueButton.pressed.connect(on_continue_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)


func close_game_over_screen():
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()
