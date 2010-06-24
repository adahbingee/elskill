package com.phototalks.Elskill
{
	import com.phototalks.Elskill.controller.StartupCommand;
	import com.phototalks.ui.Toast.Toast;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String = "startup";
		
		public static var application:Elskill;
		
		public function ApplicationFacade()
		{
			super();
		}
		
		public static function getInstance():ApplicationFacade
		{
			if(instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		public function startup(app:Elskill):void
		{
			application = app;
			sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);
		}
	}
}