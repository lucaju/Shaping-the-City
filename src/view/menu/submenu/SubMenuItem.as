package view.menu.submenu {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SubMenuItem extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var _type				:String;				//Item type
		protected var _fixedSize			:Boolean				//Fixed item sized
		protected var _toggle			:Boolean = false;		//Toggle to turn it ON or Off. Default: false (OFF)
		
		protected var _marginH			:Number = 20;			//internal horizontal margin
		protected var _marginV			:Number = 8;			//internal vertical margin
		
		protected var bg				:Sprite;				//Background
		protected var bgW				:Number = 100;			//background width
		protected var bgH				:Number = 20;			//background height
		
		protected var titleTF			:TextField;				//Title Textfield
		protected var style				:TextFormat;			//Text style
		protected var textColor			:uint = 0xCCCCCC;		//Text Color. Default: 0xCCCCCC (Gray)
		protected var selectedColor		:uint = 0xF15A24;		//Hightlight Color. Default: 0xF15A24 (Orange)

		
		/**
		 * Abstract Constructor. 
		 * <p>Abstract Submenu is an abstraction of submenu. It requires a controller and contentType</p>
		 * <p>The controller is the default app controller, in this case PipelineController.</p>
		 * <p>The Content Type define which content the subMenu will laod. It can be change on runtime.</p>
		 * 
		 * @param c:Icontroller
		 * @param type_:String
		 * 
		 */
		public function SubMenuItem(type_:String, w_:Number = 100) {
			_type = type_;
			
			bgW = w_;
			
			style = new TextFormat();
			style.font = "Myriad Pro";
			style.size = 16;
			style.leading = 2;
			style.color = textColor;
			style.align = "center";
			
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
		 * type. Return item type. 
		 * @return:String
		 * 
		 */
		public function get type():String {
			return _type;
		}
		
		/**
		 * isFixedSize. Return whether the item is fixed size or not. 
		 * @return:Boolean
		 * 
		 */
		public function get isFixedSize():Boolean {
			return _fixedSize;
		}

		/**
		 * marginH. Return internal horizontal margin 
		 * @return:Number
		 * 
		 */
		public function get marginH():Number {
			return _marginH;
		}
		
		/**
		 * marginV. Return internal vertical margin
		 * @return:Number
		 * 
		 */
		public function get marginV():Number {
			return _marginV;
		}
		
		/**
		 * title. Return title text in the titleTF 
		 * @return:String
		 * 
		 */
		public function get title():String {
			return titleTF.text;
		}
		
		/**
		 * toggle. Return item toggle: On (true) or OFF (false).
		 * @return:Boolean
		 * 
		 */
		public function get toggle():Boolean {
			return _toggle;
		}
		
		//****************** SETTERS ****************** ****************** ****************** 
		/**
		 * marginH. Set internal horizontal margin
		 * @return:Number
		 * 
		 */
		public function set marginH(value:Number):void {
			_marginH = value;
		}
		
		/**
		 * fixedSize. Set fixedSize. 
		 * @param value
		 * 
		 */
		public function set fixedSize(value:Boolean):void {
			_fixedSize = value;
		}
		
		/**
		 * marginV. Set internal vertical margin
		 * @return:Number
		 * 
		 */
		public function set marginV(value:Number):void {
			_marginV = value;
		}
		
		/**
		 * titleSize. Set font size. 
		 * @param value:uint
		 * 
		 */
		public function set titleSize(value:uint):void {
			style.size = value;
		}
		
		/**
		 * toggle. Set item toggle: ON (true), OFF (false).
		 * <p>Perform animation</p>
		 * @param value:Boolean
		 * 
		 */
		public function set toggle(value:Boolean):void {
			_toggle = value;
			
			if (!_toggle) {
				TweenMax.to(this,.3,{removeTint:true})
			} else {
				TweenMax.to(this,.3,{tint:selectedColor})
			}
			
		}
		
		//****************** PUBLIC METHODS ****************** ****************** ****************** 
		
		/**
		 *  Initialization
		 * @param title:String
		 */
		public function init(title:String):void {
			//add BG
			this.addChild(bg);
			
			//title
			if (isFixedSize) {
				titleTF.multiline = true;
				titleTF.wordWrap = true;
				titleTF.width = bgW - marginH;
			}
			
			titleTF.text = title;
			titleTF.setTextFormat(style);
			this.addChild(titleTF);
			
			
			//bg
			bgW = titleTF.width + marginH;
			bgH = titleTF.height + marginV;
			
			bg.graphics.clear();
			
			if (Settings.useSubMenuItemSeparator) {
				bg.graphics.beginFill(0xFFFFFF,0);
			} else {
				bg.graphics.beginFill(0xFFFFFF,.1);
			}
			
			bg.graphics.drawRect(0,0,bgW,bgH);
			bg.graphics.endFill();
			
			//align text
			titleTF.x = (bg.width/2) - (titleTF.width/2);
			titleTF.y = (bg.height/2) - (titleTF.height/2);
		}		

	}
}