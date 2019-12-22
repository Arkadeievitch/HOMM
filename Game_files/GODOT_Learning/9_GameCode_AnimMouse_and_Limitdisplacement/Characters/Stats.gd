extends Node

export var MAX_HP : int
export var NUMBER : int

export var DAMAGE : int
export var DISPLACEMENT : int
export var INITIATIVE : int

func _ready():
	if MAX_HP == 0:
		print("Dead Character")
	if NUMBER == 0:
		print("Dead Character")
	if DAMAGE == 0:
		pass
	if DISPLACEMENT == 0:
		print("Character can't move")
	if INITIATIVE == 0:
		print("Initiative =  0 : Character will never play")
