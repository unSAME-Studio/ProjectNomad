extends Node


var player


var culpits_data = {
	"wheel": {
		"controllable": true,
		"action": false,
		"hint": "Steer",
	},
	"locker": {
		"controllable": true,
		"action": true,
		"hint": "Lock / Unlock",
	},
	"light": {
		"controllable": true,
		"action": true,
		"hint": "Turn On / Off",
	},
	"printer": {
		"controllable": true,
		"action": true,
		"hint": "Print Card",
	},
	"turret": {
		"controllable": true,
		"action": false,
		"hint": "Control",
	},
	"auto_turret": {
		"controllable": true,
		"action": true,
		"hint": "Disable",
	},
}
