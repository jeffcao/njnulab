package com.njnulab 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author kiwind
	 */
	public class LightPanel extends MovieClip
	{
		public var lightArry:Array = [];
		public var index:uint;
		public function LightPanel() 
		{
			for (var i:uint = 0; i < 6; i++ )
			{
				lightArry.push(this.getChildByName("light" + i) as MovieClip);
				lightArry[i].buttonMode = lightArry[i].useHandCursor = true;
				lightArry[i].mouseChildren = false;
				lightArry[i].addEventListener(Main.clickEvent, clickHandle);
			}
		}
		
		private function clickHandle(event:Event):void
		{
			var light:MovieClip = event.target as MovieClip;
			index = uint(light.name.substr(5, 1));
			var ck:MovieClip = light.getChildByName("ck") as MovieClip;
			if (ck.currentFrame == 1)
			{
				ck.gotoAndStop(2);
				if (LightSystem.kgFlag == 1)
				{
					light.gotoAndStop(2);
				}
			}
			else
			{
				ck.gotoAndStop(1);
				light.gotoAndStop(1);
			}
			dispatchEvent(new Event("clickLight"));
		}
		
		public function getSelected():Array
		{
			var arry:Array = [];
			for (var i:uint = 0; i < lightArry.length; i++ )
			{
				if (lightArry[i].ck.currentFrame == 2)
				{
					arry.push(i);
				}
			}
			return arry;
		}
		
		public function reset():void
		{
			for (var i:uint = 0; i < lightArry.length; i++ )
			{
				lightArry[i].gotoAndStop(1);
				lightArry[i].ck.gotoAndStop(1);
			}
		}
	}

}