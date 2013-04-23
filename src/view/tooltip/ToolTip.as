package view.tooltip {
	
	//
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ToolTip extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var _id						:int;						//Holds ToolTip Id
		protected var _sourceId					:int;						//Holds Source Id
		
		protected var margin					:Number = 4;				//Margin size
		
		protected var _arrowDirection			:String = "bottom";			//Arrow point direction
		protected var _balloonColor				:uint 	= 0xFFFFFF;			//Balloon Color
		protected var _balloonAlpha				:Number = 1;				//Balloon Alpha
		protected var _textColor				:uint	= 0x000000;			//Text Color
		
		protected var _fontSize					:uint;						//Text Size
		
		
		//****************** Properties ****************** ******************  ****************** 
		
		public function ToolTip() {
			
		}
			
		//****************** INITIALIZE ****************** ******************  ****************** 
		
		public function init(data:Object, id_:int = 0):void {
			
			_id = id_;
			if (data.id) _sourceId = data.id;
			
			//style
			var style:TextFormat = new TextFormat();
			style.font = "Myriad Pro";
			style.size = _fontSize;
			style.leading = 5;
			style.color = _textColor;
			style.align = "center";
			
			//title
			var textTF:TextField = new TextField();
			textTF.selectable = false;
			textTF.multiline = true;
			textTF.mouseWheelEnabled = false;
			textTF.mouseEnabled = false;
			//textTF.wordWrap = true;
			textTF.autoSize = "left";
			
			textTF.htmlText = data.info;
			
			textTF.setTextFormat(style);
			
			addChild(textTF);
			
			//shape
			var shapeBox:Balloon = new Balloon();
			shapeBox.color = _balloonColor;
			shapeBox.alpha = _balloonAlpha;
			shapeBox.arrowDirection = arrowDirection;
			shapeBox.glow(true);
			shapeBox.init(this.width + margin + margin, this.height + margin);
			
			this.addChildAt(shapeBox,0);
			
			//elements Position
			shapeBox.x = -shapeBox.width/2;
			shapeBox.y = -shapeBox.height;
			
			textTF.x = shapeBox.x + (margin/2);
			textTF.y = shapeBox.y + (margin/2);

		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get id():int {	
			return _id;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get sourceId():int {	
			return _sourceId;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get arrowDirection():String {
			return _arrowDirection;
		}
		
		//****************** SETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function set arrowDirection(value:String):void {
			_arrowDirection = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set balloonColor(value:uint):void{
			_balloonColor = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set balloonAlpha(value:Number):void {
			_balloonAlpha = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set textColor(value:uint):void {
			_textColor = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set fontSize(value:uint):void {
			_fontSize = value;
		}

		
	}
}