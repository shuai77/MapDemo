package com.heptafish.map
{
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	//地图层 图片
	public class MapLayer extends BaseDisplayObject
	{
		//图片读取器
		private var _imageLoader:ImageLoader;
		//地图图片 用于整块加载模式
		private var _image:Bitmap;
		//地图图片数组 用于栅格式加载地图模式
		private var _imageArr:Array;
		//小地图图片
		private var _simage:Bitmap;
		//
		private var _map:GameMap;
		private var _loadType:int;//加载类型 0：整块加载 1：栅格加载
		private var _visualWidth:Number;//地图可视宽度
		private var _visualHeight:Number;//地图可视高度
		private var _sliceWidth:Number;//地图切割单元宽度
		private var _sliceHeight:Number;//地图切割单元高度
		
		private var _screenImageRow:int;//一屏需要加载的横向图片数
		private var _screenImageCol:int;//一屏需要加载的纵向图片数
		
		public function MapLayer(map:GameMap)
		{
			_map = map;	
//			_visualWidth = _map.parent.width;
//			_visualHeight = _map.parent.height;
			_loadType = parseInt(_map.mapXML.@loadType);
		}
		//读取地图图片
		public function load():void{
			switch(_loadType){
				case 0://整块加载
					//加载小地图
//					var simageLoader:ImageLoader = new ImageLoader();
////					var sfileName:String =Config.getValue("mapLib") + _map.name + "/map_s.jpg";
//					var sfileName:String ="images/maps/" + _map.name + "/map_s.jpg";
//					simageLoader.addEventListener(Event.COMPLETE,loadSmallSuccess);
//					simageLoader.addEventListener(ProgressEvent.PROGRESS,loadingHandler);
//					simageLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
//					simageLoader.load(sfileName);
				
					//加载大地图
//					var bfileName:String =Config.getValue("mapLib") + _map.name + "/map.jpg";
					var bfileName:String ="images/maps/" + _map.name + "/map.jpg";
					var imageLoader:ImageLoader = new ImageLoader();
					imageLoader.addEventListener(Event.COMPLETE,loadBigSuccess);
					imageLoader.addEventListener(ProgressEvent.PROGRESS,loadingHandler);
					imageLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
					imageLoader.load(bfileName);
					break;
				case 1:
					_visualWidth = _map.app.screen.size.x;
					_visualHeight = _map.app.screen.size.y;
					_sliceWidth = parseFloat(_map.mapXML.@sliceWidth);
					_sliceHeight = parseFloat(_map.mapXML.@sliceHeight);
					_screenImageRow = Math.round(_visualWidth/_sliceWidth);
					_screenImageCol = Math.round(_visualHeight/_sliceHeight);
					
					
					//加载小地图
					var simageLoader:ImageLoader = new ImageLoader();
//					var sfileName:String =Config.getValue("mapLib") + _map.name + "/map_s.jpg";
					var sfileName:String ="images/maps/" + _map.name + "/map_s.jpg";
					simageLoader.load(sfileName);
					simageLoader.addEventListener(Event.COMPLETE,loadSmallSuccess);
					simageLoader.addEventListener(ProgressEvent.PROGRESS,loadingHandler);
					simageLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
					
					loadSliceImage(_map.initPlayerPoint);
					break;
				default:
					break;
					
			}
		}
		//读取大地图成功
		private function loadBigSuccess(evet:Event):void{
			var imageLoader:ImageLoader = ImageLoader(evet.target);
			var image:Bitmap = new Bitmap(imageLoader._data);
			addChild(image);
			if(_simage != null && _simage.parent == this){
				removeChild(_simage);
				_simage = null;
			}
			this.width = image.width;
			this.height = image.height;
			imageLoader.removeEventListener(Event.COMPLETE,loadBigSuccess);
			imageLoader = null;
			dispatchEvent(evet);
			HeptaFishGC.gc();
		}
		//读取小地图成功
		private function loadSmallSuccess(evet:Event):void{
			var imageLoader:ImageLoader = ImageLoader(evet.target);
			var image:Bitmap = new Bitmap(imageLoader._data);
			image.width = _map.mapWidth;
			image.height = _map.mapHeight;
			addChild(image);
			this.width = image.width;
			this.height = image.height;
			imageLoader.removeEventListener(Event.COMPLETE,loadSmallSuccess);
			imageLoader = null;
			dispatchEvent(evet);
			HeptaFishGC.gc();
		}
		
		//根据player坐标读取周边2屏地图
		private function loadSliceImage(playerPoint:Point):void{
			var nowX:int = Math.round(playerPoint.x/_sliceWidth);
			var nowY:int = Math.round(playerPoint.y/_sliceHeight);
			
			
		}

	}
}