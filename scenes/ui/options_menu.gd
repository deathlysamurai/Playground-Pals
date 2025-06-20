extends CanvasLayer

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var window_button: Button = %WindowButton
@onready var back_button: Button = %BackButton


func _ready() -> void:
	music_slider.value_changed.connect(on_volume_slider_changed.bind("Music"))
	sfx_slider.value_changed.connect(on_volume_slider_changed.bind("SFX"))
	window_button.pressed.connect(on_window_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	music_slider.grab_focus()
	
	update_display()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		queue_free()


func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	music_slider.value = get_bus_volume_percent("Music")
	sfx_slider.value = get_bus_volume_percent("SFX")


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	return AudioServer.get_bus_volume_linear(bus_index)


func set_bus_volume_percent(value: float, bus_name: String) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_linear(bus_index, value)


func on_volume_slider_changed(value: float, bus_name: String) -> void:
	set_bus_volume_percent(value, bus_name)


func on_window_button_pressed() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	update_display()


func on_back_button_pressed() -> void:
	queue_free()
