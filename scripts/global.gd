extends Node


var player


var culpits_data = {
	"wheel": {
		"controllable": true,
		"action": false,
		"hint": "press E to steer",
	},
	"locker": {
		"controllable": true,
		"action": true,
		"hint": "press E to lock",
	},
	"light": {
		"controllable": true,
		"action": true,
		"hint": "press E to turn on/off",
	},
	"printer": {
		"controllable": true,
		"action": true,
		"hint": "press E to print",
	},
	"turret": {
		"controllable": true,
		"action": true,
		"hint": "press E to disable",
	},
	"auto_turret": {
		"controllable": true,
		"action": true,
		"hint": "press E to disable",
	},
}
