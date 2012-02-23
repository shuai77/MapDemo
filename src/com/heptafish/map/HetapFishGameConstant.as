/* 
	HeptaFishFramework
	@author JiYou Zheng
	@email heptaFish@163.com
	@website www.heptaFish.com
 */
package com.heptafish.map
{
	public class HetapFishGameConstant
	{
		
		public static const CHARACTER_COMMOND_ARRAY:Array = ["down","rightDown","right","rightUp","up","leftUp","left","leftDown"];
		
		/* 地图类型：45度地图 */
		public static const GAMEMAP_TYPE_FFD:String = "ffd";
		/* 地图格子类型 可通过 */
		public static const MAP_CELL_TYPE_SPACE:int = 0;
		/* 地图格子类型 地图组件占用 */
		public static const MAP_CELL_TYPE_ITEM:int = 1;
		/* 地图格子类型 路店 */
		public static const MAP_CELL_TYPE_ROADPOINT:int = 2;
		
		
		//地图格类型 空白低点 最后会根据设置 转换为相应不可移动或者可移动区域
		public static const MAPEDITOR_CELL_TYPE_SPACE:int = 0;
		
		//地图格类型 路点
		public static const MAPEDITOR_CELL_TYPE_ROAD:int = 1;
		//地图格类型 障碍
		public static const MAPEDITOR_CELL_TYPE_HINDER:int = 2;
		
		//保存时将空白区域转换为路点
		public static const TYPE_SAVE_MAP_ROAD:int = 0;
		//保存时将空白区域转换为障碍
		public static const TYPE_SAVE_MAP_HINDER:int = 1;
		
		public function HetapFishGameConstant()
		{
		}

	}
}