package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Cutscene extends MovieClip {
		
		public var wait_t = 0.0
		var waiting_to_play = false

		public function Cutscene() {
			stop()
			addEventListener(Event.ENTER_FRAME, update)
			addEventListener(Event.REMOVED_FROM_STAGE, remove)
		}

		function wait(duration){
			wait_t = duration
			stop()
		}


		function remove(_){
			removeEventListener(Event.ENTER_FRAME, update)
			removeEventListener(Event.REMOVED_FROM_STAGE, remove)
		}

		function update(_){
			if(wait_t >0){
				wait_t -= 1 / 36.0
				if(wait_t <=0){
					play()
				}
			}
			if(waiting_to_play){
				if(!Game.cutscening){
					play()
					waiting_to_play=false
				}
			}

			if ("_process" in this)
				MovieClip(this)._process(Time.delta)
		}

		public function start_dialog(tag, play_after=true){
			Game.dialog.start(tag)
			stop()
			waiting_to_play=play_after
		}
	}
}