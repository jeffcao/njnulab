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
	public class SysPanel extends MovieClip
	{
		private var sysmenu:MovieClip;
		private var clickEvent:String;
		private var lightSys:LightSystem;
		private var windowSys:WindowSystem;
		private var safeSys:SafeSystem;

		public function SysPanel() 
		{
			clickEvent = Global.getClickEvent();
			lightSys = new LightSystem();
			addChild(lightSys);
			
			windowSys = new WindowSystem();
			windowSys.visible = false;
			addChild(windowSys);
			
			safeSys = new SafeSystem();
			safeSys.visible = false;
			addChild(safeSys);
			
			
			lightSys.sysbtn2.addEventListener(clickEvent, lightClickHandle2);
			lightSys.sysbtn3.addEventListener(clickEvent, lightClickHandle3);
			
			windowSys.sysbtn1.addEventListener(clickEvent, windowClickHandle1);
			windowSys.sysbtn3.addEventListener(clickEvent, windowClickHandle3);
			
			safeSys.sysbtn1.addEventListener(clickEvent, safeClickHandle1);
			safeSys.sysbtn2.addEventListener(clickEvent, safeClickHandle2);
		}
		
		private function lightClickHandle2(event:Event):void
		{
			lightSys.visible = false;
			windowSys.visible = true;
			safeSys.visible = false;
		}
		
		private function lightClickHandle3(event:Event):void
		{
			lightSys.visible = false;
			windowSys.visible = false;
			safeSys.visible = true;
		}
		
		private function windowClickHandle1(event:Event):void
		{
			lightSys.visible = true;
			windowSys.visible = false;
			safeSys.visible = false;
		}
		
		private function windowClickHandle3(event:Event):void
		{
			lightSys.visible = false;
			windowSys.visible = false;
			safeSys.visible = true;
		}
		
		private function safeClickHandle1(event:Event):void
		{
			lightSys.visible = true;
			windowSys.visible = false;
			safeSys.visible = false;
		}
		
		private function safeClickHandle2(event:Event):void
		{
			lightSys.visible = false;
			windowSys.visible = true;
			safeSys.visible = false;
		}
	}

}