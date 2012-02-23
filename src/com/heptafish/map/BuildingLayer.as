package com.heptafish.map
{
	import flash.display.BitmapData;
	
	public class BuildingLayer extends BaseDisplayObject
	{
		public var _buildingArray:Array;	//所有building数组，数组索引对应building id
		private var _maxNum:int = 0;		//建筑数	
		private var _map:GameMap;	
		private var _imageDataMap:HashMap;//存放地图元件图片信息的map
		
		public function BuildingLayer(map:GameMap)
		{
			_map = map;
			_buildingArray = new Array();
			_imageDataMap = new HashMap();
		}
		
		//读取XML配置 放置建筑
		public function drawByXml(mapXml:XML):void{
			for each(var item:XML in mapXml.items.item){
				var bl:GameMapItem = new GameMapItem();
				bl.parentLayer = this;
				bl.x = item.@px;
				bl.y = item.@py;
				var imageData:BitmapData = BitmapData(_imageDataMap.getValue(item.@file[0]));
				if(imageData != null){
					bl.reset(imageData,item);
				}else{
					bl.configXml = item;
					bl.loadImage();
				}
				_buildingArray.push(bl);
				this.addChild(bl);
			}
		}
		
		public function get imageDataMap():HashMap{
			return _imageDataMap;
		}
		
		public function get buildingArray():Array{
			return _buildingArray;
		}

	}
}