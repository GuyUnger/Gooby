package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Room extends MovieClip {		
		public var interactables = []
		public var enemies = []

		public var sort = []
		var sort_i = 1

		var frame = 0

		var shake = 0
		var rumble = 0

		function Room() {
			addEventListener(Event.ENTER_FRAME, _process)
			addEventListener(Event.REMOVED_FROM_STAGE, _removed_from_stage)
			walls.visible = false
			Game.room = this
			if (getChildByName("fl")) {
				setChildIndex(this["fl"], 0)
			}
		}
		

		function _removed_from_stage(_) {
			removeEventListener(Event.REMOVED_FROM_STAGE, _removed_from_stage)
			removeEventListener(Event.ENTER_FRAME, _process)
		}


		function _process(_) {
			frame += 1
			var delta = Time.delta
			process_sort()
			
			var center_x = 1200 * 0.5
			var center_y = 760 * 0.5
			
			var cam_to_x = (player.x - center_x) * 0.5 + center_x
			var cam_to_y = (player.y - center_y) * 0.5 + center_y

			var cam_speed = 10.0
			
			cam_to_x -= center_x
			cam_to_y -= center_y
			
			if (frame == 1) {
				x = -cam_to_x - (player.x - center_x) * 0.1
				y = -cam_to_y - (player.y - center_y) * 0.1

			}
			else{
				x += (-cam_to_x - x) * delta * cam_speed
				y += (-cam_to_y - y) * delta * cam_speed
				if(shake>0){
					shake-=delta
				
				x += (Math.random()-0.5)*shake * 10
				y += (Math.random()-0.5)*shake * 10
			}
if(rumble>0){

					rumble-=delta
				x += (Math.random()-0.5)*rumble * 5
				y += (Math.random()-0.5)*rumble * 15
}
		}

			player.distance_to_enemy = 9999
			player.closest_enemy = null
			
			
			for (var i = 0; i < enemies.length; i += 1) {
				var enemy_a = enemies[i]
				if (enemy_a.distance_to_player < player.distance_to_enemy){
					player.closest_enemy = enemy_a
					player.distance_to_enemy = enemy_a.distance_to_player
				}
				for (var j = i + 1; j < enemies.length; j++) {
					var enemy_b = enemies[j]
					
					var dx = (enemy_a.x - enemy_b.x)
					var dy = (enemy_a.y - enemy_b.y)
					var dist_sq = dx*dx + dy*dy
					
					var radius = enemy_a.size + enemy_b.size
					
					if (dist_sq < radius*radius && dist_sq > 0) {
						var dist = Math.sqrt(dist_sq)
						var direction_x = (enemy_a.x - enemy_b.x) / dist
						var direction_y = (enemy_a.y - enemy_b.y) / dist
						
						var overlap = 1.0 - dist / radius
						var push = overlap * delta * 100.0
						enemy_a.x += direction_x * push
						enemy_a.y += direction_y * push
						enemy_b.x -= direction_x * push
						enemy_b.y -= direction_y * push
						var push_strength = 1000.0 * overlap
						enemy_a.velocity_x += direction_x * push_strength * delta
						enemy_a.velocity_y += direction_y * push_strength * delta
						enemy_b.velocity_x -= direction_x * push_strength * delta
						enemy_b.velocity_y -= direction_y * push_strength * delta
					}
				}
			}
		}

		function process_sort() {
			var len = sort.length
			
			if (len <= 1) return
			len = Math.min(len, 30)
			
			for(var i: int = 0; i < len; i++) {
				if (sort_i >= sort.length)
					sort_i = 1
				
				var sorting_a = sort[sort_i-1]
				var sorting_b = sort[sort_i]
				if (sorting_a.y > sorting_b.y) {
					sort[sort_i-1] = sorting_b
					sort[sort_i] = sorting_a
					
					setChildIndex(sorting_a, sort_i+1)
					setChildIndex(sorting_b, sort_i)
					
				}
				
				sort_i += 1
			}
			
			var check_array = []
			for(i = 0; i < sort.length; i++) {
				check_array.push(sort[i].y)
			}
		}

		function compareNumbersDescending(a, b):int {
			if (a.y > b.y) {
				return 1
			} else if (a.y < b.y) {
				return -1
			} else {
				return 0
			}
		}
	}
	
}
