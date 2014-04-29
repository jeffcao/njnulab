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
	import flash.events.IOErrorEvent;
	/**
	 * ...
	 * @author kiwind
	 */
	public class WindowSystem extends MovieClip
	{
		private var clickEvent:String;
		private var kgArry:Array = [];
		private var switchArry:Array = [];
		private var controlBtnArry:Array = [];
		private var btnIndex:uint = 0;
		private var list:XMLList;
		
		private var swtichBtnCon:Sprite;
		private var clMc:WindowMc;
		private var sureBtn:SimpleButton;

		public function WindowSystem() 
		{
			init();
		}
		
		private function init():void
		{
			clickEvent = Global.getClickEvent();
			list = Main.clReq;
			initSo();
			initObjs();
			
		}
		
		private function initSo():void
		{
			var my_so:SharedObject = SharedObject.getLocal("windowdata");
			my_so.clear();
			if (my_so.data.arry == undefined)
			{
				my_so.data.kg = [0,0];
			}
			kgArry = my_so.data.kg;
		}
		
		private function initObjs():void
		{
			swtichBtnCon = new Sprite();
			addChild(swtichBtnCon);
			clMc = this.getChildByName("clmc") as WindowMc;
			sureBtn = this.getChildByName("surebtn") as SimpleButton;
			for (var i:uint = 0; i < 3; i++ )
			{
				controlBtnArry.push(this.getChildByName("controlbtn" + i) as MovieClip);
				controlBtnArry[i].addEventListener(clickEvent, controlHandle);
			}
			for (i = 0; i < 2; i++ )
			{
				var wsb:WindowSwitchBtn = new WindowSwitchBtn();
				wsb.Id = i;
				switchArry.push(wsb);
				swtichBtnCon.addChild(wsb);
				wsb.x = 32;
				wsb.y = 222 + (wsb.height + 6) * i;
				wsb.addEventListener(clickEvent, switchHandle);
			}
			setSwitchState(btnIndex);
			setState(kgArry[btnIndex]);
			clMc.gotoAndStop(kgArry[btnIndex]);
			
			sureBtn.addEventListener(clickEvent, sureHandle);
		}
		
		private function switchHandle(event:Event):void
		{
			var wsb:WindowSwitchBtn = event.target as WindowSwitchBtn;
			btnIndex = wsb.Id;
			trace("kgArry[btnIndex]:"+kgArry[btnIndex])
			setSwitchState(btnIndex);
			setState(kgArry[btnIndex]);
			clMc.gotoAndStop(kgArry[btnIndex] + 1);
		
		}
		
		private function controlHandle(event:Event):void
		{
			var index:uint = uint(event.target.name.substr(10, 1));
			setState(index);
			kgArry[btnIndex] = index;
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
			var my_so:SharedObject = SharedObject.getLocal("windowdata");
			my_so.data.kg = kgArry;
			my_so.flush();
			clMc.gotoAndStop(kgArry[btnIndex] + 1);
			var strUrl:String = list[btnIndex].children()[kgArry[btnIndex]];
			strUrl =  Global.getCorrectUrl(strUrl);
			Global.GetHTTPURLLoader(strUrl, listRequestComplete, ioError);
		}
		private function listRequestComplete(event:Event):void
		{
			//var data:String = String(event.target.data);
            //var obj:Object = (com.adobe.serialization.json.JSON.decode(data) as Object);
			//setWeatherInfo(obj);
			trace("WindowSystem.listRequestComplete");
		}
		
		private function ioError(event:IOErrorEvent):void
		{
			//loadWeatherData(weatherUrl);
			trace("WindowSystem.ioError");
		}
		private function setSwitchState(id:uint):void
		{
			for (var i:uint = 0; i < switchArry.length; i++ )
			{
				if (i == id)
				{
					switchArry[i].gotoAndStop(2);
				}
				else
				{
					switchArry[i].gotoAndStop(1);
				}
			}
		}
	}

}