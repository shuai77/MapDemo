package com.heptafish.map
{
	
	import flash.display.Shape;
	
	public class GridLayer extends BaseDisplayObject
	{
		
		
		private var _mapWidth:int;		//地图网格宽度
		private var _mapHeight:int;		//地图网格高度
		
		private var _tilePixelWidth:int;	//一个网格的象素宽
		private var _tilePixelHeight:int;	//一个网格的象素高
		
		private var _gridLineColor:uint = 0xbbbbbb;//线条颜色
		
		
		private var _wHalfTile:int;	//网格象素宽的一半
		private var _hHalfTile:int;	//网格象素高的一半
		
		private var _map:GameMap;
		
		
		public function GridLayer(map:GameMap)
		{
			_map = map;
		}
		
		//画制网格
		public function drawGrid(mapWidth:int, mapHeight:int, tilePixelWidth:int, tilePixelHeight:int):void
		{
			
			this._mapWidth = mapWidth;
			this._mapHeight = mapHeight;
			this._tilePixelWidth = tilePixelWidth;
			this._tilePixelHeight = tilePixelHeight;
			var row:int = this._mapHeight/this._tilePixelHeight;
			var col:int = this._mapWidth/this._tilePixelWidth; 
			this._wHalfTile = int(this._tilePixelWidth/2);
			this._hHalfTile = int(this._tilePixelHeight/2); 
			var grid:Shape = new Shape();
			this.addChild(grid);
			
			grid.graphics.lineStyle(1, _gridLineColor, 1);
			
			var dblMapWidth:int = col*2 + 1;
			var dblMapHeight:int = row*2 + 1;
			for (var i:int=1; i<dblMapWidth; i=i+2)
			{
				
				grid.graphics.moveTo( i*this._wHalfTile, 0 );
				if (dblMapHeight+i >= dblMapWidth)
				{
					grid.graphics.lineTo( dblMapWidth*this._wHalfTile, (dblMapWidth-i)*this._hHalfTile );
				}
				else
				{
					grid.graphics.lineTo( (dblMapHeight+i)*this._wHalfTile, dblMapHeight*this._hHalfTile );
				}
			
				grid.graphics.moveTo( i*this._wHalfTile, 0 );
				if (i <= dblMapHeight)
				{
					grid.graphics.lineTo( 0, i*this._hHalfTile );
				}
				else
				{
					grid.graphics.lineTo( (i-row-1)*this._wHalfTile, dblMapHeight*this._hHalfTile );
				}
			}
			
			for (var j:int=1; j<dblMapHeight; j=j+2)
			{
		
				grid.graphics.moveTo( 0, j*this._hHalfTile );
				if (dblMapHeight-j >= dblMapWidth)
				{
					grid.graphics.lineTo( dblMapWidth*this._wHalfTile, (dblMapWidth+j)*this._hHalfTile );
				}
				else
				{
					grid.graphics.lineTo( (dblMapHeight-j)*this._wHalfTile, dblMapHeight*this._hHalfTile );
				}
			}
			
			for (var m:int=0; m<dblMapHeight; m=m+2)
			{
				grid.graphics.moveTo( dblMapWidth*this._wHalfTile, m*this._hHalfTile );
				if (dblMapWidth-dblMapHeight+m < 0)
				{
					grid.graphics.lineTo( 0, (dblMapWidth+m)*this._hHalfTile );
				}
				else
				{
					grid.graphics.lineTo( (dblMapWidth-dblMapHeight+m)*this._wHalfTile, dblMapHeight*this._hHalfTile );
				}
			}
			//重设宽高，滚动条用
//			this.width = col * this._tilePixelWidth + this._tilePixelWidth/2;
//			this.height = (row + 1) * this._tilePixelHeight / 2;
		}
		
		

	}
}