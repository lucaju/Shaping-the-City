package view {
	
	//imports
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import util.DeviceInfo;
	
	import view.assets.ShadowLine;
	import view.assets.Switcher;
	import view.menu.FooterMenu;
	import settings.Settings;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Footer extends AbstractView {
		
		//****************** Properties ****************** ****************** ****************** 
		protected var bg							:Sprite;
		protected var h								:Number;			//Max height
		
		protected var style							:TextFormat;
		protected var menu							:FooterMenu;
		
		
		//****************** Properties ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function Footer(c:IController) {
			super(c);
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.color = 0x999999;
			
			if (DeviceInfo.os() == "iPhone") {
				h = 80;
				style.size = 20;
			} else {
				h = 40;
				style.size = 10;
			}
		}
		
		
		//****************** Initialize ****************** ****************** ******************
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			//1.background
			bg = new Sprite();
			bg.graphics.beginFill(0x333333);
			bg.graphics.drawRect(0,0,stage.stageWidth,h);
			bg.graphics.endFill();
			
			this.addChild(bg);
			
			//1.2 Shadow
			var shadowLine:ShadowLine = new ShadowLine(stage.stageWidth, "horizontal", 90);
			shadowLine.y = -shadowLine.height;
			bg.addChild(shadowLine)
			
			//2.credits
			var credits:TextField = new TextField();
			credits.selectable = false;
			credits.autoSize = "left";
			credits.text = "Developed by Luciano Frizzera, Sâmia Pedraça, and Edmonton Pipeline Team";
			credits.setTextFormat(style);
			credits.x = 10;
			credits.y = (bg.height/2) - (credits.height/2);
			this.addChild(credits);
			
			//3.menu
			var options:Array = [
				{title:"Explode"}//,
				//{title:"Animation"}
			];
			
			menu = new FooterMenu(this.getController(),options);
			menu.init();
			
			if (Settings.footerMenuButton == "switcher") {
				menu.x = bg.width - menu.width - 10;
				menu.y = (h/2) - (menu.height/2); 
			} else {
				menu.x = bg.width - menu.width;
			}
			
			this.addChild(menu);
			
			//positioning
			this.y = stage.stageHeight - h;
			
			//listeners
			stage.addEventListener(Event.RESIZE, resize);
			
		}
		
		//****************** EVENTS - ACTION ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onSort(event:Event):void {
			var target:Switcher = event.target as Switcher;
			
			var obj:Object = {source:target.label, state:target.state};
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.CHANGE,obj));
			
		}
		
		
		//****************** EVENTS - INTERFACE ****************** ****************** ******************
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function resize(event:Event):void {
			bg.width = stage.stageWidth;
			menu.x = bg.width - menu.width;
			this.y = stage.stageHeight - h;
		}
	}
}