package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Detail extends MovieClip {
		
		
		public function Detail() {
			addEventListener(Event.ENTER_FRAME, _enter_frame)
		}
		
		function _enter_frame(_) {
			removeEventListener(Event.ENTER_FRAME, _enter_frame)
			MovieClip(parent).sort.push(this)
		}	
	}
}