/* 
	HeptaFishFramework
	@author JiYou Zheng
	@email heptaFish@163.com
	@website www.heptaFish.com
 */
package com.heptafish.map
{
	import flash.net.LocalConnection;
	
	/**
	 * 
	 * 垃圾清理工具类
	 * 
	 * */
	public class HeptaFishGC
	{
		public function HeptaFishGC()
		{
		}
		
		/**
		 * 强制执行垃圾清理
		 * */
		public static function gc():void{
			try{
				new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
			}catch(e:Error){
				
			}
		}

	}
}