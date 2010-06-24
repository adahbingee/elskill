package com.phototalks.Elskill.controller
{
	import com.phototalks.Elskill.view.CharacterListMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepCharacterListCommand extends SimpleCommand
	{
		public function PrepCharacterListCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new CharacterListMediator( (notification.getBody() as Elskill).characterList ));
		}
	}
}