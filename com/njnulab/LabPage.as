package com.njnulab 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author kiwind
	 */
	public class LabPage extends Sprite
	{
		private var btnPrev:SimpleButton;
		private var btnNext:SimpleButton;
		private var con:Sprite;
		private var imgArry:Array = [];
		private var index:int = 0;
		private var clickEvent:String;
		public function LabPage() 
		{
			btnPrev = this.getChildByName("btnprev") as SimpleButton;
			btnNext = this.getChildByName("btnnext") as SimpleButton;
			btnPrev.visible = btnNext.visible = false;
			con = new Sprite();
			addChildAt(con, 0);
			
			clickEvent = Global.getClickEvent();
			initAction();
		}
		
		private function initAction():void
		{
			btnPrev.addEventListener(clickEvent, prevHandle);
			btnNext.addEventListener(clickEvent, nextHandle);
		}
		
		private function prevHandle(event:Event):void
		{
			index--;
			btnNext.visible = true;
			if (index == 0)
			{
				btnPrev.visible = false;
			}
			loadImg(imgArry[index]);
		}
		
		private function nextHandle(event:Event):void
		{
			index++;
			btnPrev.visible = true;
			if (index == imgArry.length - 1)
			{
				btnNext.visible = false;
			}
			loadImg(imgArry[index]);
		}
		
		public function init(arry:Array):void
		{
			clear();
			imgArry = arry;
			if (imgArry.length >= 2)
			{
				btnNext.visible = true;
			}
			loadImg(imgArry[index]);
		}
		
		private function clear():void
		{
			btnPrev.visible = btnNext.visible = false;
			index = 0;
			clearCon();
		}
		
		public function loadImg(url:String):void
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImgComplete);
		}
		
		private function loadImgComplete(event:Event):void
		{
			var bm:Bitmap = event.target.content as Bitmap;
			bm.smoothing = true;
			bm.alpha = 0;
			clearCon();
			con.addChild(bm);
			TweenLite.to(bm, 0.5, { alpha:1 } );
		}
		
		private function clearCon():void
		{
			while (con.numChildren > 0)
			{
				con.removeChildAt(0);
			}
		}
	}

}