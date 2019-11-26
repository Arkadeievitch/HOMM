extends Node

class_name UnitStats

var Max_Health : 	int
var Damage : 		int
var Displacement : 	int
var Initiative : 	int
var Attack : 		int
var Defense : 		int

func initialize(stats : BaseStats):
	Max_Health = 	stats.Max_Health
	Damage = 		stats.Damage
	Displacement = 	stats.Displacement
	Initiative = 	stats.Initiative
	Attack = 		stats.Attack
	Defense = 		stats.Defense