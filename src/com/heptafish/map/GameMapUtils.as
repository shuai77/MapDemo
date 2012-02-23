package com.heptafish.map
{
	
	import flash.geom.Point;
	public class GameMapUtils
	{
		public function GameMapUtils()
		{
		}
		
		//根据字符串得到数组
		public static function getArrByStr(arrayStr:String,col:int,row:int):Array{
			var _mapArray:Array = new Array();
			var arr:Array  = arrayStr.split(",");
			var index:uint = 0;
			for(var i:uint = 0 ; i < row;i++){
				var tempArr:Array = new Array();
				for(var j:uint = 0 ; j < col; j++){
					tempArr.push(arr[index]);
					index++;
				}
				_mapArray.push(tempArr);
			}
			return _mapArray;
		}
		
		 //根据屏幕象素坐标取得网格的坐标
		public static function getCellPoint(tileWidth:int, tileHeight:int, px:int, py:int):Point
		{
			var xtile:int = 0;	//网格的x坐标
			var ytile:int = 0;	//网格的y坐标
	
	        var cx:int, cy:int, rx:int, ry:int;
	        cx = int(px / tileWidth) * tileWidth + tileWidth/2;	//计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标
	        cy = int(py / tileHeight) * tileHeight + tileHeight/2;//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
	
	        rx = (px - cx) * tileHeight/2;
	        ry = (py - cy) * tileWidth/2;
	
	        if (Math.abs(rx)+Math.abs(ry) <= tileWidth * tileHeight/4)
	        {
				//xtile = int(pixelPoint.x / tileWidth) * 2;
				xtile = int(px / tileWidth);
				ytile = int(py / tileHeight) * 2;
	        }
	        else
	        {
				px = px - tileWidth/2;
				//xtile = int(pixelPoint.x / tileWidth) * 2 + 1;
				xtile = int(px / tileWidth) + 1;
				
				py = py - tileHeight/2;
				ytile = int(py / tileHeight) * 2 + 1;
			}

			return new Point(xtile - (ytile&1), ytile);
		}
		
		/**
		 *根据逻辑坐标得到直角坐标 
		 * @param logic
		 * @param row
		 * @return 
		 * 
		 */		
		public static function getDirectPoint(logic:Point,row:int):Point{
			var dPoint:Point = new Point();//直角坐标点
			if(logic.y & 1){
				dPoint.x = Math.floor(( logic.x - logic.y / 2 ) + 1 + (row-1)/2);
			}else{
				dPoint.x = ( logic.x - logic.y / 2 ) + Math.ceil((row-1)/2);
			}
			dPoint.y = Math.floor(( logic.y / 2 ) + logic.x + ( logic.y & 1 ));
			return dPoint;
		}
		/**
		 *根据像素坐标得到直角坐标 
		 * @param tileWidth
		 * @param tileHeight
		 * @param px
		 * @param py
		 * @param row
		 * @return 
		 * 
		 */		
		public static function getDirectPointByPixel(tileWidth:int, tileHeight:int, px:int, py:int,row:int):Point{
			
			return getDirectPoint(getCellPoint(tileWidth,tileHeight,px,py),row);
		}
		
		/**
		 * 根据网格坐标取得象素坐标 
		 * @param tileWidth
		 * @param tileHeight
		 * @param tx
		 * @param ty
		 * @return 
		 * 
		 */		
		public static function getPixelPoint(tileWidth:int, tileHeight:int, tx:int, ty:int):Point
		{
			//偶数行tile中心
			var tileCenter:int = (tx * tileWidth) + tileWidth/2;
			// x象素  如果为奇数行加半个宽
			var xPixel:int = tileCenter + (ty&1) * tileWidth/2;
			
			// y象素
			var yPixel:int = (ty + 1) * tileHeight/2;
			
			return new Point(xPixel, yPixel);
		}
		
		//根据数组得到字符串
		public static function getStrByArr(arr:Array,type:int = 0):String{
				var result:String = "";
				for(var i:uint = 0; i < arr.length;i++){
					for(var j:uint = 0; j < arr[0].length;j++){
						var cell:int = arr[i][j];
						var temp:String;
						switch(cell){
							case HetapFishGameConstant.MAPEDITOR_CELL_TYPE_ROAD:
								temp = "0";
								break;
							case HetapFishGameConstant.MAPEDITOR_CELL_TYPE_HINDER:
								temp = "1";
								break;
							case HetapFishGameConstant.MAPEDITOR_CELL_TYPE_SPACE:
								if(type == HetapFishGameConstant.TYPE_SAVE_MAP_ROAD){
									temp = "0";
								}else if(type == HetapFishGameConstant.TYPE_SAVE_MAP_HINDER){
									temp = "1";
								}
								break;
							default:
								throw new Error("地图信息数组中有未知因素！");
								break;
							
						}
						if(result.length > 0){
							result+=",";
						}
						result += temp;
					}
				}
				return result;
			}
			/**
			 *根据地图编辑器坐标信息 得到地图直角坐标信息数组 
			 * @param arr
			 * @param row
			 * @param col
			 * @param raodMap
			 * @return 
			 * 
			 */			
			public static function getDArrayByArr(arr:Array,row:int,col:int,raodMap:HashMap):Array{
				var dArr:Array = new Array();
				var exdp:Point = getDirectPoint(new Point(col,0),row);
				var eydp:Point = getDirectPoint(new Point(col,row),row);
				
				
				for(var yy:int = 0;yy<eydp.y+1;yy++){
					var tempArr:Array = new Array;
					for(var xx:int = 0;xx<exdp.x+1;xx++){
						tempArr[xx] = new Object();
						tempArr[xx].value = 0;
//						tempArr[xx] = 0;
//						tempArr[xx].dx = xx;
//						tempArr[xx].dy = yy;
					}
					dArr.push(tempArr);
				}
//				var maxX:int = 0;
//				var maxY:int = 0;
				for(var yyy:int = 0;yyy < row;yyy++){
					for(var xxx:int = 0;xxx < col;xxx++){
						var dp:Point = getDirectPoint(new Point(xxx,yyy),row);
//						if(dp.x > maxX){
//							maxX = dp.x;
//						}
//						if(dp.y > maxY){
//							maxY = dp.y;
//						}
						dArr[dp.y][dp.x].value = arr[yyy][xxx];
						dArr[dp.y][dp.x].px = xxx;
						dArr[dp.y][dp.x].py = yyy;
						var op:Point = new Point(xxx,yyy);
						raodMap.put(dp.y+"-"+dp.x,dArr[dp.y][dp.x]);
					}
				}
//				trace("maxX : " + maxX);
//				trace("maxY : " + maxY);
//				trace("dArr.length  : " + dArr.length);
//				trace("dArr[0].length  : " + dArr[0].length);
				
				return dArr;
			}
			
			
		//根据像素坐标得到直角坐标
		public static function getMaxDirectPoint(row:int, col:int):Point{
			var exdp:Point = getDirectPoint(new Point(col,0),row);
			var eydp:Point = getDirectPoint(new Point(col,row),row);
			return new Point(exdp.x,eydp.y);
		}

	}
}