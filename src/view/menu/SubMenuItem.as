package view.menu {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SubMenuItem extends Sprite {
		
		//properties
		protected var bg:Sprite;
		protected var titleTF:TextField;
		protected var style:TextFormat;
		
		protected var _toggle:Boolean = false;
		protected var textColor:uint = 0xCCCCCC;
		protected var selectedColor:uint = 0xF15A24;
		
		private var w:Number;
		private var h:Number;
		
		private var marginH:Number = 20;
		private var marginV:Number = 8;
		
		public function SubMenuItem(h_:Number = 20) {
			
			h = h_;
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.size = 16;
			style.color = textColor;
			
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.mouseEnabled = false;
			titleTF.autoSize = "left";
			
			bg = new Sprite();
			bg.mouseEnabled = false;
			
			this.buttonMode = true;
			
		}
		
		public function init(title:String):void {
			
			//add BG
			this.addChild(bg);
			
			//title
			titleTF.text = title;
			titleTF.setTextFormat(style);
			this.addChild(titleTF);
			
			
			//bg
			w = titleTF.width + marginH;
			h = titleTF.height + marginV;
			
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF,0.1);
			bg.graphics.drawRect(0,0,w,h);
			bg.graphics.endFill();
			
			//align text
			titleTF.x = (bg.width/2) - (titleTF.width/2);
			titleTF.y = (bg.height/2) - (titleTF.height/2);
		}
		
		public function get title():String {
			return titleTF.text;
		}
		
		public function set titleSize(value:uint):void {
			style.size = value;
		}
		
		public function get toggle():Boolean {
			return _toggle;
		}
		
		public function set toggle(value:Boolean):void {
			_toggle = value;
			
			if (!_toggle) {
				TweenMax.to(this,.3,{removeTint:true})
			} else {
				TweenMax.to(this,.3,{tint:selectedColor})
			}
			
		}
		
	}
}