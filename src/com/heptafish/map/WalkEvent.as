/* 
	HeptaFishFramework
	@author JiYou Zheng
	@email heptaFish@163.com
	@website www.heptaFish.com
 */
package com.heptafish.map
{
	import flash.events.Event;
	
	public class WalkEvent extends Event
	{
		public static const WALK_START:String="walk_Start";
		public static const WALK_END:String = "walk_end";
		public static const ON_WALK:String  = "on_walk";
		private var _pathArray:Array;
		private var _mapNodeSize:uint;
		private var _moveToX:Number;
		private var _moveToY:Number;
		
		public function WalkEvent(type:String = null,par:Object = null) {
			super(type != null ? type : WALK_START);
		}
		public function set pathArray(pathArray:Array):void {
			_pathArray = pathArray;
		}
		public function get pathArray():Array {
			return _pathArray;
		}
		
		public function set mapNodeSize(mapNodeSize:uint):void {
			_mapNodeSize = mapNodeSize;
		}
		public function get mapNodeSize():uint {
			return _mapNodeSize;
		}
		
		public function set moveToX(moveToX:Number):void {
			_moveToX = moveToX;
		}
		public function get moveToX():Number {
			return _moveToX;
		}
		
		public function set moveToY(moveToY:Number):void {
			_moveToY = moveToY;
		}
		public function get moveToY():Number {
			return _moveToY;
		}
	}
}