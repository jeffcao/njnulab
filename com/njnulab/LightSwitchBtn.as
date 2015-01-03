package com.njnulab 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author kiwind
	 */
	public class LightSwitchBtn extends MovieClip
	{
		private var id:uint;
		private var dataArry:Array;
		private var numArry:Array = [];
		private var numBox:Sprite;
		private var state:uint = 0;
		private var _y = 15;
		
		public function LightSwitchBtn() 
		{
			buttonMode =  useHandCursor = true;
			numBox = new Sprite();
			addChild(numBox);
			numBox.x = 90;
			numBox.visible = false;
		}
		
		public function init(dArry:Array):void
		{
			trace("LightSwitchBtn.init, dbArray: " + dArry)
			clear();
			if (dArry.length == 0)
			{
				return;
			}
			
			for (var i:uint = 0; i < dArry.length; i++ )
			{
				var ln:LightNum =  new LightNum();
				numArry.push(ln);
				ln.Id = dArry[i];
				ln.Num = (dArry[i]+1).toString();
				numBox.addChild(ln);
				ln.x = (ln.width + 7) * (i%5);
				ln.y = _y;
				if (dArry.length > 5)
				{
					ln.y = 6 + (ln.height-3) * uint(i / 5);
				}
			}
		}
		
		public function addNum(id:uint):void
		{
			var ln:LightNum =  new LightNum();
			numArry.push(ln);
			ln.Id = id;
			ln.Num = (id + 1).toString();
			ln.alpha = 0;
			numBox.addChild(ln);
			ln.x = 0;
			ln.y = 10;
			numArry.sort(function(a,b) {
				var an:uint = uint(a.Num);
				var bn:uint = uint(b.Num);
				return an - bn;
			});
			//removeBoxChildren();
			//putNumItem();
			/*for (var i:uint = 0; i < numArry.length; i++ )
			{
				numBox.addChild(numArry[i]);
				numArry[i].alpha = 0;
				numArry[i].x = 0;
				numArry[i].y = 10;
				TweenLite.to(numArry[i], 0.5, { alpha:1,x:(numArry[i].width + 7) * i } );
			}*/
		}
		
		public function reduceNum(id:uint):void
		{
			for (var i:uint = 0; i < numArry.length; i++ )
			{
				if (numArry[i].Id == id)
				{
					numArry.splice(i, 1);
				}
			}
			//removeBoxChildren();
			//putNumItem();
		}
		
		public function putNumItem():void
		{
			for (var i:uint = 0; i < numArry.length; i++ )
			{
				numBox.addChild(numArry[i]);
				numArry[i].alpha = 0;
				numArry[i].x = (numArry[i].width + 7) * (i%5);
				numArry[i].y = _y;
				if (numArry.length > 5)
				{
					numArry[i].y = 6 + (numArry[i].height-3) * uint(i / 5);
				}
				TweenLite.to(numArry[i], 0.5, { alpha:1 } );
			}
		}
		
		public function clear():void
		{
			numArry.length = 0;
			removeBoxChildren();
		}
		
		public function removeBoxChildren():void
		{
			while (numBox.numChildren > 0)
			{
				numBox.removeChildAt(0);
			}
		}
		
		public function set Id(value:uint):void 
		{
			id = value;
		}
		
		public function get Id():uint { return id; }
		
		public function set DataArry(value:Array):void 
		{
			dataArry = value;
		}
		
		public function get DataArry():Array { return dataArry; }
		
		public function set State(value:uint):void 
		{
			state = value;
		}
		
		public function get State():uint { return state ; }
	}

}