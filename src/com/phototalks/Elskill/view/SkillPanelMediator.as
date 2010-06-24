package com.phototalks.Elskill.view
{
	import com.phototalks.Elskill.view.component.CharacterList;
	import com.phototalks.Elskill.view.component.ElskillControlBar;
	import com.phototalks.Elskill.view.component.skill.HSkillPre;
	import com.phototalks.Elskill.view.component.skill.SkillItem;
	import com.phototalks.Elskill.view.component.skill.SkillLevel;
	import com.phototalks.Elskill.view.component.skill.SkillPanel;
	import com.phototalks.Elskill.view.component.skill.SkillRow;
	import com.phototalks.Elskill.view.component.skill.VSkillPre;
	import com.phototalks.ui.Toast.Toast;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import mx.containers.Box;
	import mx.graphics.ImageSnapshot;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SkillPanelMediator extends Mediator
	{
		public static const NAME:String = "SkillPanelMediator";
		
		private static const SKILL_ITEM_WIDTH:int = 90;
		private static const SKILL_ITEM_HEIGHT:int = 100;
		private static const SKILL_ITEM_PER_ROW:int = 5;
		private static const VERTICAL_PADDING:int = 20;
		private static const HORIZONTAL_PADDING: int = 20;
		
		private var xmlB:XML;
		private var xmlSkill:XML;
		
		private var sp:int = 0;
		
		public function SkillPanelMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			view.addEventListener(SkillPanel.SKILL_ADD, onSkillAdd);
			view.addEventListener(SkillPanel.SKILL_SUB, onSkillSub);
		}
		
		override public function listNotificationInterests():Array
		{
			return [CharacterList.LIST_CLICKED, 
					ElskillControlBar.SP_CHANGE,
					ElskillControlBar.RESET,
					ElskillControlBar.EXPORT];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ElskillControlBar.RESET:
					notification.setBody(xmlB);
				case CharacterList.LIST_CLICKED:
					clearView();
					setSkill(notification.getBody() as XML);
				break;
				
				case ElskillControlBar.SP_CHANGE:
					sp = notification.getBody() as int;
					//change rows alpha if avaliable
					var openedRows:int = int(sp/5);
					var row:int = 0;
					for(var i:int = 0; i < view.getChildren().length; i++)
					{
						if(view.getChildAt(i) is SkillRow)
						{
							var rowItem:SkillRow = view.getChildAt(i) as SkillRow;
							rowItem.alpha = 0.3;
							if(row <= openedRows)
							{
								rowItem.alpha = 1;
							}
							row++;
						}
					}
				break;
				
				case ElskillControlBar.EXPORT:
					if(!xmlSkill)
					{
						Toast.show("請選擇人物");
						return;
					}
					if(notification.getType() == "image")
					{
						copyImage();
					}
					else
					{
						copyString();
					}
					
					Toast.show("已複製到剪貼簿");
				break;
			}
		}
		
		private function get view():SkillPanel
		{
			return viewComponent as SkillPanel;
		}
		
		//copy skill string to clipboard
		private function copyString():void
		{
			var e:XMLList = xmlSkill.descendants("skill");
			var s:String = "";
			for(var j:int = 0; j < e.length(); j++)
			{
				var sk:XML = e[j];
				if(sk.attribute("level") > 0)
				{
					s += sk.@name + "\t" + sk.@level + "\n";
				}
			}
			s += "LV: " + int(sp/2) + "   SP: " + sp + "\n";
			System.setClipboard(s);
		}
		
		//copy skill image to clipboard
		private function copyImage():void
		{
			var tmp:int = view.height;
			view.height = view.measuredHeight;
			view.validateNow();
			var ba:ByteArray = ImageSnapshot.captureImage(view).data as ByteArray;
			view.height = tmp;
			view.validateNow();
			
			//fix background color, convert black into white
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var content:* = loader.content;
				var BMPData:BitmapData = new BitmapData(content.width,content.height);
				var UIMatrix:Matrix = new Matrix();
				BMPData.draw(content, UIMatrix);
				
				//copy bitmap into clipboard
				Clipboard.generalClipboard.setData(ClipboardFormats.BITMAP_FORMAT, BMPData);
			}, false, 0, true);
			loader.loadBytes(ba);
		}

		private function clearView():void
		{
			var children:Array = view.getChildren();
			for(var i:int = 0; i < children.length; i++)
			{
				delete (children[i] as Box).getChildren();
				delete children[i];
			}
			view.removeAllChildren();
			view.removeAllElements();
			System.gc();
			System.gc();
		}
		
		private function setSkill(xml:XML):void
		{
			if(xml == null) return;
			xmlSkill = xml;
			xmlB = xml.copy();
			
			var row:int = xml.children().length();
			for(var i:int = 0 ; i < row; i++)
			{
				var rowItem:SkillRow = new SkillRow();
				var skills:XMLList = xml.spLevel[i].skill.(@col != null);

				for(var j:int = 0; j < SKILL_ITEM_PER_ROW; j++)
				{
					
					var skill:XMLList = skills.(@col == j);
					
					if(skill.length() != 0)
					{
						var colItem:SkillItem = new SkillItem();
						colItem.skill = skill;
						colItem.width = SKILL_ITEM_WIDTH;
						colItem.height = SKILL_ITEM_HEIGHT;
						rowItem.addChild(colItem);
						
						//set pre skill bar
						if(skill.@pre.length() != 0)
						{
							var preSkill:XMLList = xmlSkill.spLevel.skill.(@name == skill.@pre);
							var preCol:int = preSkill.@col;
							var preRow:int = (preSkill.parent() as XML).childIndex();
							
							//same column
							if(preCol == j)
							{
								var startRow:int = (preSkill.parent() as XML).childIndex();
								var height:int = i * (SKILL_ITEM_HEIGHT + VERTICAL_PADDING) - startRow * (SKILL_ITEM_HEIGHT + VERTICAL_PADDING) - SKILL_ITEM_HEIGHT;
								var lb:VSkillPre = new VSkillPre();
								lb.width = SKILL_ITEM_WIDTH;
								lb.y = startRow * (SKILL_ITEM_HEIGHT + VERTICAL_PADDING) + SKILL_ITEM_HEIGHT + VERTICAL_PADDING/4;
								lb.x = 5 + j * (SKILL_ITEM_WIDTH + HORIZONTAL_PADDING); 
								lb.height = height;
								view.addChild(lb);
							}
								
							//same row
							if(preRow == i)
							{
								var lr:HSkillPre = new HSkillPre();
								
								//if vector is positive, pre-skill is at the right side of target skill
								var vector:int = preCol - j;
								lr.height = SKILL_ITEM_HEIGHT;
								lr.y = i * (SKILL_ITEM_HEIGHT + VERTICAL_PADDING);
								lr.width = (Math.abs(vector) - 1) * (SKILL_ITEM_WIDTH + HORIZONTAL_PADDING) + HORIZONTAL_PADDING;
								
								//pre-skill right
								if(vector > 0)
								{
									lr.x = 5 + j * (SKILL_ITEM_WIDTH + HORIZONTAL_PADDING) + SKILL_ITEM_WIDTH;
									lr.arrowDirection = HSkillPre.ARROW_DIRECTION_LEFT;
								}
								//pre-skill left
								else
								{
									lr.x = 5 + preCol * (SKILL_ITEM_WIDTH + HORIZONTAL_PADDING) + SKILL_ITEM_WIDTH;
									lr.arrowDirection = HSkillPre.ARROW_DIRECTION_RIGHT;
								}
								view.addChild(lr);
							}
						}
					}
					else
					{
						var emptyBox:Box = new Box();
						emptyBox.width = SKILL_ITEM_WIDTH;
						emptyBox.height = SKILL_ITEM_HEIGHT;
						rowItem.addChild(emptyBox);
					}
				}
				
				var spLevel:SkillLevel = new SkillLevel();
				spLevel.spLevel = xml.spLevel[i];
				rowItem.addChild(spLevel);
				view.addChild(rowItem);
				rowItem.y = i * (SKILL_ITEM_HEIGHT + VERTICAL_PADDING);
			}
			
			//set default skill point
			var preSkillXML:XMLList = (xml.spLevel.skill as XMLList).attribute("level");
			for(var p:int = 0; p < preSkillXML.length(); p++)
			{
				sendNotification(SkillPanel.SKILL_ADD);
			}
		}
		
		private function onSkillAdd(event:Event):void
		{
			var xml:XMLList = (event.target as SkillItem).skill;
			//if is over max skill level
			if(int(xml.@level) >= xml.level.length()) return;
			
			//check current sp
			var currentSp:int = sp;
			var needSp:int = xmlB.spLevel.skill.(@name == xml.@name).parent().@sp;
			if(currentSp < needSp)
			{
				Toast.show("技能點數不足");
				return;
			}
			
			//check pre skill
			if(xml.@pre.length() != 0)
			{
				//check pre skill is max level
				if(xmlSkill.spLevel.skill.(@name == xml.@pre).@level != xmlSkill.spLevel.skill.(@name == xml.@pre).level.length())
				{
					Toast.show("前置技能需點滿: " + xml.@pre);
					return;
				}
			}
			
			xml.@level = int(xml.@level) + 1;
			sendNotification(SkillPanel.SKILL_ADD);
		}
		
		private function onSkillSub(event:Event):void
		{
			var xml:XMLList = (event.target as SkillItem).skill;
			
			//if is lower than 0 or default skill level
			if(int(xml.@level) <= 0 ||  int(xml.@level) == xmlB.spLevel.skill.(@name == xml.@name).@level) return;
			
			//if is pre skill
			if(int(xmlSkill.spLevel.skill.(attribute("pre") == xml.@name).@level) > 0)
			{
				Toast.show("不能移除 " + xmlSkill.spLevel.skill.(attribute("pre") == xml.@name).@name+ " 的前置技能");
				return;
			}

			xml.@level = int(xml.@level) - 1;
			
			if(checkSkill())
			{
				sendNotification(SkillPanel.SKILL_SUB);
			}
			else
			{
				xml.@level = int(xml.@level) + 1;
			}
		}
		
		private function getMaxSPLevel():int
		{
			var spLevels:XMLList = xmlSkill.spLevel;
			for(var i:int = spLevels.length() - 1; i >= 0; i--)
			{
				var skills:XMLList = spLevels[i].skill;
				for(var j:int = skills.length() - 1; j >= 0; j--)
				{
					var skill:XML = skills[j];
					//has level attribute
					if(int(skill.@level) != 0)
					{
						return spLevels[i].@sp;
					}
				}
			}
			return 0;
		}
		
		//check sp is legal or not
		private function checkSkill():Boolean
		{
			var spLevels:XMLList = xmlSkill.spLevel;
			var maxSP:int = getMaxSPLevel();
			var sum:int = 0;
			for(var i:int = 0; i < spLevels.length() - 1; i++)
			{
				var sp:int = spLevels[i+1].@sp;
				var skills:XMLList = spLevels[i].skill;
				for(var j:int = 0; j < skills.length(); j++)
				{
					var skill:XML = skills[j];
					//has level attribute
					if(int(skill.@level) != 0)
					{
						sum += int(skill.@level);
					}
				}
				
				if(sum < sp && maxSP >= sp)
				{
					return false;
				}
			}
			return true;
		}
	}
}