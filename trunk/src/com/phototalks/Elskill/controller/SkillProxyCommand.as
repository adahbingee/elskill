package com.phototalks.Elskill.controller
{
	import com.phototalks.Elskill.ApplicationFacade;
	import com.phototalks.Elskill.model.SkillProxy;
	import com.phototalks.Elskill.view.component.ElskillControlBar;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SkillProxyCommand extends SimpleCommand
	{
		public function SkillProxyCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.STARTUP:
				case Elskill.CHARACTER_STATE:
					var sp:SkillProxy = new SkillProxy();
					facade.registerProxy(sp);
					sp.loadSkillXML();
				break;
				
				case ElskillControlBar.UPDATE:
					var proxy:SkillProxy = facade.retrieveProxy(SkillProxy.NAME) as SkillProxy;
					proxy.loadHttpSkillXML();
				break;
			}
		}
	}
}