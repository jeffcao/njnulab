package com.njnulab 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	/**
	 * ...
	 * @author ...
	 */
	public class Global extends Sprite
	{
		public static var stage = stage;
		public static var isTouch:Boolean = Multitouch.supportsTouchEvents?true:false;
		public static var clickEvent:String;
		public static var gateIp = "192.168.1.6";
		public static var authCode = "Basic YWRtaW46MTIzNDU2";
		public function Global() 
		{
			
		}
		
		
		public static function getClickEvent():String {
			if (isTouch)
			{
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				clickEvent = TouchEvent.TOUCH_BEGIN;
			}
			else
			{
				clickEvent = MouseEvent.CLICK;
			}
			return clickEvent; 
		}
		
		public static function isInArry(v:uint,a:Array):Boolean
		{
			var flag:Boolean = false;
			for (var i:uint = 0; i < a.length; i++ )
			{
				if (a[i] == v)
				{
					flag = true;
					break;
				}
			}
			return flag;
		}
		
		public static function getCorrectUrl(strUrl:String):String
		{
			trace("Global.getCorrectUrl, strUrl: " +strUrl);
			var newUrl =  strUrl.split("192.168.1.6").join(Global.gateIp);
			trace("Global.getCorrectUrl, after replace, newUrl: " +newUrl);
			return newUrl;
		}
	}

}