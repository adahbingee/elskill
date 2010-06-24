package com.phototalks.Elskill.controller
{
	import com.phototalks.Elskill.view.SkillPanelMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepSkillPanelCommand extends SimpleCommand
	{
		public function PrepSkillPanelCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new SkillPanelMediator( (notification.getBody() as Elskill).skillPanel ));
		}
	}
}