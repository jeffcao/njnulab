package com.njnulab 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.fscommand;
	import flash.utils.Timer;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import com.adobe.serialization.json.JSON;
	import com.kiwind.utils.Base64;
	/**
	 * ...
	 * @author kiwind
	 */
	public class Main extends Sprite
	{
		private var weatherUrl:String = "http://www.weather.com.cn/data/cityinfo/101190101.html?v=" + (new Date()).getTime();
		private var weatherArry:Array = ["晴", "多云", "阴", "多云转阴", "阵雨", "雷阵雨", "雷阵雨伴有冰雹", "雨夹雪", "小雨", "中雨", "大雨", "暴雨", "大暴雨", "特大暴雨", "阵雪", "小雪", "中雪", "大雪", "暴雪", "雾", "冻雨", "沙尘暴", "小雨-中雨", "中雨-大雨",
										 "大雨-暴雨", "暴雨-大暴雨", "大暴雨-特大暴雨", "小雪-中雪", "中雪-大雪", "大雪-暴雪", "浮尘", "扬沙", "强沙尘暴", "霾"];
		private var weatherIco:Array = ["1.png", "3.png", "5.png","3.png", "7.png", "6.png", "6.png", "11.png", "7.png", "7.png", "8.png", "8.png", "8.png", "8.png", "11.png", "11.png", "11.png", "12.png", "12.png", "9.png", "8.png", "9.png", "7.png", "8.png",
										"8.png", "8.png", "8.png", "11.png", "12.png", "12.png", "14.png", "13.png", "9.png", "14.png"];
		private var weatherIcoPreStr = "asset/images/";
		private var timer:Timer;
		private var _timer:Timer;
		private var monthArry:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		private var dayArry:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		private var weatherObj = { };
		private var mFlag:Boolean = false;
		public static var clickEvent:String;
		private var controlUrl:String = "asset/data/control.xml";
		public static var labUrl:String;
		public static var lightReq:XMLList;
		public static var clReq:XMLList;
		public static var safeReq:XMLList;
		public static var settingUrl:String;
		
		private var btn_down:SimpleButton;
		private var btnHome:SimpleButton;
		private var mIndex:MovieClip;
		private var mDownMenu:DownMenu;
		private var con1:Sprite;
		private var con2:Sprite;
		private var con3:Sprite;
		private var mlab:Lab;
		private var msys:SysPanel;
		private var msetting:Setting;
		public function Main() 
		{
			fscommand("fullscreen", "true");
			init();
		}
		
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			loadControl(controlUrl);
			initObjs();
			loadWeatherData(weatherUrl);
			timer = new Timer(600000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			_timer = new Timer(60000);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			
			initDate();
			_timer.start();
			clickEvent = Global.getClickEvent();
			initAction();
		}
		
		private function loadControl(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, loadControlComplete);
		}
		
		private function loadControlComplete(event:Event):void
		{
			var xml:XML = XML(event.target.data);
			labUrl = xml.labUrl;
			lightReq = xml.lightControl.children();
			clReq = xml.clControl.children();
			safeReq = xml.safeControl.children();
			settingUrl = xml.settingUrl;
		}
		
		private function initObjs():void
		{
			mIndex = this.getChildByName("mindex") as MovieClip;
			btn_down = this.getChildByName("btnDown") as SimpleButton;
			btnHome = this.getChildByName("btnhome") as SimpleButton;
			mDownMenu = new DownMenu();
			mDownMenu.addEventListener("clickHome", homeHandle);
			mDownMenu.addEventListener("clickLab", enterLab);
			mDownMenu.addEventListener("clickSys", enterSys);
			mDownMenu.addEventListener("clickSetting", clickSettingHandle);
			con1 = new Sprite();
			addChild(con1);
			con2 = new Sprite();
			addChild(con2);
			con3 = new Sprite();
			addChild(con3);
			con1.addChild(mIndex);
			con3.addChild(btn_down);
			con2.addChild(btnHome);
		}
		
		private function initDate():void
		{
			var d:Date = new Date();
			var year = d.getFullYear();
			var month = d.getMonth();
			var dd = d.getDate();
			var day = d.getDay();
			var hour = d.getHours();
			var miniute = d.getMinutes();
			var hstr = "";
			var mstr = "";
			hour < 10?hstr = "0" + hour:hstr = "" + hour;
			miniute < 10?mstr = "0" + miniute:mstr = "" + miniute;
			mIndex.t_date.text = mIndex.t_time.text = "";
			mIndex.t_date.appendText(monthArry[month] + " " + dd + " " + dayArry[day] + " " + year);
			mIndex.t_time.appendText(hstr + ":" + mstr);
		}
		
		private function initAction():void
		{
			mIndex.menu1.addEventListener(clickEvent, enterLab);
			mIndex.menu2.addEventListener(clickEvent, enterSys);
			mIndex.menu3.addEventListener(clickEvent, clickSettingHandle);
			btn_down.addEventListener(clickEvent, showDownMenu);
			btnHome.addEventListener(clickEvent, homeHandle);
		}
		
		private function enterLab(event:Event):void
		{
			if (mlab == null)
			{
				mlab = new Lab();
				con1.addChild(mlab);
			}
			mIndex.visible = false;
			
			mlab.visible = true;
			if (msys) msys.visible = false;
			if (msetting) msetting.visible = false;
			if (con2.contains(mDownMenu))
			{
				mDownMenu.parent.removeChild(mDownMenu);
				mFlag = false;
			}
		}
		
		private function enterSys(event:Event):void
		{
			if (msys == null)
			{
				msys = new SysPanel();
				con1.addChild(msys);
			}
			mIndex.visible = false;
			msys.visible = true;
			if (mlab) mlab.visible = false;
			if (msetting) msetting.visible = false;
			if (con2.contains(mDownMenu))
			{
				mDownMenu.parent.removeChild(mDownMenu);
				mFlag = false;
			}
		}
		
		private function clickSettingHandle(event:Event):void
		{
			if (msetting == null)
			{
				msetting = new Setting();
				con1.addChild(msetting);
			}
			mIndex.visible = false;
			msetting.visible = true;
			if (msys) msys.visible = false;
			if (mlab) mlab.visible = false;
			if (con2.contains(mDownMenu))
			{
				mDownMenu.parent.removeChild(mDownMenu);
				mFlag = false;
			}
		}
		
		private function showDownMenu(event:Event):void
		{
			showMenu();
		}
		
		private function showMenu():void
		{
			if (!mFlag)
			{
				con2.addChild(mDownMenu);
				mFlag = true;
			}
			else
			{
				con2.removeChild(mDownMenu);
				mFlag = false;
			}
		}
		
		private function homeHandle(event:Event):void
		{
			mIndex.visible = true;
			if(mlab) mlab.visible = false;
			if (msys) msys.visible = false;
			if (msetting) msetting.visible = false;
			if (con2.contains(mDownMenu))
			{
				mDownMenu.parent.removeChild(mDownMenu);
				mFlag = false;
			}
		}
		
		private function loadWeatherData(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, loadWeatherDataComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
		}
		
		private function loadWeatherDataComplete(event:Event):void
		{
			var data:String = String(event.target.data);
            var obj:Object = (com.adobe.serialization.json.JSON.decode(data) as Object);
			setWeatherInfo(obj);
		}
		
		private function ioError(event:IOErrorEvent):void
		{
			loadWeatherData(weatherUrl);
		}
		
		private function setWeatherInfo(o:Object):void
		{
			mIndex.t_weather.appendText(o.weatherinfo.weather);
			mIndex.t_count1.appendText(o.weatherinfo.temp2);
			mIndex.t_count2.appendText(o.weatherinfo.temp1);
			loadWeatherIco(weatherIcoPreStr + weatherIco[getIndex(weatherArry, o.weatherinfo.weather)]);
		}
		
		private function loadWeatherIco(url:String):void
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadWeatherIcoComplete);
		}
		
		private function loadWeatherIcoComplete(event:Event):void
		{
			var bm:Bitmap = event.target.content as Bitmap;
			bm.smoothing = true;
			mIndex.mico.addChild(bm);
			bm.x = mIndex.mico.width * 0.5 - bm.width * 0.5;
			bm.y = mIndex.mico.height * 0.5 - bm.height * 0.5;
		}
		
		private function onTimer(event:TimerEvent):void
		{
			
		}
		
		private function _onTimer(event:TimerEvent):void
		{
			initDate();
		}
		
		private function getIndex(a:Array, v:String):int
		{
			var r:int = 0;
			for (var i:uint = 0; i < a.length; i++ )
			{
				if (a[i] == v)
				{
					r = i;
				}
				
			}
			return r;
		}
	}

}