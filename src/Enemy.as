package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class Enemy extends Node2D {
		
		public var direction_to_player_x: Number = 0.0
		public var direction_to_player_y: Number = 0.0
		public var distance_to_player: Number = 0.0
		
		public var size:Number = 30.0

		public var health:Number = 10

		public var hurt_t = 0

		var audio_hit = new AudioHit()
		
		public function _ready() {
			MovieClip(parent).enemies.push(this)
			Game.enemies+=1
		}
		
		override function _enter_frame(_) {
			distance_to_player = distance(x, y, Game.player.x, Game.player.y)
			if (distance_to_player > 0) {
				direction_to_player_x = (Game.player.x - x) / distance_to_player
				direction_to_player_y = (Game.player.y - y) / distance_to_player
			}
			if(hurt_t>0){
			hurt_t -= Time.delta
			if(hurt_t<=0){
				MovieClip(this).m.gotoAndPlay(1)
			}
			}else{
				super._enter_frame(_)
			}
		}
		
		override public function free() {
			Game.enemies-=1
			MovieClip(parent).enemies.removeAt(MovieClip(parent).enemies.indexOf(this))
			super.free()
		}
		
		function hit(from, damage) {
			health -= damage
			hurt_t = 0.1
			audio_hit.play()
			MovieClip(this).m.gotoAndStop("hurt")
			if (health <= 0) {
				queue_free()
			}
		}
	}	
}