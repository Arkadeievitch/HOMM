extends Node2D

# player1 stats
var nom_player1 = "squelette"
var hp_creature_player1 = 3
var number_player1 = 3
var hp_player1 = number_player1*hp_creature_player1
var init_player1 = 1
var mort_ou_vif_player1 = true
var dmg_player1 = 1

# player2 stats
var nom_player2 = "péon"
var hp_creature_player2 = 3
var number_player2 = 3
var hp_player2 = number_player1*hp_creature_player1
var init_player2 = 2
var mort_ou_vif_player2 = true
var dmg_player2 = 1

func _ready():				# démarrage du jeu

	var all_names = []
	var all_init = []
	var all_number = []
	var all_players = [all_names, all_init, all_number]
	
	print("_")
	print(nom_player1)
	print("hp = ",hp_player1)
	print("initiative: ",init_player1)
	
	print("_")
	print(nom_player2)
	print("hp = ",hp_player2)
	print("initiative: ",init_player2)
	
	pass

func _process(delta): 		# invoquée à chaque frame	
	pass

		
func kill():
	if mort_ou_vif_player1 == false: print("squelette est mort")
	if mort_ou_vif_player2 == false: print("péon est mort")