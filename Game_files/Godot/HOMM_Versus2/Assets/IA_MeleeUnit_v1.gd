extends Position2D
#=============================================
func IA():
	var chosenTile
	var chosenTarget
	
	# Liste des ennemis, des cases générées et sélection des ennemis à portée.
	temp_Array = []
	temp_Array = retrieveEnemies()
	var onMapEnemies = 			temp_Array[0]
	var onMapEnemies_number = 	temp_Array[1]
	var onMapEnemies_counters = temp_Array[2]
#	var onMapEnemies_scores = 	temp_Array[3]
	print("IA Spotted ", onMapEnemies_number, " enemies on map.")
	
	temp_Array = []
	temp_Array = retrieveTiles()
	var Tiles = 		temp_Array[0]
	var Tiles_number = 	temp_Array[1]
	print("IA Generated ", Tiles_number, " Tiles.")
	
	temp_Array = []
	temp_Array = retrieveOnRangeEnemies(Tiles, Tiles_number, 
										onMapEnemies, onMapEnemies_number, onMapEnemies_counters)
	var onRangeEnemies = 			temp_Array[0]
	var onRangeEnemies_number =		temp_Array[1]
	var onRangeEnemies_counters = 	temp_Array[2]
	print("IA Spotted ", onRangeEnemies_number, " enemies at range.")
	
	var Tiles_scores
	if onRangeEnemies_number > 0 :
		# S'il y a des ennemis à portée, on choisit le plus intéressant à attaquer 
		# et la tuile qui permettra de minimiser les risques de se faire attaquer.
		temp_Array = []
		temp_Array = scoreOnRangeEnemies(onRangeEnemies, onRangeEnemies_number, onRangeEnemies_counters)
		var onRangeEnemies_scores = temp_Array
		
		temp_Array = []
		temp_Array = chooseTarget(onRangeEnemies, onRangeEnemies_scores, onRangeEnemies_number)
		var chosenTarget = temp_Array
		print("IA - Attacking ", chosenTarget, " position")
		
		temp_Array = []
		temp_Array = selectTiles(chosenTarget, Tiles, Tiles_number)
		Tiles = 		temp_Array[0]
		Tiles_number = 	temp_Array[1]
		print("IA - ", Tiles_number, " tiles selected")
		
		temp_Array = []
		temp_Array = scoreAttackTiles(Tiles, Tiles_number, 
								onMapEnemies, onMapEnemies_number)
		Tiles_scores = temp_Array
	else:
		# S'il n'y a pas d'ennemi à portée, on choisit la tuile qui permettra l'attaque au tour suivant.
#		temp_Array = []
#		temp_Array = scoreEnemies(onMapEnemies, onMapEnemies_number, onMapEnemies_counters)
#		onMapEnemies_scores = temp_Array
		
		temp_Array = []
		temp_Array = scoreTiles(Tiles, Tiles_number, 
								onMapEnemies, onMapEnemies_number)
		Tiles_scores = temp_Array
		
	temp_Array = []
	temp_Array = chooseTile(Tiles, Tiles_number, Tiles_scores)
	var chosenTile = temp_Array
	
	return [chosenTile, chosenTarget]
#=============================================

func retrieveEnemies():
	var onMapEnemies = 			[]
	var onMapEnemies_number : 	int = 0
	var onMapEnemies_counters = []
	var onMapEnemies_scores = 	[]
	
	var TURN = get_node("/root/MainNode/Battlefield/Turn")
	var selfSide = get_parent().get_node("icon/Stats").SIDE
	
	var j : int = 0
	for i in TURN.get_child_count():
		if TURN.get_child(i).get_node("icon/Stats").SIDE != selfSide:
			onMapEnemies.append(0)
			onMapEnemies[j] = TURN.get_child(i)
			onMapEnemies_number +=1
			onMapEnemies_counters.append(0)
			onMapEnemies_counters[j] = onMapEnemies[j].get_node("icon/Stats").NUMBER
			onMapEnemies_scores.append(0)
			j += 1
	
	return [onMapEnemies, onMapEnemies_number, onMapEnemies_counters, onMapEnemies_scores]
	
func retrieveTiles():
	var TEMPORARY = get_parent().get_node("Temporary")
	
	var Tiles = 		[]
	var Tiles_number : 	int = TEMPORARY.get_child_count()
	
	for i in Tiles_number:
		Tiles.append(0)
		Tiles[i] = TEMPORARY.get_child(i)
	
	return [Tiles, Tiles_number]

func retrieveOnRangeEnemies(Tiles, Tiles_number, 
							onMapEnemies, onMapEnemies_number, onMapEnemies_counters):
	var onRangeEnemies = 			[]
	var onRangeEnemies_number : 	int = 0
	var onRangeEnemies_counters = 	[]
	
	var k = 0
	for i in onMapEnemies_number:
		for j in Tiles_number:
			var delta_x = abs(onMapEnemies[i].global_position.x - Tiles[j].global_position.x)
			var delta_y = abs(onMapEnemies[i].global_position.y - Tiles[j].global_position.y)
			if (delta_x <= 64
			 && delta_y <= 64):
				onRangeEnemies.append(0)
				onRangeEnemies[k] = onMapEnemies[i]
				onRangeEnemies_number +=1
				onRangeEnemies_counters.append(0)
				onRangeEnemies_counters[k] = onMapEnemies_counters[i]
				k += 1
				break
	
	return [onRangeEnemies, onRangeEnemies_number, onRangeEnemies_counters]

func scoreOnRangeEnemies(onRangeEnemies, onRangeEnemies_number, onRangeEnemies_counters):
	var onRangeEnemies_scores = 	[]
	for i in onRangeEnemies.size():
		onRangeEnemies_scores.append(0) 

	if onRangeEnemies_number > 0:
		var Highest_EnemyDMGER = 0
		var Lowest_EnemyDMGER = 0
		var Highest_EnemyDMG = 0
		var Lowest_EnemyDMG = 1000000000
		
		var DISPLACEMENT = get_parent().get_node("icon/Stats").DISPLACEMENT
			
		for i in onRangeEnemies_number:
			if (abs(onRangeEnemies[i].global_position.x - self.global_position.x) <= 64*DISPLACEMENT
			&& abs(onRangeEnemies[i].global_position.y - self.global_position.y) <= 64*DISPLACEMENT):
				onRangeEnemies_scores[i] += 3
			# score ranged enemies			
			if onRangeEnemies[i].get_node("icon/Stats").RANGED == true:
				onRangeEnemies_scores[i] += 2
				
			# score highest and lowest enemy damages
			var Enemy_dmg = onRangeEnemies[i].get_node("icon/Stats").DAMAGE *onRangeEnemies_counters[i]
			if i > 0:
				if Enemy_dmg > Highest_EnemyDMG:
					Highest_EnemyDMG = Enemy_dmg
					Highest_EnemyDMGER = i
				if Enemy_dmg < Lowest_EnemyDMG:
					Lowest_EnemyDMG = Enemy_dmg
					Lowest_EnemyDMGER = i
			else:
				Highest_EnemyDMG = Enemy_dmg
				Lowest_EnemyDMG = Enemy_dmg
					
		onRangeEnemies_scores[Highest_EnemyDMGER] += 3
		onRangeEnemies_scores[Lowest_EnemyDMGER] -= 3
	
	return onRangeEnemies_scores

func chooseTarget(onRangeEnemies, onRangeEnemies_scores, onRangeEnemies_number):
	var chosenTarget : Vector2
	var STATS = get_parent().get_node("icon/Stats")
	
	var highest_score : int = -10
	var chosenIndex : int = 0
	if onRangeEnemies_number > 0:
		for i in onRangeEnemies_number:
			if i > 0:
				if onRangeEnemies_scores[i] > highest_score:
					chosenTarget = onRangeEnemies[i].global_position
					highest_score = onRangeEnemies_scores[i]
					chosenIndex = i
		print(STATS.NAME, " attacks ", onRangeEnemies[chosenIndex].get_node("icon/Stats").NAME)
	else:
		chosenTarget = Vector2(0, 0)
		print("No enemy at ", STATS.NAME, " range.")
	
	return chosenTarget
	
func selectTiles(chosenTarget, Tiles, Tiles_number):
	
	var temp_Tiles = 		[]
	var temp_Tiles_number : int = 0
	
	var j : int = 0
	for i in Tiles_number: 
		if( abs(Tiles[i].global_position.x - chosenTarget.x) <=64
		&& abs(Tiles[i].global_position.y - chosenTarget.y) <=64):
			temp_Tiles.append(0)
			temp_Tiles[j] = Tiles[i]
			j+=1
			temp_Tiles_number += 1
	
	Tiles = 		temp_Tiles
	Tiles_number = 	temp_Tiles_number
	
	if Tiles_number > 8:
		print("==!!! There is a mistake in the AI - selectTiles function:")
	print(Tiles_number, " tiles selected")
	
	return [Tiles, Tiles_number]

func scoreAttackTiles(Tiles, Tiles_number, 
					onMapEnemies, onMapEnemies_number):
	var Tiles_scores = []
	for i in Tiles.size():
		Tiles_scores.append(0) 
	
	if Tiles_number > 0:
	# Si ennemis à portée, on cherche la tuile d'attaque qui ne met pas à portée d'autres ennemis.
		for i in Tiles_number:
			Tiles_scores[i] = 4
			
			for j in onMapEnemies_number:
				var Enemy_Displacement = 64*(onMapEnemies[j].get_node("icon/Stats").DISPLACEMENT+1)
				var delta_x = abs(Tiles[i].global_position.x - onMapEnemies[j].global_position.x)/64
				var delta_y	= abs(Tiles[i].global_position.y - onMapEnemies[j].global_position.y)/64
				
				if ( (delta_x <= Enemy_Displacement && delta_y <= Enemy_Displacement )
				|| (delta_x <= Enemy_Displacement && delta_y == Enemy_Displacement+1)
				|| (delta_x == Enemy_Displacement+1 && delta_y <= Enemy_Displacement )):
					Tiles_scores[i] -= 2
	return Tiles_scores

func scoreEnemies(onMapEnemies, onMapEnemies_number, onMapEnemies_counters):
	var onMapEnemies_scores = 	[]
	var DISPLACEMENT = get_parent().get_node("icon/Stats").DISPLACEMENT

	if onMapEnemies_number > 0:
		var Highest_EnemyDMGER = 0
		var Lowest_EnemyDMGER = 0
		var Highest_EnemyDMG = 0
		var Lowest_EnemyDMG = 1000000000
		
		for i in onMapEnemies_number:
			onMapEnemies_scores.append(0)
			if (abs(onMapEnemies[i].global_position.x - self.global_position.x) <= 64*DISPLACEMENT
			&& abs(onMapEnemies[i].global_position.y - self.global_position.y) <= 64*DISPLACEMENT):
				onMapEnemies_scores[i] += 3
			# score ranged enemies			
			if onMapEnemies[i].get_node("icon/Stats").RANGED == true:
				onMapEnemies_scores[i] += 2
				
			# score highest and lowest enemy damages
			var Enemy_dmg = onMapEnemies[i].get_node("icon/Stats").DAMAGE *onMapEnemies_counters[i]
			if i > 0:
				if Enemy_dmg > Highest_EnemyDMG:
					Highest_EnemyDMG = Enemy_dmg
					Highest_EnemyDMGER = i
				if Enemy_dmg < Lowest_EnemyDMG:
					Lowest_EnemyDMG = Enemy_dmg
					Lowest_EnemyDMGER = i
			else:
				Highest_EnemyDMG = Enemy_dmg
				Lowest_EnemyDMG = Enemy_dmg
					
		onMapEnemies_scores[Highest_EnemyDMGER] += 3
		onMapEnemies_scores[Lowest_EnemyDMGER] -= 3
	
	return onMapEnemies_scores
	
func scoreTiles(Tiles, Tiles_number, 
				onMapEnemies, onMapEnemies_number):
	var Tiles_scores = []
	for i in Tiles.size():
		Tiles_scores.append(0) 
	
	var DISPLACEMENT = get_parent().get_node("icon/Stats").DISPLACEMENT
	# S'il n'y a pas d'ennemi à portée, on cherche la tuile la plus intéressante pour le prochain tour.
	for i in Tiles_number:
		var CurrentTilePosition = Tiles[i].global_position
		# On cherche les tuiles qui permettent d'attaquer au tour suivant le plus d'ennemis possibles.
		for j in onMapEnemies_number:
			var delta_x = abs(CurrentTilePosition.x - onMapEnemies[j].global_position.x)/64
			var delta_y	= abs(CurrentTilePosition.y - onMapEnemies[j].global_position.y)/64
		
			if ( (delta_x <= DISPLACEMENT && delta_y <= DISPLACEMENT )
			|| (delta_x <= DISPLACEMENT && delta_y == DISPLACEMENT+1)
			|| (delta_x == DISPLACEMENT+1 && delta_y <= DISPLACEMENT )):
				Tiles_scores[i] += 1
	
	return Tiles_scores

func chooseTile(Tiles, Tiles_number, Tiles_scores):
	var chosenTile : Vector2
		
	var highest_score : int = -10
#	var chosenIndex : int = 0
	
	if Tiles_number > 0:
		if Tiles_scores != null:
			for i in Tiles_number:
				if Tiles_scores[i] > highest_score:
					chosenTile = Tiles[i].global_position
					highest_score = Tiles_scores[i]
	#				chosenIndex = i
			print("Moving to ", chosenTile)
		else:
			# Si aucune option ne donne de résultat, le personnage se déplace de (dx=2, dy=1) cases vers le centre.
			for i in Tiles_number:
				if get_viewport().size.x/2-self.global_position.x < 0:
					if get_viewport().size.y/2-self.global_position.y < 0:
						if (abs(Tiles[i].global_position.x +128) < 0.1
						&& abs(Tiles[i].global_position.y +64) < 0.1):
							chosenTile = Tiles[i].global_position
					else:
						if (abs(Tiles[i].global_position.x +128) < 0.1
						&& abs(Tiles[i].global_position.y -64) < 0.1):
							chosenTile = Tiles[i].global_position
				else:
					if get_viewport().size.y/2-self.global_position.y < 0:
						if (abs(Tiles[i].global_position.x -128) < 0.1
						&& abs(Tiles[i].global_position.y +64) < 0.1):
							chosenTile = Tiles[i].global_position
					else:
						if (abs(Tiles[i].global_position.x -128) < 0.1
						&& abs(Tiles[i].global_position.y -64) < 0.1):
							chosenTile = Tiles[i].global_position
			print("No ennemy at range; moving to ", chosenTile)
	else:
		chosenTile = self.global_position
		print("No tile available to move")
	
	return chosenTile