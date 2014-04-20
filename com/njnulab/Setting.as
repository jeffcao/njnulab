package com.njnulab 
{
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.managers.StyleManager;
	import com.kiwind.utils.Base64;
	import flash.net.SharedObject;

	/**
	 * ...
	 * @author kiwind
	 */
	public class Setting extends Sprite
	{
		private var _ipIpt:TextInput;
		private var _userIpt:TextInput;
		private var _pwdIpt:TextInput;
		private var _btn:SimpleButton;
		private var _tip:MovieClip;
		private var clickEvent:String;
		
		private var authData:Array;
		public function Setting() 
		{
			clickEvent = Global.getClickEvent();
			_ipIpt = this.getChildByName("ipIpt") as TextInput;
			_userIpt = this.getChildByName("userIpt") as TextInput;
			_pwdIpt = this.getChildByName("pwdIpt") as TextInput;
			_btn = this.getChildByName("btn") as SimpleButton;
			_tip = this.getChildByName("tip") as MovieClip;
			var htf:TextFormat = new TextFormat();
			htf.size = 24;
			htf.font = "arial";
			htf.color = 0xffffff;
			_ipIpt.setStyle("textFormat", htf);
			_userIpt.setStyle("textFormat", htf);
			_pwdIpt.setStyle("textFormat", htf);
			
			_btn.addEventListener(clickEvent, clickHandle);
			initAuthData();
		}
		
		private function initAuthData():void
		{
			var my_so:SharedObject = SharedObject.getLocal("authdata");
			authData = my_so.data.authdata
			_ipIpt.text = authData[0];
			_userIpt.text = authData[1];
			_pwdIpt.text = authData[2];
			
			trace("Setting.initAuthData, after authData:"+authData);
		}
		private function clickHandle(event:Event):void
		{
            
			Global.authCode = "Basic " + Base64.encode(_userIpt.text + ":" + _pwdIpt.text);
			Global.gateIp = _ipIpt.text;
			authData[0] = _ipIpt.text;
			authData[1] = _userIpt.text;
			authData[2] = _pwdIpt.text;
			authData[3] = Global.authCode;
			trace("Setting.clickHandle, Global.authCode: " + Global.authCode);

			var url:String = Global.getCorrectUrl(Main.settingUrl);
			
			var request:URLRequest = new URLRequest(url);
            var variables:URLVariables = new URLVariables();
            variables.ip = _ipIpt.text;
			variables.username = _userIpt.text;
			variables.password = _pwdIpt.text;
			request.method = "POST";
            request.data = variables;
            sendToURL(request);
			_tip.alpha = 1;
			
			saveAuthData();
		}
		
		private function saveAuthData():void
		{
			var my_so:SharedObject = SharedObject.getLocal("authdata");
			my_so.data.authdata = authData;
			my_so.flush();
			
			trace("lightSystem.saveAuthData, after save, authData: "+authData);
		}
		
	}

}