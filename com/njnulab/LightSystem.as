package com.njnulab 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.net.sendToURL;
	import flash.net.URLRequest;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequestHeader;
	/**
	 * ...
	 * @author kiwind
	 */
	public class LightSystem extends MovieClip
	{
		private var dataArry:Array = [];
		private var kgArry:Array = [];
		private var lightArry:Array = [];
		private var switchArry:Array = [];
		private var clickEvent:String;
		public static var kgFlag:uint = 0;
		private var btnIndex:uint = 0;
		private var list:XMLList;
		
		private var swtichBtnCon:Sprite;
		private var lp:LightPanel;
		private var btnSure:SimpleButton;
		private var btnOff:MovieClip;
		private var btnOn:MovieClip;
		
		public function LightSystem() 
		{
			init();
		}
		
		private function init():void
		{
			clickEvent = Global.getClickEvent();
			list = Main.lightReq;
			initSo();
			initObjs();
			
		}
		
		private function initObjs():void
		{
			swtichBtnCon = new Sprite();
			addChild(swtichBtnCon);
			lp = new LightPanel();
			addChild(lp);
			lightArry = lp.lightArry;
			btnSure = this.getChildByName("surebtn") as SimpleButton;
			btnOff = this.getChildByName("offbtn") as MovieClip;
			btnOn = this.getChildByName("onbtn") as MovieClip;
			btnOff.gotoAndStop(2);
			for (var i:uint = 0; i < 6; i++ )
			{
				var lsb:LightSwitchBtn =  new LightSwitchBtn();
				switchArry.push(lsb);
				lsb.Id = i;
				lsb.DataArry = dataArry[i];
				swtichBtnCon.addChild(lsb);
				lsb.x = 32;
				lsb.addEventListener(clickEvent, switchHandle);
			}
			switchArry[btnIndex].gotoAndStop(2);
			switchArry[btnIndex].init(dataArry[btnIndex]);
			kgFlag = kgArry[btnIndex];
			setKgState(kgArry[btnIndex]);
			setLightsState(dataArry[btnIndex], kgArry[btnIndex]);
			switchArry[0].y = 142;
			switchArry[1].y = 189;
			switchArry[2].y = 237;
			switchArry[3].y = 286;
			switchArry[4].y = 334;
			switchArry[5].y = 383;
			
			btnOff.addEventListener(clickEvent, offHandle);
			btnOn.addEventListener(clickEvent, onHandle);
			btnSure.addEventListener(clickEvent, sureHandle);
			lp.addEventListener("clickLight", clickLightHandle);
		}
		
		private function initSo():void
		{
			var my_so:SharedObject = SharedObject.getLocal("lightdata");
			//my_so.clear();
			if (my_so.data.arry == undefined)
			{
				my_so.data.arry = [[], [], [], [], [], []];
				my_so.data.kg = [0, 0, 0, 0, 0, 0];
			}
			dataArry = my_so.data.arry;
			kgArry = my_so.data.kg;
			trace("kgArry:"+kgArry)
		}
		
		private function switchHandle(event:Event):void
		{
			var lsb:LightSwitchBtn = event.target as LightSwitchBtn;
			lp.reset();
			btnIndex = lsb.Id;
			setKgState(kgArry[btnIndex]);
			setLightsState(dataArry[btnIndex], kgArry[btnIndex]);
			setSwitchState(lsb.Id);
			lsb.init(dataArry[btnIndex]);
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
					switchArry[i].clear();
				}
			}
		}
		
		private function offHandle(event:Event):void
		{
			btnOn.gotoAndStop(1);
			btnOff.gotoAndStop(2);
			kgFlag = 0;
			kgArry[btnIndex] = 0;
		}
		
		private function onHandle(event:Event):void
		{
			btnOn.gotoAndStop(2);
			btnOff.gotoAndStop(1);
			kgFlag = 1;
			kgArry[btnIndex] = 1;
		}
		
		private function setLightsState(sarry:Array,flag:uint=0):void
		{
			for (var i:uint = 0; i < lightArry.length; i++ )
			{
				if (Global.isInArry(i, sarry))
				{
					if (flag == 0)
					{
						lightArry[i].gotoAndStop(1);
					}
					else
					{
						lightArry[i].gotoAndStop(2);
					}
					lightArry[i].ck.gotoAndStop(2);
				}
			}
		}
		
		private function setKgState(kgf:uint):void
		{
			if (kgf == 0)
			{
				btnOff.gotoAndStop(2);
				btnOn.gotoAndStop(1);
			}
			else
			{
				btnOff.gotoAndStop(1);
				btnOn.gotoAndStop(2);
			}
			kgFlag = kgf;
		}
		
		private function sureHandle(event:Event):void
		{
			var arry:Array = [];
			for (var i:uint = 0; i < lightArry.length; i++ )
			{
				if (lightArry[i].ck.currentFrame == 2)
				{
					arry.push(i);
				}
			}
			var my_so:SharedObject = SharedObject.getLocal("lightdata");
			dataArry[btnIndex] = arry;
			my_so.data.arry = dataArry;
			my_so.data.kg = kgArry;
			my_so.flush();
			var selectedArry:Array = lp.getSelected();
			setLightsState(selectedArry, kgFlag);
			switchArry[btnIndex].removeBoxChildren();
			switchArry[btnIndex].putNumItem();
			for (i = 0; i < dataArry[btnIndex].length; i++ )
			{
				trace(i + ":" + list[dataArry[btnIndex][i]].children()[kgArry[btnIndex]])
				var req:URLRequest = new URLRequest(list[dataArry[btnIndex][i]].children()[kgArry[btnIndex]]);
				var req_header:URLRequestHeader = new URLRequestHeader("Authorization",Global.authCode);
				req.requestHeaders.push(req_header);
				sendToURL(req);
			}
			
		}
		
		private function clickLightHandle(event:Event):void
		{
			var lf:uint = lightArry[lp.index].ck.currentFrame;
			if (lf == 2)
			{
				switchArry[btnIndex].addNum(lp.index);
			}
			if (lf == 1)
			{
				switchArry[btnIndex].reduceNum(lp.index);
			}
		}
	}

}