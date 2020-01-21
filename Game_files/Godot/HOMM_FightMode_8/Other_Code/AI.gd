# AI

var DISPLACEMENT = STATS.DISPLACEMENT
var Enemy_counter: int = 0
var Enemies = []
var Enemies_scores = []
var chosenOne : int  = 0

func AI_Fightmode():
	retrieveCharacters()
	scoreEnemies()
	chooseTarget()
	scoreTiles()
	
	#renvoi à l'algorithme d'action:
	Action_position
	Tile_position
	
func retrieveCharacters():
	for i in TURN.get_children:
		if get_child(i).SIDE != Stats.SIDE:
			Enemy_counter += 1
			Enemies.append(0)
			Enemies_scores.append(0)
			Enemies[i] = TURN.get_child(i)

func scoreEnemies():
	var Highest_EnemyDMGER = 0
	var Lowest_EnemyDMGER = 0
	var Highest_EnemyDMG = 0
	var Lowest_EnemyDMG = 1000000
	
	for i in Enemy_counter:
		if (abs(Enemies[i].global_position.x - self.global_position.x) <= DISPLACEMENT
		&& abs(Enemies[i].global_position.y - self.global_position.y) <= DISPLACEMENT:
			Enemies_scores[i] += 3
		
		if Enemies[i].get_node("icon/Stats").Ranged == true:
			Enemies_scores[i] += 2
		
		var Enemy_dmg = Enemies[i].get_node("icon/Stats").DAMAGE *Enemies[i].get_node("icon/Stats").Number
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

func chooseTarget():
	var highest_score = Enemies_scores[0]
	
	for i in Enemy_counter:
		if i > 0:
			if Enemies_scores[i] > highest_score:
				chosenOne = i
				highest_score = Enemies_scores[i]
		
		if (abs(Enemies[chosenOne].global_position.x - self.global_position.x) <= DISPLACEMENT
		&& abs(Enemies[chosenOne].global_position.y - self.global_position.y) <= DISPLACEMENT:
			return
		else:
			