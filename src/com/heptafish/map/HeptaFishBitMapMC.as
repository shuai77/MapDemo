/* 
	HeptaFishFramework
	@author JiYou Zheng
	@email heptaFish@163.com
	@website www.heptaFish.com
 */
package com.heptafish.map
{
	
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	/**
	 * 基础位图动画接口的实现类
	 * */
	public class HeptaFishBitMapMC extends BaseDisplayObject
	{			
		//速度
		protected var _speed:Number;
		//位图数据数组
		protected var _bitmapArr:Array;
		//当前帧显示的位图数据的索引
		private var _bitmapIndex:int=0;
		//当前要运行的
		private var _nowIndex:int;
		//计数器
		private var _count:Number=0;
		
		//动画开始 以横向的第几个index 开始
		private var _beginIndex:int;
		
		//动画结束 以横向的第几个index结束
		private var _endIndex:int;
		//用以显示的bitMap对象
		protected var _bitMap:Bitmap;
		
		//播放的顺序 0为横向 1为纵向
		private var _playDirection:int;
		//动画结束时的函数，空方法按需求补充
		public var end:Function;
		//是否正在播放
		private var _isPlaying:Boolean;
		//是否以镜像显示
		protected var _isMirror:Boolean;
		//位图相对坐标
		protected var _cx:Number;
		protected var _cy:Number;
		

		//构建函数
		public function HeptaFishBitMapMC(pic:Bitmap = null,row:int = 1,col:int = 1,beginIndex:int=0,endIndex:int=0,playDirection:int = 0,nowx:int = 0 ,nowy:int = 0,speed:Number = 0.27777,total:* = null,cx:Number = -1 , cy:Number = -1) {
			super();
			if(pic != null){
				//将传入的位图数据拆分成小块，装入bitmapArr
				_bitmapArr=HeptaFishCovert.divide(pic,row,col,total);
				_speed = speed;
				_beginIndex = beginIndex;
				_endIndex = endIndex;
				_playDirection = playDirection;
				_bitMap = new Bitmap();
				_bitMap.bitmapData=_bitmapArr[nowy][nowx];
				_cx = cx < 0 ? _bitMap.width/2 : cx;
				_cy = cy < 0 ? _bitMap.height : cy; 
				_bitMap.x = -_cx;
				_bitMap.y = -_cy;
				addChild(_bitMap);
				_bitMap.cacheAsBitmap = true;
			}
		}


		//开始动画
		public function startMove(nowCol:uint = 0):void {
			_nowIndex = nowCol;
			_bitmapIndex = _beginIndex;
			_isPlaying = true;
			if(_playDirection == HeptaFishConstant.KEY_BITMAPMC_PLAY_DIRECTION_TR){
				_bitMap.addEventListener(Event.ENTER_FRAME,moveFrameTR);
			}else if(_playDirection == HeptaFishConstant.KEY_BITMAPMC_PLAY_DIRECTION_LR){
				_bitMap.addEventListener(Event.ENTER_FRAME,moveFrameLR);
			}else{
				throw new Error("unknow playDirection!");
			}
		}
		
		//停止动画
		public function stopMove():void{
			_isPlaying = false;
			if(_playDirection == HeptaFishConstant.KEY_BITMAPMC_PLAY_DIRECTION_TR){
				_bitMap.removeEventListener(Event.ENTER_FRAME,moveFrameTR);
				_bitMap.bitmapData=_bitmapArr[_nowIndex][_endIndex];
			}else if(_playDirection == HeptaFishConstant.KEY_BITMAPMC_PLAY_DIRECTION_TR){
				_bitMap.removeEventListener(Event.ENTER_FRAME,moveFrameLR);
				_bitMap.bitmapData=_bitmapArr[_endIndex][_nowIndex];
			}else{
				throw new Error("unknow playDirection!");
			}
			HeptaFishGC.gc();
		}
		
		//重新开始动画
		public function restarMove():void{
			startMove(_nowIndex);
		}
		
		//ENTER_FRAME事件的方法,很简单了,就是根据速度来按顺序显示bitmapArr中的每个位图数据对象 横向播放的方法
		protected function moveFrameTR(e:Event):void {
			if (_bitmapIndex >= _bitmapArr[_nowIndex].length) {
				_count = 0;
				_bitmapIndex = _beginIndex;
			}
			_count+=_speed;
			_bitmapIndex+=int(_count) + 1;
			_count=_count%1;
			_bitMap.bitmapData=_bitmapArr[_nowIndex][_bitmapIndex<_bitmapArr[_nowIndex].length?_bitmapIndex:_bitmapArr[_nowIndex].length-1];
			
		}
		
		//ENTER_FRAME事件的方法,很简单了,就是根据速度来按顺序显示bitmapArr中的每个位图数据对象 纵向播放的方法
		protected function moveFrameLR(e:Event):void {
			if (_bitmapIndex >= _bitmapArr.length) {
				_count = 0;
				_bitmapIndex = _beginIndex;
			}
			_count+=_speed;
			_bitmapIndex+=int(_count) + 1;
			_count=_count%1;
			_bitMap.bitmapData=_bitmapArr[_bitmapIndex<_bitmapArr.length?_bitmapIndex:_bitmapArr.length-1][_nowIndex];
			
		}
		
		//镜像方法 显示实际图片的镜像图像
		public function mirror(value:int):void
		{
			scaleX = value;
		}
		
		public function get nowIndex():int{
			return _nowIndex;
		}
		
		
		public function get isPlaying():Boolean{
			return _isPlaying;
		}
		
		public function set nowIndex(value:int):void{
			this._nowIndex = value;
		}
		
		public function get bitmap():Bitmap{
			return _bitMap;
		}
		
	}
}