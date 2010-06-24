package com.phototalks.Elskill.controller
{
	import com.phototalks.Elskill.model.SkillProxy;
	import com.phototalks.Elskill.view.ElskillMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepElskillCommand extends SimpleCommand
	{
		public function PrepElskillCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new ElskillMediator(notification.getBody()));
			facade.registerCommand(Elskill.CHARACTER_STATE, SkillProxyCommand);
		}
	}
}