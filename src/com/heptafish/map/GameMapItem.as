package com.heptafish.map
{
		
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class GameMapItem extends BaseDisplayObject
	{
		private var _bitMap:Bitmap;//显示图像
		private var _configXml:XML;//配置
		private var _init:Boolean = false;//是否初始化完成
		private var _imageLoader:ImageLoader;//图片载入器
		
		private var _parentLayer:BuildingLayer;
		
		public function GameMapItem()
		{
			
		}
		
		
		public function reset(bitMapData:BitmapData,configXml:XML):void{
			if(numChildren > 0)
				removeChildAt(0);
			_bitMap = new Bitmap(bitMapData);
			addChild(_bitMap);
			_configXml = configXml;
		}
		
		public function imageLoaded(evet:Event):void{
			_bitMap = new Bitmap(_imageLoader._data);
			_parentLayer.imageDataMap.put(_imageLoader.url,_imageLoader._data);
			addChild(_bitMap);
			_imageLoader.removeEventListener(Event.COMPLETE,imageLoaded);
			_imageLoader = null;
			HeptaFishGC.gc();
		}
		//读取图片 src参数是指基础文件路径 指在地图文件中配置的建筑图片路径之前的路径
		public function loadImage(src:String = ""):void{
			_imageLoader = new ImageLoader();
			_imageLoader.addEventListener(Event.COMPLETE,imageLoaded);
			_imageLoader.load(src + _configXml.@file[0]);
		}
		
		public function get configXml():XML{
			return _configXml;
		}
		public function set configXml(configXml:XML):void{
			_configXml = configXml;
		}
		
		
		public function get bitMap():Bitmap{
			return _bitMap;
		}
		public function set bitMap(bitMap:Bitmap):void{
			_bitMap = bitMap;
		}
		
		
		public function get parentLayer():BuildingLayer{
			return _parentLayer;
		}
		public function set parentLayer(parentLayer:BuildingLayer):void{
			_parentLayer = parentLayer;
		}

	}
}