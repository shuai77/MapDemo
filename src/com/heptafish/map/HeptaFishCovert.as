/* 
	HeptaFishFramework
	@author JiYou Zheng
	@email heptaFish@163.com
	@website www.heptaFish.com
 */
package com.heptafish.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;
	
	/**
	 * 裁剪工具类
	 * */
	public class HeptaFishCovert
	{
		public function HeptaFishCovert()
		{
		}
		
		/**
		 * 拆分位图
		 * @return Array 返回被拆分的位图数组
		 * @parameter source:Bitmap 要拆分的位图对象
		 * @parameter row:int 要拆分的位图对象的行数
		 * @parameter col:int 要拆分的位图对象的列数
		 * @parameter total:* = null 要拆分的位图对象的总数
		 * */
		public static function divide(source:Bitmap,row:int,col:int,total:* = null):Array {
			//计算出每个小位图对象的宽度
			var w:uint=source.width/row;
			//计算出每个小位图对象的高度
			var h:uint=source.height/col;
			//计算有效位图总数
			total=total==null?col*row:total;
			//定义结果数组
			var result:Array= new Array();
			//定义矩阵
			var matrix:Matrix = new Matrix();
			//定义矩形
			var rect:Rectangle=new Rectangle(0,0,w,h);
			out:for (var j:int = 0; j < col; j++) {
				var tempArr:Array = new Array();
				for (var i:int = 0; i < row; i++) {
					if (total<=0) {
						break out;
					}
					//new出一个白色的小位图对象
					var bmp:BitmapData=new BitmapData(w,h,true,0x00000000);
					//定义矩阵的焦点
					matrix.tx=- i*w;
					matrix.ty=- j*h;
					//将矩阵内的数据按定义好的矩形大小和相应位置,画出小位图对象像素
					bmp.draw(source,matrix,null,null,rect,true);
					tempArr.push(bmp);
					total--;
				}
				result.push(tempArr);
			}
			return result;
		}
	}
}