extends Position2D

var TURN : 		Node
var TEMPORARY : Node
var STATS : 	Node

var ALL_TEMPORARY = []
var ALL_STATS = 	[]
var ENEMY_STATS = 	[]

var DISPLACEMENT : int

var Character_number : int

#==============================================
func AI_Fightmode():

	var Action_target : Vector2
	var Tile_target : 	Vector2

	print("AI playing --")
	initialize()
	retrieveNodes()
	
	#---------------------
	var Enemies = []
	var Enemy_counter : int = 0
	var Enemies_scores = []							# unused yet
	var tempo
	tempo = retrieveEnemies(Enemies, Enemy_counter, Enemies_scores)
	Enemies = 			tempo[0]
	Enemy_counter = 	tempo[1]
	Enemies_scores = 	tempo[2]
	
	var onRange_Enemies = []
	var onRange_Enemy_counter : int = 0
	var onRange_Enemies_scores = []
	tempo = []
	tempo = retrieveOnRangeEnemies(onRange_Enemies, onRange_Enemy_counter, onRange_Enemies_scores,
													Enemies, Enemy_counter)
	onRange_Enemies = tempo[0]
	onRange_Enemy_counter = tempo[1]
	onRange_Enemies_scores = tempo[2]
	
	onRange_Enemies_scores = scoreOnRangeEnemies(onRange_Enemies_scores,
												onRange_Enemies, 
												onRange_Enemy_counter)
	
	Action_target = chooseTarget(Action_target, 
								onRange_Enemies, onRange_Enemy_counter, onRange_Enemies_scores)
	#---------------------
	
	Enemies_scores = scoreEnemies(Enemies_scores, Enemies, Enemy_counter) 	# unused yet
	
	var TileList = []
	var Tile_counter : int = 0
	var Tiles_scores = []
	tempo = []
	tempo = retrieveTiles(TileList, Tile_counter, Tiles_scores, 
							Action_target, onRange_Enemy_counter)
	TileList = 		tempo[0]
	Tile_counter = tempo[1]
	Tiles_scores = tempo[2]
	
	tempo = []
	tempo = scoreTiles(Tiles_scores, Tile_counter, 
						Enemies, Enemy_counter, TileList)
	TileList = tempo[0]
	Tile_counter = tempo[1]
	Tiles_scores = tempo[2]
	
	Tile_target = chooseTile(Tile_target, Tile_counter, Tiles_scores, TileList)
	#---------------------
	
	print("-- AI played")
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

# warning-ignore:unused_argument
func retrieveEnemies(return_Enemies, return_Enemy_counter, return_Enemies_scores):
	var j : int = 0
	for i in Character_number:
		if ALL_STATS[i].SIDE != STATS.SIDE:
			return_Enemy_counter += 1
			return_Enemies_scores.append(0)
			
			return_Enemies.append(0)
			return_Enemies[j] = TURN.get_child(i)
			
			ENEMY_STATS.append(0)
			ENEMY_STATS[j] = TURN.get_child(i).get_node("icon/Stats")
			j += 1
	return [return_Enemies, return_Enemy_counter, return_Enemies_scores]

# warning-ignore:unused_argument
func retrieveOnRangeEnemies(return_onRange_Enemies, return_onRange_Enemy_counter, return_onRange_Enemy_scores,
						internal_Enemies, internal_Enemy_counter):
	var j : int = 0
	for i in internal_Enemy_counter:
		if (ENEMY_STATS[i].SIDE != STATS.SIDE
		&& abs(internal_Enemies[i].global_position.x - self.global_position.x) <= 64*(DISPLACEMENT+1)
		&& abs(internal_Enemies[i].global_position.y - self.global_position.y) <= 64*(DISPLACEMENT+1)
		&& (abs(internal_Enemies[i].global_position.x) != DISPLACEMENT+1
		|| abs(internal_Enemies[i].global_position.y) != DISPLACEMENT+1)):
			
			return_onRange_Enemy_counter += 1
			return_onRange_Enemies.append(0)
			return_onRange_Enemies[j] = internal_Enemies[i]
			return_onRange_Enemy_scores.append(0)
			j += 1
			
	return [return_onRange_Enemies, return_onRange_Enemy_counter, return_onRange_Enemy_scores]

func scoreOnRangeEnemies(return_onRange_Enemies_scores, 
						internal_onRange_Enemies, 
						internal_onRange_Enemy_counter):
	if internal_onRange_Enemy_counter > 0:
		var Highest_EnemyDMGER = 0
		var Lowest_EnemyDMGER = 0
		var Highest_EnemyDMG = 0
		var Lowest_EnemyDMG = 1000000000
		
		for i in internal_onRange_Enemy_counter:
			if (abs(internal_onRange_Enemies[i].global_position.x - self.global_position.x) <= 64*DISPLACEMENT
			&& abs(internal_onRange_Enemies[i].global_position.y - self.global_position.y) <= 64*DISPLACEMENT):
				return_onRange_Enemies_scores[i] += 3
			
			if internal_onRange_Enemies[i].get_node("icon/Stats").RANGED == true:
				return_onRange_Enemies_scores[i] += 2
			
			var Enemy_dmg = internal_onRange_Enemies[i].get_node("icon/Stats").DAMAGE *internal_onRange_Enemies[i].get_node("icon/Stats").NUMBER
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
				
		return_onRange_Enemies_scores[Highest_EnemyDMGER] += 3
		return_onRange_Enemies_scores[Lowest_EnemyDMGER] -= 3
		
	return return_onRange_Enemies_scores

func chooseTarget(return_Action_target, 
				internal_onRange_Enemies, internal_onRange_Enemy_counter, internal_onRange_Enemies_scores):
	var chosenOne : int = 0
	var highest_score : int = -10
	if internal_onRange_Enemy_counter > 0:
		for i in internal_onRange_Enemy_counter:
			if i > 0:
				if internal_onRange_Enemies_scores[i] > highest_score:
					chosenOne = i
					highest_score = internal_onRange_Enemies_scores[i]
			
			return_Action_target = internal_onRange_Enemies[chosenOne].global_position
			print(STATS.NAME, " attacks ", internal_onRange_Enemies[chosenOne].get_node("icon/Stats").NAME)
	else:
		return_Action_target = Vector2(0, 0)
		print("No enemy at ", STATS.NAME, " range.")
		
	return return_Action_target

func scoreEnemies(return_Enemies_scores, internal_Enemies, internal_Enemy_counter):
	if internal_Enemy_counter > 0:
		var Highest_EnemyDMGER = 0
		var Lowest_EnemyDMGER = 0
		var Highest_EnemyDMG = 0
		var Lowest_EnemyDMG = 1000000000
		
		for i in internal_Enemy_counter:
			if (abs(internal_Enemies[i].position.x - self.position.x) <= 64*DISPLACEMENT
			&& abs(internal_Enemies[i].position.y - self.position.y) <= 64*DISPLACEMENT):
				return_Enemies_scores[i] += 3
			
			if internal_Enemies[i].get_node("icon/Stats").RANGED == true:
				return_Enemies_scores[i] += 2
			
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
				
		return_Enemies_scores[Highest_EnemyDMGER] += 3
		return_Enemies_scores[Lowest_EnemyDMGER] -= 3
		
	return return_Enemies_scores

func retrieveTiles(return_TileList, return_Tile_counter, return_Tiles_scores,
					internal_Action_target,
					internal_onRange_Enemy_counter):
	if internal_onRange_Enemy_counter > 0:
		
		var tempo = checkTilesAroundTarget(	return_TileList, return_Tile_counter, return_Tiles_scores,
										internal_Action_target, 0, -64)
		return_TileList = 		tempo[0]
		return_Tile_counter = 	tempo[1]
		return_Tiles_scores = 	tempo[2]
			
		tempo = checkTilesAroundTarget(	return_TileList, return_Tile_counter, return_Tiles_scores,
										internal_Action_target, 64, -64)
		return_TileList = 		tempo[0]
		return_Tile_counter = 	tempo[1]
		return_Tiles_scores = 	tempo[2]
		
		tempo = checkTilesAroundTarget(	return_TileList, return_Tile_counter, return_Tiles_scores,
										internal_Action_target, 64, 0)
		return_TileList = 		tempo[0]
		return_Tile_counter = 	tempo[1]
		return_Tiles_scores = 	tempo[2]
			
		tempo = checkTilesAroundTarget(	return_TileList, return_Tile_counter, return_Tiles_scores,
										internal_Action_target, 64, 64)
		return_TileList = 		tempo[0]
		return_Tile_counter = 	tempo[1]
		return_Tiles_scores = 	tempo[2]
			
		tempo = checkTilesAroundTarget(	return_TileList, return_Tile_counter, return_Tiles_scores,
										internal_Action_target, 0, 64)
		return_TileList = 		tempo[0]
		return_Tile_counter = 	tempo[1]
		return_Tiles_scores = 	tempo[2]
			
		tempo = checkTilesAroundTarget(	return_TileList, return_Tile_counter, return_Tiles_scores,
										internal_Action_target, -64, 64)
		return_TileList = 		tempo[0]
		return_Tile_counter = 	tempo[1]
		return_Tiles_scores = 	tempo[2]
			
		tempo = checkTilesAroundTarget(	return_TileList, return_Tile_counter, return_Tiles_scores,
										internal_Action_target, -64, 0)
		return_TileList = 		tempo[0]
		return_Tile_counter = 	tempo[1]
		return_Tiles_scores = 	tempo[2]
			
		tempo = checkTilesAroundTarget(	return_TileList, return_Tile_counter, return_Tiles_scores,
										internal_Action_target, -64, -64)
		return_TileList = 		tempo[0]
		return_Tile_counter = 	tempo[1]
		return_Tiles_scores = 	tempo[2]
	
	return [return_TileList, return_Tile_counter, return_Tiles_scores]

func checkTilesAroundTarget(return_TileList, return_Tile_counter, return_Tiles_scores,
							internal_Action_target, Offset_x, Offset_y):
	var CurrentTilePosition = Vector2(	internal_Action_target.x+Offset_x, 
										internal_Action_target.y+Offset_y)
	if (abs(CurrentTilePosition.x - self.global_position.x) <= 64*DISPLACEMENT
	&& abs(CurrentTilePosition.y - self.global_position.y) <= 64*DISPLACEMENT
	&& (abs(CurrentTilePosition.x) != 64*(DISPLACEMENT+1)
	|| abs(CurrentTilePosition.y) != 64*(DISPLACEMENT+1))):
		return_TileList.append(0)
		return_Tiles_scores.append(0)
		return_TileList[return_Tile_counter] = Vector2(CurrentTilePosition.x,
														CurrentTilePosition.y)
		return_Tile_counter +=1
		
	return [return_TileList, return_Tile_counter, return_Tiles_scores]

func scoreTiles(return_Tiles_scores, return_Tile_counter, 
				internal_Enemies, internal_Enemy_counter, internal_TileList):
	if return_Tile_counter > 1:
	# Si ennemis à portée, on cherche la tuile d'attaque à portée.
		for i in return_Tile_counter:
			return_Tiles_scores[i] = 4
			
			for j in internal_Enemy_counter:
				var Enemy_Displacement = 64*(internal_Enemies[j].get_node("icon/Stats").DISPLACEMENT+1)
				if (abs(internal_TileList[i].x - internal_Enemies[j].position.x) < Enemy_Displacement
				&& (abs(internal_TileList[i].y - internal_Enemies[j].position.y) < Enemy_Displacement
				&&(abs(internal_Enemies[j].position.x) != Enemy_Displacement
				|| abs(internal_Enemies[j].position.y) != Enemy_Displacement))):
					return_Tiles_scores[i] -= 2
	else:
	# Sinon, on cherche la tuile la plus intéressante pour le prochain tour.
		for i in TEMPORARY.get_child_count():
			return_Tiles_scores.append(0)
			var CurrentTilePosition = TEMPORARY.get_child(i).global_position
			for j in internal_Enemy_counter:
				if (abs(CurrentTilePosition.x - internal_Enemies[j].position.x) < 64*DISPLACEMENT
				&& abs(CurrentTilePosition.y - internal_Enemies[j].position.y) < 64*DISPLACEMENT):
					return_Tiles_scores[i] += 1
					internal_TileList.append(0)
					internal_TileList[return_Tile_counter] = CurrentTilePosition
					return_Tile_counter +=1
					
	return [internal_TileList, return_Tile_counter, return_Tiles_scores]

func chooseTile(return_Tile_target, 
				internal_Tile_counter, internal_Tile_scores, internal_TileList):
	var chosenOne : int = 0
	var highest_score = internal_Tile_scores[0]
	
	if internal_Tile_counter > 1:
		for i in internal_Tile_counter:
			if i > 0:
				if internal_Tile_scores[i] > highest_score:
					chosenOne = i
					highest_score = internal_Tile_scores[i]
			
				return_Tile_target = internal_TileList[chosenOne]
			
	elif internal_Tile_counter == 1:
		return_Tile_target = internal_TileList[0]
	else:
	# en l'absence de cible convaincante, on vise la tuile la plus proche du centre.
		for i in TEMPORARY.get_child_count():
			var BattlefieldCenter = Vector2(800, 450)
			var PreviousTarget = Vector2(2000, 2000)
			
			if abs(TEMPORARY.get_child(i).position.x - BattlefieldCenter.x) < PreviousTarget.x:
				PreviousTarget = TEMPORARY.get_child(i).position
				return_Tile_target = TEMPORARY.get_child(i).global_position
			elif abs(TEMPORARY.get_child(i).position.x - BattlefieldCenter.x) == PreviousTarget.x:
				if abs(TEMPORARY.get_child(i).position.y - BattlefieldCenter.x) < PreviousTarget.y:
					PreviousTarget = TEMPORARY.get_child(i).position.y
					return_Tile_target = TEMPORARY.get_child(i).global_position
	
	return return_Tile_target