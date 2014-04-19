package com.njnulab 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author kiwind
	 */
	public class LightNum extends MovieClip
	{
		private var id:uint;
		private var _txt:TextField;
		public function LightNum() 
		{
			this.scaleX = this.scaleY = 0.7;
			_txt = this.getChildByName("t_num") as TextField;
		}
		
		public function set Id(value:uint):void 
		{
			id = value;
		}
		
		public function get Id():uint { return id; }
		
		public function set Num(value:String):void 
		{
			_txt.text = value;
		}
		
		public function get Num():String { return _txt.text; }
	}

}