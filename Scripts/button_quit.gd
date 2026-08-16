extends Button

# Store a reference to the gradient inside the hover StyleBox
var hover_gradient: GradientTexture2D
var tween: Tween

func _ready() -> void:
	# Retrieve the StyleBoxTexture assigned to the Hover state
	var hover_stylebox = get_theme_stylebox("hover") as StyleBoxTexture
	
	if hover_stylebox and hover_stylebox.texture is GradientTexture2D:
		hover_gradient = hover_stylebox.texture
	
	# Connect the hover signals to trigger the animation
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if not hover_gradient: return
	
	# Kill any existing tween to prevent conflicting animations
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween().set_parallel(true)
	# Smoothly slide the gradient positioning "into" view
	tween.tween_property(hover_gradient, "fill_from", Vector2(0.5, 0.5), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(hover_gradient, "fill_to", Vector2(0.5, 0.0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	if not hover_gradient: return
	
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween().set_parallel(true)
	# Smoothly slide the gradient positioning "out" of view
	tween.tween_property(hover_gradient, "fill_from", Vector2(0.5, -0.5), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(hover_gradient, "fill_to", Vector2(0.5, 0.0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
