extends Position2D

var TURN : Node

var TEMPORARY : Node
var STATS : Node

var ALL_TEMPORARY = []
var ALL_STATS = []

var DISPLACEMENT : int

var onRange_Enemy_counter : int = 0
var onRange_Enemies = []
var onRange_Enemies_scores = []

var Character_number

var ENEMY_STATS = []
var Enemy_counter : int = 0
var Enemies = []
var Enemies_scores = []

var chosenOne : int  = 0

var CurrentTilePosition : Vector2
var Tile_counter : int = 0
var TileList = []
var Tiles_scores = []

var Action_target : Vector2
var Tile_target : Vector2

#==============================================
func AI_Fightmode():
	print("AI playing ---")
	initialize()
	retrieveNodes()
	retrieveEnemies()
	
	retrieveOnRangeEnemies()
	scoreOnRangeEnemies()
	chooseTarget()
	
	scoreEnemies()
	
	retrieveTiles()
	scoreTiles()
	chooseTile()
	print("--- AI played")
	
	# renvoi à l'algorithme d'action:
	Mouse_ActionTarget = Action_target
	Mouse_TileTarget = Tile_target
	# Action_target
	# Tile_target
#==============================================
func initialize():
	ALL_TEMPORARY = []
	ALL_STATS = []

	onRange_Enemy_counter = 0
	onRange_Enemies = []
	onRange_Enemies_scores = []

	ENEMY_STATS = []
	Enemy_counter = 0
	Enemies = []
	Enemies_scores = []

	chosenOne = 0

	Tile_counter = 0
	TileList = []
	Tiles_scores = []

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

func retrieveEnemies():
	var j : int = 0
	for i in Character_number:
		if ALL_STATS[i].SIDE != STATS.SIDE:
			Enemy_counter += 1
			Enemies_scores.append(0)
			
			Enemies.append(0)
			Enemies[j] = TURN.get_child(i)
			
			ENEMY_STATS.append(0)
			ENEMY_STATS[j] = TURN.get_child(i).get_node("icon/Stats")
			j += 1
	pass

func retrieveOnRangeEnemies():
	var j : int = 0
	for i in Enemy_counter:
		if (ENEMY_STATS[i].SIDE != STATS.SIDE
		&& abs(Enemies[i].global_position.x - self.global_position.x) <= DISPLACEMENT+1
		&& abs(Enemies[i].global_position.y - self.global_position.y) <= DISPLACEMENT+1
		&& (abs(Enemies[i].global_position.x) != DISPLACEMENT+1
		|| abs(Enemies[i].global_position.y) != DISPLACEMENT+1)):
			
			onRange_Enemy_counter += 1
			onRange_Enemies.append(0)
			onRange_Enemies[j] = TURN.get_child(i)
			j += 1
	
func scoreOnRangeEnemies():
	if onRange_Enemy_counter > 0:
		var Highest_EnemyDMGER = 0
		var Lowest_EnemyDMGER = 0
		var Highest_EnemyDMG = 0
		var Lowest_EnemyDMG = 1000000000
		
		for i in onRange_Enemy_counter:
			if (abs(onRange_Enemies[i].global_position.x - self.global_position.x) <= DISPLACEMENT
			&& abs(onRange_Enemies[i].global_position.y - self.global_position.y) <= DISPLACEMENT):
				onRange_Enemies_scores[i] += 3
			
			if onRange_Enemies[i].get_node("icon/Stats").Ranged == true:
				onRange_Enemies_scores[i] += 2
			
			var Enemy_dmg = onRange_Enemies[i].get_node("icon/Stats").DAMAGE *onRange_Enemies[i].get_node("icon/Stats").Number
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
				
		onRange_Enemies_scores[Highest_EnemyDMGER] += 3
		onRange_Enemies_scores[Lowest_EnemyDMGER] -= 3
	
func chooseTarget():
	var highest_score = Enemies_scores[0]
	if onRange_Enemy_counter > 0:
		for i in onRange_Enemy_counter:
			if i > 0:
				if Enemies_scores[i] > highest_score:
					chosenOne = i
					highest_score = onRange_Enemies_scores[i]
			
				Action_target = onRange_Enemies[chosenOne].global_position
	else:
		print("No enemy at ", STATS.NAME, " range.")
	
func scoreEnemies():
	if Enemy_counter > 0:
		var Highest_EnemyDMGER = 0
		var Lowest_EnemyDMGER = 0
		var Highest_EnemyDMG = 0
		var Lowest_EnemyDMG = 1000000000
		
		for i in Enemy_counter:
			if (abs(Enemies[i].position.x - self.position.x) <= DISPLACEMENT
			&& abs(Enemies[i].position.y - self.position.y) <= DISPLACEMENT):
				Enemies_scores[i] += 3
			
			if Enemies[i].get_node("icon/Stats").RANGED == true:
				Enemies_scores[i] += 2
			
			var Enemy_dmg = (Enemies[i].get_node("icon/Stats").DAMAGE 
							*Enemies[i].get_node("icon/Stats").NUMBER)
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
				
		Enemies_scores[Highest_EnemyDMGER] += 3
		Enemies_scores[Lowest_EnemyDMGER] -= 3

func retrieveTiles():
	if onRange_Enemy_counter > 0:
		var CurrentTilePosition
		
		CurrentTilePosition = Vector2(Action_target.x, Action_target.y-64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			Tile_counter +=1
			TileList[Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(Action_target.x+64, Action_target.y-64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			TileList.append(0)
			Tiles_scores.append(0)
			Tile_counter +=1
			TileList[Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(Action_target.x+64, Action_target.y)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			TileList.append(0)
			Tiles_scores.append(0)
			Tile_counter +=1
			TileList[Tile_counter] = CurrentTilePosition
		
		CurrentTilePosition = Vector2(Action_target.x+64, Action_target.y+64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			TileList.append(0)
			Tiles_scores.append(0)
			Tile_counter +=1
			TileList[Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(Action_target.x, Action_target.y+64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			TileList.append(0)
			Tiles_scores.append(0)
			Tile_counter +=1
			TileList[Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(Action_target.x-64, Action_target.y+64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			TileList.append(0)
			Tiles_scores.append(0)
			Tile_counter +=1
			TileList[Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(Action_target.x-64, Action_target.y)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			TileList.append(0)
			Tiles_scores.append(0)
			Tile_counter +=1
			TileList[Tile_counter] = CurrentTilePosition
			
		CurrentTilePosition = Vector2(Action_target.x-64, Action_target.y-64)
		if (abs(CurrentTilePosition.x - self.global_position.x) <= DISPLACEMENT
		&& abs(CurrentTilePosition.y - self.global_position.y) <= DISPLACEMENT
		&& (abs(CurrentTilePosition.x) != DISPLACEMENT+1
		|| abs(CurrentTilePosition.y) != DISPLACEMENT+1)):
			TileList.append(0)
			Tiles_scores.append(0)
			Tile_counter +=1
			TileList[Tile_counter] = CurrentTilePosition

func scoreTiles():
	Tiles_scores = []
	
	if Tile_counter > 1:
	# Si ennemis à portée, on cherche la tuile d'attaque à portée.
		for i in Tile_counter:
			Tiles_scores[i] = 4
			
			for j in Enemy_counter:
				var Enemy_Displacement = Enemies[j].get_node("icon/Stats").DISPLACEMENT+1
				if (abs(TileList[i].x - Enemies[j].position.x) < Enemy_Displacement
				&& (abs(TileList[i].y - Enemies[j].position.y) < Enemy_Displacement
				&&(abs(Enemies[j].position.x) != Enemy_Displacement
				|| abs(Enemies[j].position.y) != Enemy_Displacement))):
					Tiles_scores[i] -= 2
	else:
	# Sinon, on cherche la tuile la plus intéressante pour le prochain tour.
		for i in TEMPORARY.get_child_count():
			Tiles_scores.append(0)
			CurrentTilePosition = TEMPORARY.get_child(i).global_position
			for j in Enemy_counter:
				if (abs(CurrentTilePosition.x - Enemies[j].position.x) < DISPLACEMENT
				&& abs(CurrentTilePosition.y - Enemies[j].position.y) < DISPLACEMENT):
					Tile_counter +=1
					Tiles_scores[i] += 1	
	
func chooseTile():
	var highest_score = Tiles_scores[0]
	if Tile_counter > 1:
		for i in Tile_counter:
			if i > 0:
				if Tiles_scores[i] > highest_score:
					chosenOne = i
					highest_score = Tiles_scores[i]
			
				Tile_target = TileList[chosenOne]
			
	elif Tile_counter == 1:
		Tile_target = TileList[0]
	else:
	# en l'absence de cible convaincante, on vise la tuile la plus proche du centre.
		for i in TEMPORARY.get_child_count():
			var BattlefieldCenter = Vector2(800, 450)
			var PreviousTarget = Vector2(2000, 2000)
			
			CurrentTilePosition = TEMPORARY.get_child(i).position
			if abs(TEMPORARY.get_child(i).position.x - BattlefieldCenter.x) <= PreviousTarget.x:
				PreviousTarget.x = TEMPORARY.get_child(i).position.x
				Tile_target = TEMPORARY.get_child(i).global_position
				if abs(TEMPORARY.get_child(i).position.y - BattlefieldCenter.x) < PreviousTarget.y:
					PreviousTarget = TEMPORARY.get_child(i).position.y
	Tile_target = TEMPORARY.get_child(i).global_position