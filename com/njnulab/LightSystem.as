package com.njnulab 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.net.sendToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
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
		
		private var lightState:Array = []
		private var lightKgMap:Array = []
		private var kgState:Array = []
		
		
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
				//lsb.DataArry = dataArry[i];
				swtichBtnCon.addChild(lsb);
				lsb.x = 32;
				lsb.addEventListener(clickEvent, switchHandle);
			}
			setSwitchBtnState(btnIndex, switchArry[btnIndex]);
			//switchArry[btnIndex].gotoAndStop(2);
			//switchArry[btnIndex].init(dataArry[btnIndex]);
			//kgFlag = kgArry[btnIndex];
			//setKgState(kgArry[btnIndex]);
			setLightsState();
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
			if (my_so.data.lightState == undefined)
			{
				my_so.data.lightState = [0, 0, 0, 0, 0, 0];
				my_so.data.lightKgMap = [0, 0, 0, 0, 0, 0];
				my_so.data.kgState = [0, 0, 0, 0, 0, 0]
			}
			lightState = my_so.data.lightState
			lightKgMap = my_so.data.lightKgMap
			kgState = my_so.data.kgState
			trace("initSo.lightState: "+lightState)
			trace("initSo.lightKgMap: " + lightKgMap)
			trace("initSo.kgState: "+kgState)
		}
		
		private function switchHandle(event:Event):void
		{
			var lsb:LightSwitchBtn = event.target as LightSwitchBtn;
			//lp.reset();
			btnIndex = lsb.Id;
			setSwitchBtnState(btnIndex, lsb);
		}
		
		private function setSwitchBtnState(switchIndex:uint, lsb:LightSwitchBtn):void
		{
			
			
			setKgState();
			setLightControllState();
			setSwitchState(lsb.Id);
			var meControllLight = getMeControllLights()
			lsb.init(meControllLight);
		}
		private function getMeControllLights():Array
		{
			var meControllLight = []
			for (var i:uint = 0; i < lightKgMap.length; i++)
			{
				if (lightKgMap[i] == btnIndex + 1) 
				{
					meControllLight.push(i);
				}
			}
			return meControllLight;
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
			
			saveLightKgMapData();
			changeLightsState(0);
			saveLightStateData();
			setLightsState();
			kgState[btnIndex] = 0
			saveKgStateData();
		}
		private function saveKgStateData():void
		{
			
			var my_so:SharedObject = SharedObject.getLocal("lightdata");
			my_so.data.kgState = kgState;
			my_so.flush();
			
			trace("lightSystem.saveKgStateData, after save, kgState: "+kgState);
			
		}
		private function changeLightsState(state:uint):void
		{
			var meControllLights = getMeControllLights()
			trace("LightSystem.changeLightsState, Global.authCode: " +Global.authCode);
			for (var i:uint = 0; i < meControllLights.length; i++ )
			{
				var strUrl:String = list[meControllLights[i]].children()[state];
				strUrl = strUrl  + (new Date()).getTime();
				trace("LightSystem.changeLightsState, strUrl: " +strUrl);
				strUrl =  Global.getCorrectUrl(strUrl);
				try
				{
					Global.GetHTTPURLLoader(strUrl, listRequestComplete, ioError);
				}
				catch (e:Error)
				{
					trace("changeLightsState.sendToURL, erro: "+e.getStackTrace());
				}
				lightState[meControllLights[i]] = state;
			}
		}
		
		private function listRequestComplete(event:Event):void
		{
			//var data:String = String(event.target.data);
            //var obj:Object = (com.adobe.serialization.json.JSON.decode(data) as Object);
			//setWeatherInfo(obj);
			trace("LightSystem.listRequestComplete");
		}
		
		private function ioError(event:IOErrorEvent):void
		{
			//loadWeatherData(weatherUrl);
			trace("LightSystem.ioError");
		}
		
		private function onHandle(event:Event):void
		{
			btnOn.gotoAndStop(2);
			btnOff.gotoAndStop(1);
			
			saveLightKgMapData();
			changeLightsState(1);
			saveLightStateData();
			setLightsState();
			kgState[btnIndex] = 1
			saveKgStateData();
			//ExternalInterface.call("alert", "设置成功!");
		}
		private function saveLightStateData():void
		{
			var my_so:SharedObject = SharedObject.getLocal("lightdata");
			my_so.data.lightState = lightState;
			my_so.flush();
			
			trace("lightSystem.saveLightStateData, after save, lightState: "+lightState);
		}
		private function setLightsState():void
		{
			for (var i:uint = 0; i < lightState.length; i++ )
			{
				if (lightState[i] == 0)
				{
					lightArry[i].gotoAndStop(1);
				}
				else
				{
					lightArry[i].gotoAndStop(2);
				}
			}
		}
		private function setLightControllState():void
		{
			for (var i:uint = 0; i < lightKgMap.length; i++ )
			{
				if (lightKgMap[i] == btnIndex + 1)
				{
					lightArry[i].ck.gotoAndStop(2);
				}
				else
				{
					lightArry[i].ck.gotoAndStop(1);
				}
				
			}
		}
		
		private function setKgState():void
		{
			if (kgState[btnIndex] == 0)
			{
				btnOff.gotoAndStop(2);
				btnOn.gotoAndStop(1);
			}
			else
			{
				btnOff.gotoAndStop(1);
				btnOn.gotoAndStop(2);
			}
		}
		
		private function sureHandle(event:Event):void
		{
			saveLightKgMapData();
			changeLightsState(kgState[btnIndex]);
			saveLightStateData();
			setLightsState();
			//ExternalInterface.call("alert", "设置成功!");
		}
		
		private function saveLightKgMapData():void
		{
			trace("lightSystem.sureHandle, before save, lightKgMap: "+lightKgMap);
			for (var i:uint = 0; i < lightArry.length; i++)
			{
					if (lightArry[i].ck.currentFrame == 2)
					{
						lightKgMap[i] = btnIndex + 1;
					}
					else if(lightKgMap[i] == btnIndex+1)
					{
						lightKgMap[i] = 0
					}
			}
			
			var my_so:SharedObject = SharedObject.getLocal("lightdata");
			//dataArry[btnIndex] = arry;
			my_so.data.lightKgMap = lightKgMap;
			//my_so.data.kg = kgArry;
			my_so.flush();
			
			var meControllLight = getMeControllLights()
			switchArry[btnIndex].init(meControllLight);
			trace("lightSystem.sureHandle, after save, lightKgMap: "+lightKgMap);
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