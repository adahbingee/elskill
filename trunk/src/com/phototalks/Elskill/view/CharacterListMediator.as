package com.phototalks.Elskill.view
{
	import com.phototalks.Elskill.model.SkillProxy;
	import com.phototalks.Elskill.view.component.CharacterList;
	
	import flash.events.Event;
	
	import mx.collections.XMLListCollection;
	import mx.events.EffectEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CharacterListMediator extends Mediator
	{
		public static const NAME:String = "CharacterListMediator";
		
		public function CharacterListMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			view.addEventListener(CharacterList.LIST_CLICKED, onListClicked);
		}
		
		override public function listNotificationInterests():Array
		{
			return [SkillProxy.SKILL_XML_LOADED];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SkillProxy.SKILL_XML_LOADED:
					var xml:XML = notification.getBody() as XML;
					var characterXML:XMLListCollection = new XMLListCollection(xml.job);
					view.dataProvider = characterXML;
				break;
			}
		}
		
		private function get view():CharacterList
		{
			return viewComponent as CharacterList;
		}
		
		private function onListClicked(event:Event):void
		{
			if(view.selectedItem != null)
			{
				view.hideEff.addEventListener(EffectEvent.EFFECT_END, function ():void{
					sendNotification(CharacterList.LIST_CLICKED, view.selectedItem);
				}, false, 0, true);
				view.hideEff.play([view]);
			}
		}
	}
}