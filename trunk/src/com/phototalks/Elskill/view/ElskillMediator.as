package com.phototalks.Elskill.view
{
	import com.phototalks.Elskill.model.SkillProxy;
	import com.phototalks.Elskill.view.component.CharacterList;
	import com.phototalks.ui.Toast.Toast;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ElskillMediator extends Mediator
	{
		public static const NAME:String = "ElskillMediator";
		public function ElskillMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			view.addEventListener(Elskill.CHARACTER_STATE, onStateChange);
			view.addEventListener(Elskill.SKILL_STATE, onStateChange);
		}
		
		override public function listNotificationInterests():Array
		{
			return [CharacterList.LIST_CLICKED, SkillProxy.SKILL_PROXY_TOAST];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case CharacterList.LIST_CLICKED:
					view.currentState = Elskill.SKILL_STATE;
				break;
				
				case SkillProxy.SKILL_PROXY_TOAST:
					Toast.show(notification.getBody().toString());
				break;
			}
		}
		
		private function get view():Elskill
		{
			return viewComponent as Elskill;
		}
		
		private function onStateChange(e:Event):void
		{
			view.currentState = e.type;
			sendNotification(e.type);
		}
	}
}