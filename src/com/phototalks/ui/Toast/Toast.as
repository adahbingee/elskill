package com.phototalks.ui.Toast
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	import mx.events.EffectEvent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;

	public class Toast
	{
		public static const SHORT_TIME:int = 2000;
		public static const LONG_TIME:int = 6000;
		
		private var _text:String;
		private var label:ToastLabel;
		private var timer:Timer;
		private var _time:int;
		public var parent:DisplayObject;
		
		public function Toast(text:String, parent:DisplayObject = null, delay:int = SHORT_TIME)
		{
			if(text != null) this.text = text;
			time = delay;
			this.parent = parent;
		}
		
		public function set text(value:String):void
		{
			label = new ToastLabel();
			label.text = value;
			_text = value;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set time(value:int):void
		{
			_time = value;
			timer = new Timer(value, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTime);
		}
		
		public function get time():int
		{
			return _time;
		}
		
		public function show():void
		{
			//get parent
			if (!parent)
			{
				var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
				// no types so no dependencies
				var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
				if (mp && mp.useSWFBridge())
					parent = Sprite(sm.getSandboxRoot());
				else
					parent = Sprite(FlexGlobals.topLevelApplication);
			}
			PopUpManager.addPopUp(label, parent);
			PopUpManager.centerPopUp(label);
			label.visible = true;
			timer.start();
		}
		
		private function onTime(e:TimerEvent):void	
		{
			label.visible = false;
			label.hideEff.addEventListener(EffectEvent.EFFECT_END, function ():void{
				PopUpManager.removePopUp(label);
			}, false, 0, true);
		}
		
		public static function show(text:String, parent:DisplayObject = null, delay:int = SHORT_TIME):void
		{
			new Toast(text, parent, delay).show();
		}
	}
}