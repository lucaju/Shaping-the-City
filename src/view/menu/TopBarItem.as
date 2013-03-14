package view.menu {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TopBarItem extends Sprite {
		
		//properties

		protected var bg:Sprite;
		protected var titleTF:TextField;
		protected var loader:Loader;
		protected var style:TextFormat;
		
		protected var _toggle:Boolean = false;
		protected var textColor:uint = 0xCCCCCC;
		protected var selectedColor:uint = 0xF15A24;
		
		private var squareButton:Boolean = true;
		private var w:Number;
		private var h:Number;
		
		public function TopBarItem() {
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.size = 11;
			style.color = textColor;
			
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.mouseEnabled = false;
			titleTF.autoSize = "left";
			
			bg = new Sprite();
			bg.mouseEnabled = false;
			
			this.buttonMode = true;
		}
		
		public function init(title:String, iconFile:String = null):void {
	
			//add BG
			this.addChild(bg);
			
			//pull icon
			if (iconFile != null) {
				loader = new Loader();
				loader.mouseEnabled = false;
				
				loader.load(new URLRequest(iconFile));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				
				this.addChild(loader);
				
			}
			
			//title
			titleTF.text = title;
			titleTF.setTextFormat(style);
			this.addChild(titleTF);
			
			
			//bg
			if (!squareButton) w = titleTF.width;
				
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF,0);
			bg.graphics.drawRoundRect(1,1,w,h,h/5);
			bg.graphics.endFill();
			
			//align text
			titleTF.y = bg.height * .7;
			titleTF.x = (bg.width/2) - (titleTF.width/2);
		}
		
		protected function onComplete(event:Event):void {
			loader.x = bg.x + ((bg.width/2) - (loader.width/2));
			loader.y = loader.height * .2;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
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
		
		public function setSize(_h:Number, _w:Number = 0):void {
			
			if (_w == 0) {
				_w = _h;
			}
			
			h = _h;
			w = _w;
		}

	}
}