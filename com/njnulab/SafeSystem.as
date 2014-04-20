package com.njnulab 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.net.URLRequestHeader;
	/**
	 * ...
	 * @author kiwind
	 */
	public class SafeSystem extends MovieClip
	{
		private var clickEvent:String;
		private var kg:uint = 0;
		private var controlBtnArry:Array = [];
		private var list:XMLList;
		
		private var sureBtn:SimpleButton;
		public function SafeSystem() 
		{
			init();
		}
		
		private function init():void
		{
			clickEvent = Global.getClickEvent();
			list = Main.safeReq;
			initSo();
			initObjs();
			
		}
		
		private function initSo():void
		{
			var my_so:SharedObject = SharedObject.getLocal("safedata");
			my_so.clear();
			if (my_so.data.arry == undefined)
			{
				my_so.data.kg = 0;
			}
			kg = my_so.data.kg;
		}
		
		private function initObjs():void
		{
			sureBtn = this.getChildByName("surebtn") as SimpleButton;
			for (var i:uint = 0; i < 2; i++ )
			{
				controlBtnArry.push(this.getChildByName("controlbtn" + i) as MovieClip);
				controlBtnArry[i].addEventListener(clickEvent, controlHandle);
			}
			setState(kg);
			sureBtn.addEventListener(clickEvent, sureHandle);
		}
		
		private function controlHandle(event:Event):void
		{
			var index:uint = uint(event.target.name.substr(10, 1));
			setState(index);
			kg = index;
		}
		
		private function setState(flag:uint):void
		{
			for (var i:uint = 0; i < controlBtnArry.length; i++ )
			{
				if (i == flag)
				{
					controlBtnArry[i].gotoAndStop(2);
				}
				else
				{
					controlBtnArry[i].gotoAndStop(1);
				}
			}
			
		}
		
		private function sureHandle(event:Event):void
		{
			var my_so:SharedObject = SharedObject.getLocal("safedata");
			my_so.data.kg = kg;
			my_so.flush();
			trace(list.children()[kg])
			
			var strUrl:String = list.children()[kg];
			strUrl =  Global.getCorrectUrl(strUrl);
			
			var req:URLRequest = new URLRequest(strUrl);
			var req_header:URLRequestHeader = new URLRequestHeader("Authorization",Global.authCode);
			req.requestHeaders.push(req_header);
			sendToURL(req);
		}
	}

}