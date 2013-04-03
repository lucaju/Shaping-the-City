package view.menu {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ButtonBar Class.
	 * 
	 * This class represents the buttons used in TopBar and Footer. 
	 * @author lucaju
	 * 
	 */
	public class ButtonBar extends Sprite {
		
		//****************** Proprieties ****************** ****************** ****************** 

		protected var bg				:Sprite;					//Bg container
		protected var _bgFile			:String;					//BG bitmap file
		protected var bgW					:Number;					//BG width
		protected var bgH					:Number;					//BG height
		
		protected var icon				:Sprite;					//Icon container
		protected var _iconFile			:String;					//Icon bitmap file
		
		protected var titleTF			:TextField;					//Title Textfield
		protected var style				:TextFormat;				//Text Style
		protected var textColor			:uint = 0xCCCCCC;			//Text Color. Default: 0xCCCCCC (Gray)
		protected var selectedColor		:uint = 0xF15A24;			//Hightlight Color. Default: 0xF15A24 (Orange)
		
		protected var loader			:Loader;					//Loader Container
		
		protected var _toggle			:Boolean = false;			//Toggle. Defult: false
		protected var _lockWidth		:Boolean = true;			//Max width is define by bg (true) or text (false). Default = true
		
		
		//****************** Contructor ****************** ****************** ******************
		
		/**
		 * Button Bar Contructor.
		 * <p>Prepare button. Set the style, and textfield and bg containers.</p> 
		 * 
		 */
		public function ButtonBar() {
			
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
		
		//****************** GETTERS ****************** ****************** ******************

		/**
		 * Title. Return the title string.
		 * @return: String
		 * 
		 */
		public function get title():String {
			return titleTF.text;
		}
		
		/**
		 * Toggle. Return whether the item is ON (true) or OFF (false).
		 * @return:Boolean 
		 * 
		 */
		public function get toggle():Boolean {
			return _toggle;
		}
		
		/**
		 * Return if it is width Locked. 
		 * @return 
		 * 
		 */
		public function get lockWidth():Boolean{
			return _lockWidth;
		}
		
		//****************** SETTERS ****************** ****************** ******************
		
		/**
		 * bgFile. Set background bitmap file 
		 * @param value
		 * 
		 */
		public function set bgFile(value:String):void {
			if (_bgFile == null) {
				_bgFile = value;
			}
		}

		/**
		 * iconFile. Set icon bitmap file
		 * @param value
		 * 
		 */
		public function set iconFile(value:String):void {
			if (_iconFile == null) {
				_iconFile = value;
			}
		}
		
		/**
		 * titleSize. Set the title's font size. 
		 * @param value
		 * 
		 */
		public function set titleSize(value:uint):void {
			style.size = value;
		}
		
		/**
		 * Set lock width 
		 * @param value
		 * 
		 */
		public function set lockWidth(value:Boolean):void {
			_lockWidth = value;
		}
		
		/**
		 * setSize. Set Background size.
		 *  
		 * @param _h:Number
		 * @param _w:Number
		 * 
		 */
		public function setSize(_h:Number, _w:Number = 0):void {
			
			if (_w == 0) {
				_w = _h;
			}
			
			bgH = _h;
			bgW = _w;
		}
		
		/**
		 * Toggle. Set the item ON (true) or OFF (false).
		 * @param value
		 * 
		 */
		public function set toggle(value:Boolean):void {
			_toggle = value;
			
			if (!_toggle) {
				TweenMax.to([icon,titleTF],.3,{removeTint:true});
				
				if (_bgFile != null) {
					bg.alpha = 0;
				}
					
			} else {
				TweenMax.to([icon,titleTF],.3,{tint:selectedColor})
					
				if (_bgFile != null) {
					bg.alpha = 1;
				}
			}
			
		}

		//****************** Initiate ****************** ****************** ******************
		
		/**
		 * init. Render Item on the screen.
		 * <p>Set the backgorund. Either load an image or draw a rectangle.</p>
		 * <p>Load icon image.</p>
		 * <p>Set Title.</p>
		 *  
		 * @param title: String
		 * 
		 */
		public function init(title:String):void {
	
			//1. Add BG
			this.addChild(bg);
			loader = new Loader();
			loader.load(new URLRequest(_bgFile));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBgComplete);
			bg.addChild(loader);
			
			//2. Pull icon
			if (_iconFile != "") {
				icon = new Sprite();
				this.addChild(icon);
				
				loader = new Loader();
				loader.mouseEnabled = false;
				
				loader.load(new URLRequest(_iconFile));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconComplete);
				
				icon.addChild(loader);
				
			}
			
			//3. title
			titleTF.text = title;
			titleTF.setTextFormat(style);
			this.addChild(titleTF);
			
			//4. Bg (if bg is an image, this is just a place holder)
			if (!lockWidth) bgW = titleTF.width + 10;				
			
			//draw bg
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF,0);
			bg.graphics.drawRoundRect(1,1,bgW,bgH,bgH/5);
			bg.graphics.endFill();
						
		}
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * onIconComplete. Set icon position. 
		 * @param event
		 * 
		 */
		protected function onIconComplete(event:Event):void {
			icon.x = bg.x + ((bg.width/2) - (loader.width/2));
			icon.y = loader.height * .2;
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onIconComplete);
		}
		
		/**
		 * onBGComplete. Align text after Bg is loaded.  
		 * @param event
		 * 
		 */
		protected function onBgComplete(event:Event):void {
			
			//align text
			
			if (_iconFile == "") {
				titleTF.y = (bg.height/2) - (titleTF.height/2);
			} else {
				titleTF.y = bg.height - titleTF.height - 2;
			}
			
			titleTF.x = (bg.width/2) - (titleTF.width/2);
			
			bg.graphics.clear();
			bg.alpha = 0;
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBgComplete);
		}

	}
}