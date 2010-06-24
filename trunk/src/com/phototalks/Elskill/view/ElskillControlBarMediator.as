package com.phototalks.Elskill.view
{
	import com.phototalks.Elskill.view.component.CharacterList;
	import com.phototalks.Elskill.view.component.ElskillControlBar;
	import com.phototalks.Elskill.view.component.skill.SkillPanel;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.MenuEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ElskillControlBarMediator extends Mediator
	{
		public static const NAME:String = "ElskillControBarMediator";
		
		private static var sp:int = 0;
		
		public function ElskillControlBarMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			view.addEventListener(ElskillControlBar.RESET, onResetClick);
			view.addEventListener(ElskillControlBar.ABOUT, onAboutClick);
			view.addEventListener(MenuEvent.ITEM_CLICK, onExportClick);
			view.addEventListener(ElskillControlBar.UPDATE, onUpdateClick);
		}
		
		private function get view():ElskillControlBar
		{
			return viewComponent as ElskillControlBar;
		}
		
		override public function listNotificationInterests():Array
		{
			return [CharacterList.LIST_CLICKED,
					SkillPanel.SKILL_ADD,
					SkillPanel.SKILL_SUB, 
					ElskillControlBar.RESET];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CharacterList.LIST_CLICKED:
					view.job.text = (notification.getBody() as XML).@name;
				case ElskillControlBar.RESET:
					sp = 0;
					setSp();
				break;
				
				case SkillPanel.SKILL_ADD:
					sp++;
					setSp();
				break;
				
				case SkillPanel.SKILL_SUB:
					sp--;
					setSp();
				break;
			}
		}
		
		private function setSp():void
		{
			view.sp.text = "SP: " + sp;
			view.lv.text = "LV: " + int(sp/2 + 0.5);
			sendNotification(ElskillControlBar.SP_CHANGE, sp);
		}
		
		private function onResetClick(e:Event):void
		{
			sendNotification(ElskillControlBar.RESET);
		}
		
		private function onExportClick(e:MenuEvent):void
		{
			sendNotification(ElskillControlBar.EXPORT, null, e.item.value);
		}
		
		private function onAboutClick(e:Event):void
		{
			
			Alert.show("Elskill v" + getAppVersion() + "\n" +
				"圖示提供: ckjh60218", "關於本程式");
		}
		
		private function onUpdateClick(e:Event):void
		{
			sendNotification(ElskillControlBar.UPDATE);
		}
		
		private function getAppVersion():String
		{
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var appVersion:String = appXml.ns::version[0];
			return appVersion;
		}
	}
}