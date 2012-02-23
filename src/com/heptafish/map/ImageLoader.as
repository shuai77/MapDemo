/* 
	HeptaFishFramework
	@author JiYou Zheng
	@email heptaFish@163.com
	@website www.heptaFish.com
 */
package com.heptafish.map
{
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
        
    /**
    * 专门读取图片的Loader
    * 
    * */
    public class ImageLoader extends BaseLoader{
                
        public var _data:BitmapData;
                
        //构造函数
        public function ImageLoader(obj:Object = null,lc:LoaderContext = null) {
        	_type = HeptaFishConstant.TYPE_LOADER_IMAGELOADER;
            if(obj != null){
                if(obj is ByteArray){
                    loadBytes(obj as ByteArray,lc);
                }else if(obj is String){
                    load(obj as String,lc);
                }else{
                    throw new Error("参数错误，构造函数第一参数只接受ByteArray或String");
                }
            }
        }
        //加载成功，发布成功事件
        override protected function completeFun(e:Event):void {
            _data = _loader.content["bitmapData"];
			super.completeFun(e);
        }
                
        //清除
        override public function clear():void{
            _data = null;
            super.clear();
        }
    }
}