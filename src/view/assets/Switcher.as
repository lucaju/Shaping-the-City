package view.assets {
	
	//import
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class Switcher extends Sprite {
		
		//****************** Properties ****************** ****************** ****************** 
		public const RECT					:String = "rect";
		public const ROUND_RECT				:String = "round_rect";
		public const ROUND					:String = "round";
		
		protected var type					:String;
		protected var _state				:Boolean;
		
		protected var w						:Number = 48;
		protected var h						:Number = 18;
		
		private var buttonArea				:Sprite
		private var button					:Sprite;
		
		protected var _label				:String;
		
		protected var _onColor				:uint = 0xF15A24;
		protected var _offColor:			uint = 0x666666;
		protected var _buttonColor			:uint = 0xFFFFFF;
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param _type
		 * @param state_
		 * 
		 */
		public function Switcher(_type = this.ROUND, state_:Boolean = false) {
			state = state_;
			type = _type;
		}
		
		
		//****************** Initialize ****************** ****************** ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			var SwitcherComponent:Sprite = new Sprite();
			this.addChild(SwitcherComponent);
			
			//1. slot
			var slot:Sprite = new Sprite();
			slot.graphics.beginFill(0xFFFFFF);
			
			switch (type) {
				case this.RECT:
					slot.graphics.drawRect(0,0,w,h);
					break;
				
				case this.ROUND:
					slot.graphics.drawRoundRect(0,0,w,h,h);
					break;
				
				default:
					slot.graphics.drawRoundRect(0,0,w,h,h/2);
					break;
			}
			
			slot.graphics.endFill();
			
			SwitcherComponent.addChild(slot);
			
			//2.Button Area start
			buttonArea = new Sprite();
			
			//2.1.Area On
			var areaOn:Sprite = new Sprite();
			areaOn.graphics.beginFill(onColor);
			areaOn.graphics.drawRect(0,0,w,h);
			areaOn.graphics.endFill();
			areaOn.mouseEnabled = false;
			buttonArea.addChild(areaOn);
			
			var styleOn:TextFormat = new TextFormat("Myriad Pro",Math.ceil(h*.6),0xFFFFFF,true);
			
			var labelTF:TextField = new TextField;
			labelTF.autoSize = "left";
			labelTF.selectable = false;
			labelTF.text = "ON";
			labelTF.setTextFormat(styleOn);
			labelTF.x = w/3;
			labelTF.y = (buttonArea.height/2) - (labelTF.height/2) + 1;
			
			areaOn.addChild(labelTF);
			
			
			//2.2.Area Off
			var areaOff:Sprite = new Sprite();
			areaOff.graphics.beginFill(offColor);
			areaOff.graphics.drawRect(0,0,w,h);
			areaOff.graphics.endFill();
			areaOff.x = areaOn.width;
			areaOff.mouseEnabled = false;
			buttonArea.addChild(areaOff);
			
			var styleOff:TextFormat = new TextFormat("Myriad Pro",Math.ceil(h*.6),0xCCCCCC,true);
			
			labelTF = new TextField;
			labelTF.autoSize = "left";
			labelTF.selectable = false;
			labelTF.text = "OFF";
			labelTF.setTextFormat(styleOff);
			labelTF.x = areaOff.width - labelTF.width - (w/3);
			labelTF.y = (buttonArea.height/2) - (labelTF.height/2) + 1;
			
			areaOff.addChild(labelTF);
			
			//2.3.Hit
			button = drawButtonHit();
			
			switch (type) {
				case this.RECT:
					button.x = button.width/2;
					break;
				
				case this.ROUND:
					button.x = button.width/2;
					button.y = buttonArea.height/2
					break;
				
				default:
					button.x = button.width/2;
					break;
			}
			
			//2.3.1 glow effects
			var fxs1:Array = new Array();
			var fxGlow1:BitmapFilter = getBitmapFilter(0x000000, .5);
			fxs1.push(fxGlow1);
			button.filters = fxs1;
			
			SwitcherComponent.addChild(button);
			
			
			//2.4 Button Area end
			//buttonArea.x = -(buttonArea.width/2) + (buttonHit.width/2);
			buttonArea.x = -(buttonArea.width/2) + (button.width/2);
			buttonArea.mask = slot;
			SwitcherComponent.addChildAt(buttonArea,0);
			
			
			//3. Label
			if (label) {
				var styleLabel:TextFormat = new TextFormat("Myriad Pro",h * .75,0x999999,true);
				
				labelTF = new TextField;
				labelTF.autoSize = "left";
				labelTF.selectable = false;
				
				labelTF.text = label;
				labelTF.setTextFormat(styleLabel);
				
				this.addChild(labelTF);
				
				SwitcherComponent.x = labelTF.width + 5;
				labelTF.y = (buttonArea.height/2) - (labelTF.height/2);
			}
			
			
			//4. glow effects
			var fxs:Array = new Array();
			var fxGlow:BitmapFilter = getBitmapFilter(0x000000, .5,true);
			fxs.push(fxGlow);
			buttonArea.filters = fxs;
			
			//5. Listener
			button.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			button.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			
		}
		
		
		//****************** GETTERS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get state():Boolean {
			return _state;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get label():String {
			return _label;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get onColor():uint {
			return _onColor;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get offColor():uint {
			return _offColor;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get buttonColor():uint {
			return _buttonColor;
		}
		
		
		//****************** SETTERS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set state(value:Boolean):void {
			_state = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set label(value:String):void {
			_label = value;
		}		
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set onColor(value:uint):void {
			_onColor = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set offColor(value:uint):void {
			_offColor = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set buttonColor(value:uint):void {
			_buttonColor = value;
		}
		
		/**
		 * 
		 * @param _w
		 * @param _h
		 * 
		 */
		public function setSize(_w:Number, _h:Number):void {
			h = _h;
			w = _w;
		}
		
		
		//****************** PROTECTED METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function drawButtonHit():Sprite {
			
			var bt:Sprite = new Sprite();
			
			var colorArea:Shape = new Shape();
			colorArea.graphics.lineStyle(1,0x999999,1,true);
			colorArea.graphics.beginFill(buttonColor);
			
			var shadow:Shape = new Shape();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(163, 24, (Math.PI/180)*90, 0, 00);
			shadow.graphics.beginGradientFill("linear",[0xAAAAAA,0x222222],[.1,.9],[0,255],matrix);
			shadow.blendMode = "multiply";
			shadow.alpha = .7;
			
			switch (type) {
				case this.RECT:
					colorArea.graphics.drawRect(-h/2,0,h,h);
					shadow.graphics.drawRect(-h/2,0,h,h);
					break;
				
				case this.ROUND:
					colorArea.graphics.drawCircle(0,0,h/2);
					shadow.graphics.drawCircle(0,0,h/2);
					break;
				
				default:
					colorArea.graphics.drawRoundRect(-h/2,0,h,h,h/2);
					shadow.graphics.drawRoundRect(-h/2,0,h,h,h/2);
					break;
			}
			
			colorArea.graphics.endFill();
			shadow.graphics.endFill();
			
			bt.addChild(colorArea);
			bt.addChild(shadow);
			bt.buttonMode = true;
			return bt;
		}
		
		// fx
		/**
		 * 
		 * @param colorValue
		 * @param a
		 * @param innerGlow
		 * @return 
		 * 
		 */
		protected function getBitmapFilter(colorValue:uint, a:Number, innerGlow:Boolean = false):BitmapFilter {
			//propriedades
			var color:Number = colorValue;
			var alpha:Number = a;
			var blurX:Number = 3;
			var blurY:Number = 3;
			var strength:Number = 3;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality,true);
		}
		
		/**
		 * 
		 * 
		 */
		protected function checkState():void {
			
			if (buttonArea.x <= - (this.w/2)) {
				state = false;
				TweenMax.to(buttonArea,.3,{x:-(buttonArea.width/2) + (button.width/2)});
				TweenMax.to(button,.3,{x:button.width/2});
			} else {
				state = true;
				TweenMax.to(buttonArea,.3,{x: - button.width/2});
				TweenMax.to(button,.3,{x:this.w - (button.width/2)});
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		
		//****************** EVENTS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function _onMouseDown(event:MouseEvent):void {
			var rect:Rectangle = new Rectangle (button.width/2, button.y, this.w - button.width, 0);	
			//var rect:Rectangle = new Rectangle ((-buttonArea.width/2) + (event.currentTarget.width/2), 0, (buttonArea.width/2)-(event.currentTarget.width/2), 0);
			button.startDrag(false,rect);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			button.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onMouseMove(event:MouseEvent):void {
			
			//buttonArea.x = button.x + (button.width/4) - (buttonArea.width/2);
			buttonArea.x = button.x - (buttonArea.width/2) 	;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function _onMouseUp(event:MouseEvent):void {
			buttonArea.stopDrag();
			button.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			checkState();
		}
		
	}
}