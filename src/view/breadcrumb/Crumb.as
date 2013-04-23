package view.breadcrumb {
	
	//imports
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import view.assets.UIControlButton;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Crumb extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var marginH			:uint = 3;
		protected var titleTF			:TextField;
		protected var closeBT			:UIControlButton;
		protected var style				:TextFormat;
		protected var crumbHeight		:Number = 20;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * Contructor 
		 * @param title
		 * 
		 */
		public function Crumb() {
			style = new TextFormat();
		}
		
		
		//****************** Initialize ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param title
		 * 
		 */
		public function init(title:String):void {
			
			style.font = "Myriad Pro";
			style.color = 0x333333;
			
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.mouseEnabled = false;
			titleTF.autoSize = "left";
			titleTF.text = title;
			titleTF.setTextFormat(style);
			titleTF.x = marginH;
			
			this.addChild(titleTF);
			
			//cross bt
			closeBT = new UIControlButton();
			closeBT.shapeGeometry = UIControlButton.CROSS;
			closeBT.shapeColor = 0x999999;
			closeBT.baseAlpha = 0;
			closeBT.draw();
			closeBT.x = titleTF.width + (closeBT.width/2) + marginH;;
			
			this.addChild(closeBT);
			
			
			//bg
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xFFFFFF,0.6);
			bg.graphics.drawRect(0,0,this.width + marginH,crumbHeight);
			bg.graphics.endFill();
			
			this.addChildAt(bg,0);
			
			titleTF.y = (bg.height/2) - (titleTF.height/2);
			closeBT.y = bg.height/2;
			
			this.buttonMode = true;
			
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
				
		/**
		 * Return Crumb Title 
		 * @return 
		 * 
		 */
		public function get title():String {
			return titleTF.text;
		}
		
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * titleSize. Set font size. 
		 * @param value:uint
		 * 
		 */
		public function set titleSize(value:uint):void {
			style.size = value;
		}
		
		/**
		 * Set Crumb Height. 
		 * @param value:Number
		 * 
		 */
		public function setCrumbHeight(value:Number):void {
			crumbHeight = value;
		}
		
	}
}