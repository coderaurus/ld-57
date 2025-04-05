extends State
class_name PlayerStatePickup

@onready var area: Area2D = $Area
@onready var player: Player = $"../.."

func enter(parameters = []):
	pass

func exit():
	pass

func update(_delta: float):
	if area.has_overlapping_bodies():
		for b in area.get_overlapping_bodies():
			if b is Jumpable and b.can_be_picked:
				b.picked_up()
				player.get_pickup()
				transitioned.emit(self, "idle")

func physics_update(_delta: float):
	pass

func can_pickup() -> bool:
	if area.has_overlapping_bodies():
		return true
	return false


func _on_area_body_entered(body: Node2D) -> void:
	print("!! %s entered pickup area" % body.name)
