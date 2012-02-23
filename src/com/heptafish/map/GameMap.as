package com.heptafish.map
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.Application;
	
	public class GameMap extends BaseDisplayObject
	{
		
		private var _player:HeptaFishCharacter;//人物
		private var _mapWidth:Number;//地图宽度
		private var _mapHeight:Number;//地图高度
		private var _cellWidth:Number;//地图单元格宽度
		private var _cellHeight:Number;//地图单元格高度
		private var _itemArr:Array;//地图元件数组
		private var _mapArr:Array;//地图信息数组
		private var _mapDArr:Array;//地图直角坐标数组
		private var _mapXML:XML;//地图信息XMl
		private var _row:int;//纵向节点数
		private var _col:int;//横向节点数
		private var _pathIndex:int;//
		
		private var _mapLayer:MapLayer;//地图层 
		private var _buildLayer:BuildingLayer;//建筑层
		private var _gridLayer:GridLayer;//网格层
		private var _roadPointLayer:RoadPointLayer;//路点层
		
		private var _initPlayerPoint:Point;//初始时人物坐标
		
//		private var _mapName:String;//地图名称

		
		
		private var _roadSeeker:RoadSeeker;
		private var _roadArr:Array;
		private var _roadMap:HashMap = new HashMap();
		
		private var _app:Application;

		
		
		public function GameMap(mapXML:XML,app:Application,playerPoint:Point = null)
		{
//			super(app);
			this._app = app;
			_mapXML = mapXML;
			this.name = _mapXML.@name;
			_initPlayerPoint = playerPoint||new Point(30,80);
			_mapWidth = _mapXML.@mapwidth;
			_mapHeight = _mapXML.@mapheight;
			_cellWidth = _mapXML.floor.@tileWidth;
			_cellHeight = _mapXML.floor.@tileHeight;
			_mapArr = GameMapUtils.getArrByStr(_mapXML.floor,_mapXML.floor.@col,_mapXML.floor.@row);
			_row = _mapArr.length;
			_col = _mapArr[0].length;
			_mapDArr = GameMapUtils.getDArrayByArr(_mapArr,_row,_col,_roadMap);
			_roadSeeker = new RoadSeeker(_mapDArr,_cellWidth,_cellHeight*2);
			initMap();
		}
		//初始化
		private function initMap():void{
//			var depMode:String = String(Config.getValue("depMode"));
			_mapLayer = new MapLayer(this);
			addChild(_mapLayer);

			
			
			///如果需要加载网格和路点层 撤销如下注释
				_gridLayer = new GridLayer(this);
				_gridLayer.drawGrid(_mapWidth,_mapHeight,_cellWidth,_cellHeight);
				addChild(_gridLayer);
				_roadPointLayer = new RoadPointLayer(this);
				_roadPointLayer.drawArr(_mapArr,_mapXML.@roadType);
				addChild(_roadPointLayer);
			
			_buildLayer = new BuildingLayer(this);
			addChild(_buildLayer);
			_mapLayer.addEventListener(Event.COMPLETE,mapLayerLoaded);
			_mapLayer.load();
			_buildLayer.drawByXml(_mapXML);
		}
		
		//加入用户角色
		public function addPlayer(player:HeptaFishCharacter):void{
			_player = player;
			_player.mapEle = this;
			_player.x = _initPlayerPoint.x;
			_player.y = _initPlayerPoint.y;
//			addItem(player);
			_buildLayer.addChild(player as DisplayObject);
		}
		//地图层加载完成
		private function mapLayerLoaded(evet:Event):void{
			
		}
		//地图点击事件
		public function onClick(event:Event):void{
//			var __nodePoint:Point = GameMapUtils.getCellPoint(_cellWidth,_cellHeight,event.currentTarget.mouseX,event.currentTarget.mouseY);
			var _nodeRPoint:Point = GameMapUtils.getDirectPointByPixel(_cellWidth,_cellHeight,event.currentTarget.mouseX,event.currentTarget.mouseY,_row);
			//直角坐标系x
			var __nodeX:int = _nodeRPoint.x;
			var __nodeY:int = _nodeRPoint.y;
			
//			var __rolePoint:Point = GameMapUtils.getCellPoint(_cellWidth,_cellHeight,_player.x,_player.y);
			var _roleRPoint:Point = GameMapUtils.getDirectPointByPixel(_cellWidth,_cellHeight,_player.x,_player.y,_row);
			var __roleX:int = _roleRPoint.x;
			var __roleY:int = _roleRPoint.y;
			var __length:int;
			_player.moveToX = event.currentTarget.mouseX;
			_player.moveToY = event.currentTarget.mouseY;
//			trace("__nodeX : " + __nodeX);
//			trace("__nodeY : " + __nodeY);
//			trace("__roleX : " + __roleX);
//			trace("__roleY : " + __roleY);
			var maxP:Point = GameMapUtils.getMaxDirectPoint(_row,_col);
			//在地图范围内，并且不是障碍物
			if(__nodeX>=0 && __nodeX<maxP.x && __nodeY>=0 && __nodeY<maxP.y && _roadSeeker.value(__nodeX, __nodeY)==0){
				_roadArr =_roadSeeker.path8(new Point(__roleX, __roleY), new Point(__nodeX, __nodeY));
				__length = _roadSeeker.path.length;
//				trace(__length);
				if(__length>0){
					_pathIndex = 1;
//					trace("_roadSeeker.path[_pathIndex].x : " + _roadSeeker.path[_pathIndex].x);
//					trace("_roadSeeker.path[_pathIndex].y : " + _roadSeeker.path[_pathIndex].y);
//					trace("px : " + _roadMap.getValue(_roadSeeker.path[_pathIndex].y+""+_roadSeeker.path[_pathIndex].x).px);
//					trace("py : " + _roadMap.getValue(_roadSeeker.path[_pathIndex].y+""+_roadSeeker.path[_pathIndex].x).py);

					var px:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).px;
					var py:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).py;
					
//					trace("px : " + px);
//					trace("py : " + py);
					_player.addEventListener(WalkEvent.WALK_END, onMoveOver);
					_player.addEventListener(WalkEvent.ON_WALK,checkDep);
					var tp:Point = GameMapUtils.getPixelPoint(_cellWidth,_cellHeight,px,py);
					_player.moveTo(tp.x, tp.y+_cellHeight);
				}
			}
		}
		//一段路程移动完成
		protected function onMoveOver(event:Event):void{
			var player:HeptaFishCharacter = event.target as HeptaFishCharacter;
			if(_pathIndex<_roadArr.length-1){
				_pathIndex++;
				if(_pathIndex==_roadArr.length){
					player.moveTo(player.moveToX, player.moveToY);
				}else{
					var px:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).px;
					var py:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).py;
					_player.addEventListener(WalkEvent.WALK_END, onMoveOver);
					var tp:Point = GameMapUtils.getPixelPoint(_cellWidth,_cellHeight,px,py);
					_player.moveTo(tp.x, tp.y+_cellHeight);
				}
			}else{
				player.removeEventListener(WalkEvent.WALK_END, onMoveOver);
			}
		}
		//移动中 检查深度
		private function checkDep(evet:WalkEvent):void{
			for each(var bl:* in _buildLayer.buildingArray){
				if(bl is GameMapItem){
					if(bl.bitMap.hitTestObject(_player as DisplayObject)){
//						trace(2);
						if(_player.y < bl.y + bl.bitMap.height){
							if(_buildLayer.getChildIndex(_player as DisplayObject) > _buildLayer.getChildIndex(bl)){
								_buildLayer.swapChildren(_player as DisplayObject, bl);
//								var rect:Rectangle = new Rectangle(_player.x, _player.y, _player.width, _player.height);
//								var pt:Point = new Point(0,0);
//								_player.filter.threshold(bl.bitMap.bitmapData, rect, pt, ">", 0x00000000, 0x80000000);
//								_player.bitmap.bitmapData.copyPixels(_player.bitmap.bitmapData, _player.rect, pt, _player.filter, pt, false);
								
							}
						}else{
							if(_buildLayer.getChildIndex(_player as DisplayObject) < _buildLayer.getChildIndex(bl)){
								_buildLayer.swapChildren(_player as DisplayObject, bl);
							}
						}
					}
				}
			}
		}
		
		
		
		public function get cellWidth():Number{
			return _cellWidth
		}
		public function get cellHeight():Number{
			return _cellHeight
		}
		
		public function get mapWidth():Number{
			return _mapWidth
		}
		public function get mapHeight():Number{
			return _mapHeight
		}
		
		public function get mapXML():XML{
			return _mapXML;
		}
		
		public function get initPlayerPoint():Point{
			return _initPlayerPoint;
		}
		
		public function get app():Application{
			return _app;
		}
	}
}