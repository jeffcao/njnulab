package com.njnulab 
{
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author kiwind
	 */
	public class WindowSwitchBtn extends MovieClip
	{
		private var id:uint;
		public function WindowSwitchBtn() 
		{
			buttonMode =  useHandCursor = true;
		}
		
		public function set Id(value:uint):void 
		{
			id = value;
		}
		
		public function get Id():uint { return id; }
	}

}