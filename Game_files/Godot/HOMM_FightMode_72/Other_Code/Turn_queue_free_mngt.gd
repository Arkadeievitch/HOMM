
# IN TURN (fin d'étape 2/ Inactive character):
for i in character_number:
	if STATS[i].NUMBER == 0:
		var Dead_name = STATS[i].NAME
		get_child(i).queue_free()
		
		#--------------------------------------------------
		# solution while (!à voir si boucle infinie!)
		while STATS[i].NAME == Dead_name
			print(Dead_name)
		
		retrieveNodes()
		retrieveTweens()
		retrievePriorities()
		Dead_name = ''
		#--------------------------------------------------
		
		# ou bien: 
		character_number -=1
		CHARACTERS.remove(i)
		STATS.remove(i)
		TWEENS.remove(i)
		Priorities.remove(i)
		#--------------------------------------------------
		
# Correction du numéro de tour: 1 tour lorsqu'il y a eu autant d'action que d'unité.
	
		

# IN CHARACTERS (inactive section):
func Character_attacked(Action_position, Tile_position):
	var Damage_taken : int = 0
	var ATTACKER
	
	for i in TURN.character_number:
		if TURN.CHARACTERS[i].active_turn == true:
			ATTACKER = TURN.CHARACTERS[i].get_node("icon/Stats")
				
	if (active_turn == false && ATTACKER.SIDE != STATS.SIDE 
	&& abs(Action_position.x - self.global_position.x) <= 32
	&& abs(Action_position.y - self.global_position.y) <= 32):
		print(STATS.NAME, " is attacked")
		Damage_taken = ATTACKER.DAMAGE * ATTACKER.NUMBER
		
		STATS.TakeDamage(Damage_taken)
		STATS.UpdateNumberFromHP()
		
		if STATS.NUMBER > 1:
			print(STATS.NUMBER, " members left in ", STATS.NAME, " unit")
		else:
			print(STATS.NUMBER, " ", STATS.NAME, " left")
			
# add a signal "end of processing" to wait for in Turn?
# problème du minotaure: vampire disparait avant qu'il cherche l'attaquant parmi les personnages
# (même s'il n'en est pas la cible). Avec cette méthode, si Turn est à jour, lui aussi.

# A rajouter dans Stats : Player(human/AI), Ranged(true/false).