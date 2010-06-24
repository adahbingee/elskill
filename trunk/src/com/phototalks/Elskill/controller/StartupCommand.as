package com.phototalks.Elskill.controller
{
	import com.phototalks.Elskill.model.SkillProxy;
	import com.phototalks.Elskill.view.CharacterListMediator;
	import com.phototalks.Elskill.view.ElskillMediator;
	import com.phototalks.Elskill.view.SkillPanelMediator;
	import com.phototalks.Elskill.view.component.ElskillControlBar;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartupCommand extends MacroCommand
	{
		public function StartupCommand()
		{
			super();
		}
		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(PrepElskillCommand);
			addSubCommand(PrepElskillControBarCommand);
			addSubCommand(PrepCharacterListCommand);
			addSubCommand(PrepSkillPanelCommand);
			addSubCommand(SkillProxyCommand);
			
			//register for upadte
			facade.registerCommand(ElskillControlBar.UPDATE, SkillProxyCommand);
		}
	}
}