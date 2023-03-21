extends Node2D

var number_of_coins = 50
var coins = []
var nr_of_visible_coins = 0
var visible_coins = []
var invisible_coins = []

func _ready():
	coins = self.get_children()
	invisible_coins = self.get_children()
	number_of_coins = self.get_children().size()
	for coin in coins:
		coin.visible = false


func show_gold(number):
	var difference = nr_of_visible_coins - number
	if difference ==0:
		return
	if difference <0:
		for i in range(abs(difference)):
			match self.name:
				"GoldContainer1":
					if nr_of_visible_coins ==50:
						return
				"GoldContainer2":
					if nr_of_visible_coins ==100:
						return
				"GoldContainer3":
					if nr_of_visible_coins ==100:
						return
			visible_coins.append(invisible_coins[0])
			invisible_coins.pop_front().visible = true
			nr_of_visible_coins += 1
	if difference >0:
		for i in range(difference):
			invisible_coins.push_front(visible_coins[-1])
			visible_coins.pop_back().visible = false
			nr_of_visible_coins -= 1


