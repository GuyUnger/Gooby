package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class ParticleFire extends MovieClip {
		
		public var velocity = new Point()
		var t = Math.random() * 99.0
		
		public function ParticleFire() {
			addEventListener(Event.ENTER_FRAME, _process)
			rotation = Math.random() * 360
			scaleX = scaleY = 0
		}
		
		function _process(_) {
			var delta = Time.delta
			var life = 1 - alpha
			t += delta
			velocity.x += Math.sin(t) * 15.0 * delta * life
			velocity.y -= 30.0 * delta
			x += velocity.x
			y += velocity.y
			alpha -= delta
			
			scaleX = Math.sin(life * 3.14159)
			scaleY = scaleX
			if (alpha < 0) {
				removeEventListener(Event.ENTER_FRAME, _process)
				parent.removeChild(this)
			}
		}
	}
}