package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
import flash.media.Sound;
import flash.media.SoundChannel;

	public class Game extends MovieClip {
		public static var player
		public static var room
		public static var free_queue = []
		public static var main
		public static var dialog
		public static var cutscening=false

		public static var upgrades = []

		public static var talked_with_dad = false

		var letterbox_frame = 0.0

		public static var enemies = 0

		public static var fighting = false
		var fighting_t = 0.0

		static var keys = []

		static public var current_room = ""
		static public var save_room = ""

		static public var growing=false

		static public var count=0
		static public var in_city=false

		static public var burp = [new Burp(),new Burp2(),new Burp3()]

		var channel:SoundChannel;
		var song_current = ""

		function Game() {
			addEventListener(Event.EXIT_FRAME, _on_exit_frame)
			addEventListener(Event.ENTER_FRAME, _on_enter_frame)

			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down)
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up)
			main=this
		}

		public function play_music(song){
			if (song_current == song.toString())return
			song_current = song.toString()
			trace(song_current)
			if (channel)
				channel.stop()
			channel = song.play(0, int.MAX_VALUE);
		}
		public function stop_music(){
			trace(channel)
			if (channel)
				channel.stop()
			channel=null
		}

		
		function _on_exit_frame(_) {
			for(var i = 0; i < free_queue.length; i++) {
				free_queue[i].free()
			}
			free_queue = []
		}

		function _on_enter_frame(_) {
			stage.focus=this
			dialog._process(Time.delta)

			var room_name = currentLabel
			if(current_room!=room_name){
				current_room=room_name
trace(current_room)
			}

			var letterbox_frame_to=cutscening?20:1

			letterbox_frame=move_toward(letterbox_frame,letterbox_frame_to,Time.delta*20/0.5)
			letterbox.gotoAndStop(Math.round(letterbox_frame))
			if(enemies > 0){
				if(fighting_t<=0){
					level_start()
					fighting_t=2
				}
			} else if(fighting_t>0){
				fighting_t-=Time.delta
				if(fighting_t<=0){
					level_finish()
				}
			}
		}

		function level_start(){
			fighting=true
		}

		function level_finish(){
			fighting=false
			up.show()
			trace(has_key(current_room))
			if(!has_key(current_room)){
				add_key(current_room)
			}
			save_room=current_room
		}

		public static function stop_fight(){
			main.fighting_t=0
			fighting=false
		}

		public static function has_key(key:String){
			return keys.indexOf(key) != -1
		}

		public static function add_key(key:String){
			keys.push(key)
			trace(keys)
		}

		const LEFT:int = Keyboard.LEFT
		const RIGHT:int = Keyboard.RIGHT
		const UP:int = Keyboard.UP
		const DOWN:int = Keyboard.DOWN
		const SPACE:int = Keyboard.SPACE
		const W:int = Keyboard.W
		const A:int = Keyboard.A
		const S:int = Keyboard.S
		const D:int = Keyboard.D

		static var leftPressed:Boolean = false
		static var rightPressed:Boolean = false
		static var upPressed:Boolean = false
		static var downPressed:Boolean = false

		static var interactPressed = false
		static var interactJustPressed = false

		function key_down(event:KeyboardEvent):void {
		  switch (event.keyCode) {
		    case LEFT:
		    case A:
		      leftPressed = true
		      break
		    case RIGHT:
		    case D:
		      rightPressed = true
		      break
		    case UP:
		    case W:
		      upPressed = true
		      break
		    case DOWN:
		    case S:
		      downPressed = true
		      break
		    case SPACE:
		      interactPressed = true
			interactJustPressed = true
		      break
		  }
		}

		function key_up(event:KeyboardEvent):void {
		  switch (event.keyCode) {
		    case LEFT:
		    case A:
		      leftPressed = false
		      break
		    case RIGHT:
		    case D:
		      rightPressed = false
		      break
		    case UP:
		    case W:
		      upPressed = false
		      break
		    case DOWN:
		    case S:
		      downPressed = false
		      break
		    case SPACE:
				interactPressed = false
		      break
		  }
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