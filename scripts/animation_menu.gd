extends Control


@onready var main: Node2D = $".."
@onready var main_animation: AnimatedSprite2D = $"../MainAnimation"


@onready var animation_menu: Control = $"."
@onready var menu: Control = $"../Menu"

@onready var black_hole: CheckBox = $PanelContainer/Panel/MarginContainer/VBoxContainer/BlackHole
@onready var gas_giant: CheckBox = $PanelContainer/Panel/MarginContainer/VBoxContainer/GasGiant
@onready var star: CheckBox = $PanelContainer/Panel/MarginContainer/VBoxContainer/Star
@onready var dry_planet: CheckBox = $PanelContainer/Panel/MarginContainer/VBoxContainer/DryPlanet

var animation_button_group = ButtonGroup.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	black_hole.button_group = animation_button_group
	gas_giant.button_group = animation_button_group
	star.button_group = animation_button_group
	dry_planet.button_group = animation_button_group
	
	animation_button_group.pressed.connect(_on_animation_button_pressed)
	play_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_animation_button_pressed(button : BaseButton):
	#print(button.name)
	if button.name == "BlackHole":
		GameManager.current_animation = GameManager.AnimationType.BlackHole
		print(GameManager.current_animation)
		play_animation()
		GameManager.save_settings()
		menu.hide()
		animation_menu.hide()
		
	
	if button.name == "GasGiant":
		GameManager.current_animation = GameManager.AnimationType.GasGiant
		print(GameManager.current_animation)
		play_animation()
		GameManager.save_settings()
		menu.hide()
		animation_menu.hide()
	
	if button.name == "Star":
		GameManager.current_animation = GameManager.AnimationType.Star
		print(GameManager.current_animation)
		play_animation()
		GameManager.save_settings()
		menu.hide()
		animation_menu.hide()
		
	if button.name == "DryPlanet":
		GameManager.current_animation = GameManager.AnimationType.DryPlanet
		print(GameManager.current_animation)
		play_animation()
		GameManager.save_settings()
		menu.hide()
		animation_menu.hide()

func _on_back_pressed() -> void:
	animation_menu.hide()
	
func play_animation():
	if GameManager.current_animation == GameManager.AnimationType.BlackHole:
		main_animation.play("BlackHole")
		
	if GameManager.current_animation == GameManager.AnimationType.GasGiant:
		main_animation.play("GasGiant")
		
	if GameManager.current_animation == GameManager.AnimationType.Star:
		main_animation.play("Star")
		
	if GameManager.current_animation == GameManager.AnimationType.DryPlanet:
		main_animation.play("DryPlanet")
