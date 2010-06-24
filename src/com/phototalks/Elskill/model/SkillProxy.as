package com.phototalks.Elskill.model
{
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SkillProxy extends Proxy
	{
		public static const NAME:String = "SkillProxy";
		public static const SKILL_XML_LOADED:String = "skill xml loaded";
		public static const SKILL_PROXY_TOAST:String = "SKILL_PROXY_TOAST";
		
		private static const SKILL_FILE:String = "skill.xml";
		private static const URL:String = "http://www.phototalks.idv.tw/flex/skill.xml";
		
		private var file:File = new File(File.applicationDirectory.resolvePath(SKILL_FILE).nativePath);
		private var fileStream:FileStream = new FileStream();
		private var skillXML:XML;
		
		public function SkillProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function loadSkillXML():void
		{
			try
			{
				fileStream.open(file, FileMode.READ);
			}
			catch(e:IOError)
			{
				sendNotification(SKILL_PROXY_TOAST, "找不到檔案: \n" + File.applicationDirectory.nativePath + "\\skill.xml");
				return;
			}
			skillXML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			sendNotification(SKILL_XML_LOADED, skillXML);
		}
		
		public function loadHttpSkillXML():void
		{
			var service:HTTPService = new HTTPService();
			service.url = URL;
			service.resultFormat = "xml";
			service.showBusyCursor = true;
			service.addEventListener(ResultEvent.RESULT, onResult);
			service.send();
		}
		
		private function onResult(e:ResultEvent):void
		{
			var xml:XML = XML(e.result);
			
			//has no local skill.xml
			if(skillXML == null)
			{
				writeXML(xml);
				return;
			}
			
			//is newer
			if(xml.attribute("date") > skillXML.attribute("date"))
			{
				writeXML(xml);
			}
			else
			{
				sendNotification(SKILL_PROXY_TOAST, "沒有更新的skill.xml");
			}
		}
		
		private function writeXML(xml:XML):void
		{
			try
			{
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeUTFBytes(xml.toXMLString());
				fileStream.close();
				sendNotification(SKILL_PROXY_TOAST, "更新skill.xml date: " + xml.@date);
				sendNotification(SKILL_XML_LOADED, xml);
			}
			catch(e:IOError)
			{
				
			}
		}
	}
}