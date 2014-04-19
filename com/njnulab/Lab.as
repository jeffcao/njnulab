package com.njnulab 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	/**
	 * ...
	 * @author kiwind
	 */
	public class Lab extends Sprite
	{
		private var btnArry:Array = [];
		private static var LEN = 10;
		private var clickEvent:String;
		private var list:XMLList;
		private var labPage:LabPage;
		public function Lab() 
		{
			init();
		}
		
		private function init():void
		{
			loadData(Main.labUrl);
		}
		
		private function loadData(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, loadDataComplete);
		}
		
		private function loadDataComplete(event:Event):void
		{
			var xml:XML = XML(event.target.data);
			list = xml.children();
			initObjs();
			clickEvent = Global.getClickEvent();
			initAction();
		}
		
		private function initObjs():void
		{
			for (var i:uint = 0; i < LEN; i++ )
			{
				btnArry.push(this.getChildByName("btn" + i) as MovieClip);
				btnArry[i].buttonMode = btnArry[i].useHandCursor = true;
			}
			labPage = new LabPage();
			addChildAt(labPage, 0);
			labPage.init(list[0].split("|"));
			btnArry[0].gotoAndStop(2);
		}
		
		private function initAction():void
		{
			for (var i:uint = 0; i < LEN; i++ )
			{
				(btnArry[i] as MovieClip).addEventListener(clickEvent, clickHandle);
			}
		}
		
		private function clickHandle(event:Event):void
		{
			var index:uint = event.target.name.toString().substr(3, 1);
			trace(list[index])
			labPage.init(list[index].split("|"));
			setBtnState(index);
		}
		
		private function setBtnState(id:uint):void
		{
			for (var i:uint = 0; i < btnArry.length; i++ )
			{
				if (i == id)
				{
					btnArry[i].gotoAndStop(2);
				}
				else
				{
					btnArry[i].gotoAndStop(1);
				}
			}
		}
	}

}