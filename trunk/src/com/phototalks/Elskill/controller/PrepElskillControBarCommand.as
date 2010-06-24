package com.phototalks.Elskill.controller
{
	import com.phototalks.Elskill.view.ElskillControlBarMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepElskillControBarCommand extends SimpleCommand
	{
		public function PrepElskillControBarCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator( new ElskillControlBarMediator((notification.getBody() as Elskill).controlBar) );
		}
	}
}