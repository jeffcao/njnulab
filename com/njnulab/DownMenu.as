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
	public class DownMenu extends MovieClip
	{
		private var clickEvent:String;
		public function DownMenu() 
		{
			clickEvent = Global.getClickEvent();
			btn1.addEventListener(clickEvent, handle1);
			btn2.addEventListener(clickEvent, handle2);
			btn3.addEventListener(clickEvent, handle3);
			btn4.addEventListener(clickEvent, handle4);
		}
		
		private function handle1(event:Event):void
		{
			dispatchEvent(new Event("clickHome"));
		}
		
		private function handle2(event:Event):void
		{
			dispatchEvent(new Event("clickLab"));
		}
		
		private function handle3(event:Event):void
		{
			dispatchEvent(new Event("clickSys"));
		}
		
		private function handle4(event:Event):void
		{
			dispatchEvent(new Event("clickSetting"));
		}
	}

}