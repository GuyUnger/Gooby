package  {
	
	import flash.display.MovieClip;
	
	
	public class Dialog extends MovieClip {

		var current
		var i
		var current_text=""
		var typing=0
		var t=0
		var jiggle_t=0

		var voice_gooby = new VGoo()
		var voice_other = new VOther()
		var voice_brother = new VBro()
		var voice_dad = new VDad()

		var voice_time = 0
		var voice
		
		var dialgs = {
			"vincent1":[
				["brompot",	"v",			"Good morning.. dear brother.."],
				["brompot",	"v",			"Father would like to have a word with you"],
				["brompot",	"v",			"he is very.."],
				["brompot",	"v_smug",		"very.. displeased with you"],
				["gooby",	"g",			"daddy upset?"],
				["brompot",	"v",			"said something about..?"],
				["brompot",	"v_smug",		"throwing you down the fiery pits of hell?"],
				["gooby",	"g",			"oh geebers!"],
				["dad",		"d",			"kRkkrrGhaaraaagk"],
				["gooby",	"g",			"yes papa, coming papa!"]
			],
			"go on":[
				["brompot",	"v",			"go on then.."],
			],
			"dad":[
				["dad",		"d",			"ghruuuuuAUUUuu"],
				["gooby",	"g",			"what's that daddy?"],
				["dad",		"d",			"kRkRzRuuaaaaaaaaaaAAAaaaa"],
				["gooby",	"g",			"last chance to proof myself?"],
				["dad",		"d",			"ohhGgggyyooblrRrr"],
				["gooby",	"g",			"or gooby will burn in hell forever?"],
				["dad",		"d",			"grrrOOOoaaoohooha"],
				["gooby",	"g",			"you got it daddy!"]
			],
			"vincent2":[
				["brompot",	"v",			"you’re still alive?"],
				["gooby",	"g",			"last chance to make daddy proud!"],
				["gooby",	"g",			"gotta fullfill special quest before sunrise!"],
				["brompot",	"v",			"oh dear, there isn't much time"],
				["brompot",	"v",			"but fear not, brother"],
				["brompot",	"v",			"for i happen to know a little shortcut"],
				["brompot",	"v",			"follow me"],
				["gooby",	"g",			"thank you bro, you the best!!"]
			],
			"vincent3":[
				["brompot",	"v",			"ha ha ha!"],
				["brompot",	"v",			"betrayal!"]
			],
			"rednecks1":[
				["gruck",	"b",			"hey puck.."],
				["puck",	"t",			"yeh gruck?"],
				["gruck",	"b",			"we been comin' out here fishin' every darn day"],
				["gruck",	"b",			"don’t ya ever wish.."],
				["gruck",	"b",			"somethin new 'n excitin'd happen?"],
				["gruck & puck",	"tb2",	"..."],
				["gruck & puck",	"tb",	"hahaha!"],
				["puck",	"t",			"nope.."],
				["puck",	"t",			"never"],
			],
			"rednecks2":[
				["puck",	"t",			"somethin new 'n excitin' happened!"],
				["puck",	"t",			"kill it!!"],
			],
			"end":[
				["dad",		"d",			"gooby.."],
				["dad",		"d",			"..destroyer of worlds"],
				["dad",		"d",			"i'm proud of you my son"]
			]
		}
		public function Dialog() {
			Game.dialog = this
			visible=false
			//start("vincent1")
		}

		public function start(tag){
			current=dialgs[tag]
			visible = true
			i=0
			Game.cutscening=true
			read_line()
			if(tag=="dad"){
				Game.talked_with_dad=true
			}
		}

		function read_line(){
			typing=0
			if (i==current.length){
				end()
				return
			}
			var n = current[i][0]
			if(n=="gooby"){
				gotoAndStop(2)
				voice = voice_gooby
			}
			else if(n=="brompot"){
				gotoAndStop(3)
				voice = voice_brother
			}
			else if(n =="dad"){
				gotoAndStop(4)
				if(Game.room){
					Game.room.rumble=2
				}
				voice = voice_dad
			}else{
				voice = voice_other
				gotoAndStop(1)
			}
			char_name.text = current[i][0]
			head.gotoAndStop(current[i][1])
			current_text =current[i][2]
			txt.text = ""
			i+=1
			jiggle_t=-1

			voice_time = 0

		}

		function end(){
			visible = false
			Game.cutscening = false
			current=null
		}
		function _process(delta){
			if(!current){
				return
			}
			t+=delta
			head.rotation=Math.sin(t * 1.5) * 12
			head.scaleX =1+Math.cos(t*3) *0.1
			head.scaleY =1+Math.cos(t*3+0.4)*0.1
			
			if(typing<current_text.length) {
				voice_time-=delta
				if(voice_time<0){
					voice_time = 0.1
					voice.play()
				}
				if(Game.interactJustPressed){
	Game.interactJustPressed = false
}
				if(typing<current_text.length/2){
					typing+=2
				}else{
					typing+=1
					//typing=Math.min(typing+2,current_text.length)
				}
				txt.text = current_text.substr(0,typing)
			}else{
				if(Game.interactJustPressed){
	Game.interactJustPressed = false

					read_line()
				}
			}
		
			jiggle_t=move_toward(jiggle_t,0,delta / 1.5)
			var jiggle_power = Math.pow(jiggle_t,2)
			scaleX = (1-Math.cos(jiggle_power*Math.PI*3)*jiggle_power * 0.03)
			scaleY = (1+Math.cos(jiggle_power*Math.PI*3+0.5)*jiggle_power * 0.03)
		}

		function move_toward(from,to,delta){
			if(from>to){
				from -= delta
				if (from<to){
					from=to
				}
			} else if(from<to){
				from+=delta
				if (from>to){
					from=to
				}
			}
			return from
		}

	}
}