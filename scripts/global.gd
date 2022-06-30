extends Node


var player


var culpits_data = {
	"wheel": {
		"icon": "res://arts/culpits/wheel.png",
		"card": "res://arts/cards/C_wheel.png",
		"controllable": true,
		"action": false,
		"hint": "press E to steer",
	},
	"locker": {
		"icon": "res://arts/culpits/locker.png",
		"card": "res://arts/cards/C_locker.png",
		"controllable": true,
		"action": true,
		"hint": "press E to lock",
	},
	"light": {
		"icon": "",
		"card": "res://arts/cards/C_turret.png",
		"controllable": true,
		"action": true,
		"hint": "press E to turn on/off",
	},
	"turret": {
		"icon": "",
		"card": "res://arts/cards/C_turret.png",
		"controllable": true,
		"action": true,
		"hint": "press E to disable",
	},
	"auto_turret": {
		"icon": "",
		"card": "res://arts/cards/C_auto_turret.png",
		"controllable": true,
		"action": true,
		"hint": "press E to disable",
	},
}
