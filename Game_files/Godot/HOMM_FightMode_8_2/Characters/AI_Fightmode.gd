extends Position2D

var TURN : Node

var TEMPORARY : Node
var STATS : Node

var ALL_TEMPORARY = []
var ALL_STATS = []
var ENEMY_STATS = []

var DISPLACEMENT : int

var Character_number

#==============================================
func AI_Fightmode():
	var Action_target : Vector2
	var Tile_target : Vector2
	
	print("AI playing ---")
	initialize()
	retrieveNodes()
	
	var Enemies = []
	var Enemy_counter : int = 0
	var Enemies_scores = []							# unused yet
	Enemies = 			retrieveEnemies(Enemies, Enemy_counter, Enemies_scores)[0]
	Enemy_counter = 	retrieveEnemies(Enemies, Enemy_counter, Enemies_scores)[1]
	Enemies_scores = 	retrieveEnemies(Enemies, Enemy_counter, Enemies_scores)[2]
	
	var onRange_Enemies = []
	var onRange_Enemy_counter : int = 0
	onRange_Enemies = retrieveOnRangeEnemies(	onRange_Enemies, onRange_Enemy_counter, 
													Enemies, Enemy_counter)[0]
	onRange_Enemy_counter = retrieveOnRangeEnemies(onRange_Enemies, onRange_Enemy_counter, 
													Enemies, Enemy_counter)[1]
	
	var onRange_Enemies_scores = []
	onRange_Enemies_scores = scoreOnRangeEnemies(onRange_Enemies, 
												onRange_Enemies_scores, 
												onRange_Enemy_counter)
	
	Action_target = chooseTarget(Action_target, 
								onRange_Enemy_counter, onRange_Enemies_scores, onRange_Enemies)
	
	Enemies_scores = scoreEnemies(Enemies_scores, Enemy_counter, Enemies) 	# unused yet
	
	var TileList = []
	var Tile_counter : int = 0
	var Tiles_scores = []
	TileList 	 = retrieveTiles(Action_target, TileList, Tiles_scores, Tile_counter, 
								onRange_Enemy_counter)[0] # besoin d'une array intermediaire?
	Tile_counter = retrieveTiles(Action_target, TileList, Tiles_scores, Tile_counter, 
								onRange_Enemy_counter)[1] # besoin d'une array intermediaire?
	Tiles_scores = retrieveTiles(Action_target, TileList, Tiles_scores, Tile_counter, 
								onRange_Enemy_counter)[2] # besoin d'une array intermediaire?
	
	Tiles_scores = scoreTiles(Tiles_scores, Tile_counter, 
								Enemy_counter, Enemies, TileList)[0] # besoin d'une array intermediaire?
	Tile_counter = scoreTiles(Tiles_scores, Tile_counter, 
								Enemy_counter, Enemies, TileList)[1] # besoin d'une array intermediaire?
	
	Tile_target = chooseTile(Tile_target, Tiles_scores, Tile_counter, TileList)
	print("--- AI played")
	
	return [Action_target, Tile_target]
	
#==============================================
func initialize():
	ALL_TEMPORARY = []
	ALL_STATS = []
	ENEMY_STATS = []

func retrieveNodes():
	TURN = get_node("/root/Battlefield/Turn")
	Character_number = TURN.get_child_count()
	#self
	TEMPORARY = get_parent().get_node("Temporary")
	STATS = get_parent().get_node("icon/Stats")
	DISPLACEMENT = STATS.DISPLACEMENT
	#other characters
	for i in Character_number:
		ALL_STATS.append(0)
		ALL_STATS[i] = TURN.get_child(i).get_node("icon/Stats")
		ALL_TEMPORARY.append(0)
		ALL_TEMPORARY[i] = TURN.get_child(i).get_node("Temporary")

func retrieveEnemies(internal_Enemies, internal_Enemy_counter, internal_Enemies_scores):
	var j : int = 0
	for i in Character_number:
		if ALL_STATS[i].SIDE != STATS.SIDE:
			internal_Enemy_counter += 1
			internal_Enemies_scores.append(0)
			
			internal_Enemies.append(0)
			internal_Enemies[j] = TURN.get_child(i)
			
			ENEMY_STATS.append(0)
			ENEMY_STATS[j] = TURN.get_child(i).get_node("icon/Stats")
			j += 1
	return [internal_Enemies, internal_Enemy_counter, internal_Enemies_scores]

func retrieveOnRangeEnemies(internal_onRange_Enemies, 
						internal_onRange_Enemy_counter,
						internal_Enemies, 
						internal_Enemy_counter):
	var j : int = 0
	for i in internal_Enemy_counter:
		if (ENEMY_STATS[i].SIDE != STATS.SIDE
		&& abs(internal_Enemies[i].global_position.x - self.global_position.x) <= DISPLACEMENT+1
		&& abs(internal_Enemies[i].global_position.y - self.global_position.y) <= DISPLACEMENT+1
		&& (abs(internal_Enemies[i].global_position.x) != DISPLACEMENT+1
		|| abs(internal_Enemies[i].global_position.y) != DISPLACEMENT+1)):
			
			internal_onRange_Enemy_counter += 1
			internal_onRange_Enemies.append(0)
			internal_onRange_Enemies[j] = TURN.get_child(i)
			j += 1
			
	return [internal_onRange_Enemies, internal_onRange_Enemy_counter]
	
func scoreOnRangeEnemies(internal_onRange_Enemies, 
						internal_onRange_Enemies_scores, 
						internal_onRange_Enemy_counter):
	if internal_onRange_Enemy_counter > 0:
		var Highest_EnemyDMGER = 0
		var Lowest_EnemyDMGER = 0
		var Highest_EnemyDMG = 0
		var Lowest_EnemyDMG = 1000000000
		
		for i in internal_onRange_Enemy_counter:
			if (abs(internal_onRange_Enemies[i].global_position.x - self.global_position.x) <= DISPLACEMENT
			&& abs(internal_onRange_Enemies[i].global_position.y - self.global_position.y) <= DISPLACEMENT):
				internal_onRange_Enemies_scores[i] += 3
			
			if internal_onRange_Enemies[i].get_node("icon/Stats").Ranged == true:
				internal_onRange_Enemies_scores[i] += 2
			
			var Enemy_dmg = internal_onRange_Enemies[i].get_node("icon/Stats").DAMAGE *internal_onRange_Enemies[i].get_node("icon/Stats").Number
			if i >0:
				if Enemy_dmg > Highest_EnemyDMG:
					Highest_EnemyDMG = Enemy_dmg
					Highest_EnemyDMGER = i
				if Enemy_dmg < Lowest_EnemyDMG:
					Lowest_EnemyDMG = Enemy_dmg
					Lowest_EnemyDMGER = i
			else:
				Highest_EnemyDMG = Enemy_dmg
				Lowest_EnemyDMG = Enemy_dmg
				
		internal_onRange_Enemies_scores[Highest_EnemyDMGER] += 3
		internal_onRange_Enemies_scores[Lowest_EnemyDMGER] -= 3
		
	return internal_onRange_Enemies_scores
	
func chooseTarget(chooseTarget_Action_target, chooseTarget_onRange_Enemy_counter, internal_onRange_Enemies_scores, internal_onRange_Enemies):
	var chosenOne : int = 0
	var highest_score = internal_onRange_Enemies_scores[0]
	if chooseTarget_onRange_Enemy_counter > 0:
		for i in chooseTarget_onRange_Enemy_counter:
			if i > 0:
				if internal_onRange_Enemies_scores[i] > highest_score:
					chosenOne = i
					highest_score = internal_onRange_Enemies_scores[i]
			
				chooseTarget_Action_target = internal_onRange_Enemies[chosenOne].global_position
				print(STATS.NAME, " attacks ", internal_onRange_Enemies[chosenOne].get_node("icon/Stats").NAME)
	else:
		chooseTarget_Action_target = Vector2(0, 0)
		print("No enemy at ", STATS.NAME, " range.")
	return chooseTarget_Action_target
	
func scoreEnemies(internal_Enemies_scores, internal_Enemy_counter, internal_Enemies):
	if internal_Enemy_counter > 0:
		var Highest_EnemyDMGER = 0
		var Lowest_EnemyDMGER = 0
		var Highest_EnemyDMG = 0
		var Lowest_EnemyDMG = 1000000000
		
		for i in internal_Enemy_counter:
			if (abs(internal_Enemies[i].position.x - self.position.x) <= DISPLACEMENT
			&& abs(internal_Enemies[i].position.y - self.position.y) <= DISPLACEMENT):
				internal_Enemies_scores[i] += 3
			
			if internal_Enemies[i].get_node("icon/Stats").RANGED == true:
				internal_Enemies_scores[i] += 2
			
			var Enemy_dmg = (internal_Enemies[i].get_node("icon/Stats").DAMAGE 
							*internal_Enemies[i].get_node("icon/Stats").NUMBER)
			if i >0:
				if Enemy_dmg > Highest_EnemyDMG:
					Highest_EnemyDMG = Enemy_dmg
					Highest_EnemyDMGER = i
				if Enemy_dmg < Lowest_EnemyDMG:
					Lowest_EnemyDMG = Enemy_dmg
					Lowest_EnemyDMGER = i
			else:
				Highest_EnemyDMG = Enemy_dmg
				Lowest_EnemyDMG = Enemy_dmg
				
		internal_Enemies_scores[Highest_EnemyDMGER] += 3
		internal_Enemies_scores[Lowest_EnemyDMGER] -= 3
		
	return internal_Enemies_scores

func retrieveTiles(retrieveTiles_Action_target, 
					retrieveTiles_TileList, 
					internal_Tiles_scores,
					retrieveTiles_Tile_counter,
					internal_onRange_Enemy_counter):
	if internal_onRange_Enemy_counter > 0:
		var CurrentTilePosition
		
		CurrentTilePosition = Vector2(retrieveTiles_Action_target.x, retrieveTiles_Action_target.y-64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			retrieveTiles_Tile_counter +=1
			retrieveTiles_TileList[retrieveTiles_Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(retrieveTiles_Action_target.x+64, retrieveTiles_Action_target.y-64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			retrieveTiles_TileList.append(0)
			internal_Tiles_scores.append(0)
			retrieveTiles_Tile_counter +=1
			retrieveTiles_TileList[retrieveTiles_Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(retrieveTiles_Action_target.x+64, retrieveTiles_Action_target.y)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			retrieveTiles_TileList.append(0)
			internal_Tiles_scores.append(0)
			retrieveTiles_Tile_counter +=1
			retrieveTiles_TileList[retrieveTiles_Tile_counter] = CurrentTilePosition
		
		CurrentTilePosition = Vector2(retrieveTiles_Action_target.x+64, retrieveTiles_Action_target.y+64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			retrieveTiles_TileList.append(0)
			internal_Tiles_scores.append(0)
			retrieveTiles_Tile_counter +=1
			retrieveTiles_TileList[retrieveTiles_Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(retrieveTiles_Action_target.x, retrieveTiles_Action_target.y+64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			retrieveTiles_TileList.append(0)
			internal_Tiles_scores.append(0)
			retrieveTiles_Tile_counter +=1
			retrieveTiles_TileList[retrieveTiles_Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(retrieveTiles_Action_target.x-64, retrieveTiles_Action_target.y+64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			retrieveTiles_TileList.append(0)
			internal_Tiles_scores.append(0)
			retrieveTiles_Tile_counter +=1
			retrieveTiles_TileList[retrieveTiles_Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(retrieveTiles_Action_target.x-64, retrieveTiles_Action_target.y)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			retrieveTiles_TileList.append(0)
			internal_Tiles_scores.append(0)
			retrieveTiles_Tile_counter +=1
			retrieveTiles_TileList[retrieveTiles_Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(retrieveTiles_Action_target.x-64, retrieveTiles_Action_target.y-64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			retrieveTiles_TileList.append(0)
			internal_Tiles_scores.append(0)
			retrieveTiles_Tile_counter +=1
			retrieveTiles_TileList[retrieveTiles_Tile_counter] = CurrentTilePosition
			
	return [retrieveTiles_TileList, retrieveTiles_Tile_counter, internal_Tiles_scores]

func scoreTiles(internal_Tiles_scores, internal_Tile_counter, 
				internal_Enemy_counter, internal_Enemies, internal_TileList):
	if internal_Tile_counter > 1:
	# Si ennemis à portée, on cherche la tuile d'attaque à portée.
		for i in internal_Tile_counter:
			internal_Tiles_scores[i] = 4
			
			for j in internal_Enemy_counter:
				var Enemy_Displacement = internal_Enemies[j].get_node("icon/Stats").DISPLACEMENT+1
				if (abs(internal_TileList[i].x - internal_Enemies[j].position.x) < Enemy_Displacement
				&& (abs(internal_TileList[i].y - internal_Enemies[j].position.y) < Enemy_Displacement
				&&(abs(internal_Enemies[j].position.x) != Enemy_Displacement
				|| abs(internal_Enemies[j].position.y) != Enemy_Displacement))):
					internal_Tiles_scores[i] -= 2
	else:
	# Sinon, on cherche la tuile la plus intéressante pour le prochain tour.
		for i in TEMPORARY.get_child_count():
			internal_Tiles_scores.append(0)
			var CurrentTilePosition = TEMPORARY.get_child(i).global_position
			for j in internal_Enemy_counter:
				if (abs(CurrentTilePosition.x - internal_Enemies[j].position.x) < DISPLACEMENT
				&& abs(CurrentTilePosition.y - internal_Enemies[j].position.y) < DISPLACEMENT):
					internal_Tile_counter +=1
					internal_Tiles_scores[i] += 1
	return [internal_Tiles_scores, internal_Tile_counter]
	
func chooseTile(chooseTile_Tile_target, 
				internal_Tile_scores, internal_Tile_counter, internal_TileList):
	var chosenOne : int = 0
	var highest_score = internal_Tile_scores[0]
	if internal_Tile_counter > 1:
		for i in internal_Tile_counter:
			if i > 0:
				if internal_Tile_scores[i] > highest_score:
					chosenOne = i
					highest_score = internal_Tile_scores[i]
			
				chooseTile_Tile_target = internal_TileList[chosenOne]
			
	elif internal_Tile_counter == 1:
		chooseTile_Tile_target = internal_TileList[0]
	else:
	# en l'absence de cible convaincante, on vise la tuile la plus proche du centre.
		for i in TEMPORARY.get_child_count():
			var BattlefieldCenter = Vector2(800, 450)
			var PreviousTarget = Vector2(2000, 2000)
			
			var CurrentTilePosition = TEMPORARY.get_child(i).position
			if abs(TEMPORARY.get_child(i).position.x - BattlefieldCenter.x) < PreviousTarget.x:
				PreviousTarget = TEMPORARY.get_child(i).position
				chooseTile_Tile_target = TEMPORARY.get_child(i).global_position
			elif abs(TEMPORARY.get_child(i).position.x - BattlefieldCenter.x) == PreviousTarget.x:
				if abs(TEMPORARY.get_child(i).position.y - BattlefieldCenter.x) < PreviousTarget.y:
					PreviousTarget = TEMPORARY.get_child(i).position.y
					chooseTile_Tile_target = TEMPORARY.get_child(i).global_position
	
	return chooseTile_Tile_target