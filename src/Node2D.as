package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class Node2D extends MovieClip {
		
		var initialized: Boolean = false
		var freed: Boolean
		
		public var velocity_x: Number = 0.0
		public var velocity_y: Number = 0.0
		var processing: Boolean = false
		var self = this

		var anim_current:String
		public var speed = 250.0

		public static var enemies = 0

		public function Node2D() {
			addEventListener(Event.ADDED_TO_STAGE, _added_to_stage)
			addEventListener(Event.REMOVED_FROM_STAGE, _removed_from_stage)
			Game.count+=1
			trace(this)
			if ("_process" in this)
				processing = true
		}

		function _added_to_stage(_) {
			removeEventListener(Event.ADDED_TO_STAGE, _added_to_stage)
			addEventListener(Event.ENTER_FRAME, _enter_frame)
			parent.addEventListener(Event.REMOVED_FROM_STAGE, _removed_from_stage)
		}
		
		function _enter_frame(_) {
			if (!initialized) {
				if ("_ready" in this)
					self._ready()
				if (MovieClip(parent).sort.indexOf(this) == -1)
					MovieClip(parent).sort.push(this)
				initialized = true
			}
			if (processing)
				self._process(1.0 / 60)
		}
		
		function move_and_slide() {
			x += velocity_x * Time.delta
			y += velocity_y * Time.delta
			
			var walls = MovieClip(parent).walls
			
			var direction_x: Number = 0.0
			var direction_y: Number = 0.0
			for (var i = 0; i < 8; i++){
				direction_x = Math.cos(i / 8 * Math.PI * 2)
				direction_y = Math.sin(i / 8 * Math.PI * 2)
				var check_x = x + direction_x * 10 + parent.x// + walls.x
				var check_y = y + direction_y * 10 + parent.y// + walls.y
				if (walls.hitTestPoint(check_x, check_y, true) ) {
					var dot_product: Number = velocity_x * direction_x + velocity_y * direction_y
					velocity_x = velocity_x - direction_x * dot_product
					velocity_y = velocity_y - direction_y * dot_product
					x -= direction_x * speed * Time.delta
					y -= direction_y * speed * Time.delta
				}
			}
		}
		
		function distance(from_x, from_y, to_x, to_y): Number {
			var dx: Number = from_x - to_x
			var dy: Number = from_y - to_y
			return Math.sqrt(dx*dx + dy*dy)
		}

		public function distance_to(object): Number {
			var dx: Number = x - object.x
			var dy: Number = y - object.y
			return Math.sqrt(dx*dx + dy*dy)
		}

		function anim(label_name) {
			if (anim_current == label_name) return
			anim_current = label_name
			model.gotoAndPlay(label_name)
		}

		public function queue_free() {
			if (freed) return
			freed = true
			Game.free_queue.push(self)
		}

		public function free() {
			var i = MovieClip(parent).sort.indexOf(this)
			if (i != -1)
				MovieClip(parent).sort.removeAt(i)
			parent.removeChild(this)
		}

		function _removed_from_stage(_) {
			removeEventListener(Event.ENTER_FRAME, _enter_frame)
			parent.removeEventListener(Event.REMOVED_FROM_STAGE, _removed_from_stage)
			Game.count-=1
		}
	}
}