package view.assets {
	
	//imports
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class UIControlButton extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		public static const CIRCLE				:String = "circle";
		public static const SQUARE				:String = "square";
		public static const ROUNDSQUARE			:String = "roundsquare";
		public static const MINUS				:String = "minus";
		public static const CROSS				:String = "cross";
		public static const PLUS				:String = "plus";
		
		protected const baseForms		:Array = new Array(CIRCLE,
														   SQUARE,
														   ROUNDSQUARE);			//Shapeforms
		
		protected const shapeForms		:Array = new Array(CIRCLE,
														   SQUARE,
														   ROUNDSQUARE,
														   MINUS,
														   CROSS,
														   PLUS);					//Shapeforms
		
		protected var _baseColor		:uint = 0x000000;							//Base color. Default: 0x000000 (Black)
		protected var _baseAlpha		:Number = 1;								//Base alpha. Default: 1 (visible)
		protected var _shapeColor		:uint = 0XFFFFFF;							//Shape Color. Default: 0xFFFFFF (White)
		
		protected var _baseGeometry		:String = SQUARE;							//Geometry. Default: Square
		protected var _shapeGeometry	:String										//Geometry
		
		protected var base				:Shape;										//Base
		protected var shape				:Shape;										//Shape
		
		
		//****************** CONSTRUCTOR ****************** ******************  ******************
		public function UIControlButton() {
			this.buttonMode = true;
		}
		
		//****************** GETTERS ****************** ******************  ******************

		public function get baseGeometry():String {
			return _baseGeometry;
		}
		
		public function get shapeGeometry():String {
			return _shapeGeometry;
		}
		
		public function get baseColor():uint {
			return _baseColor;
		}
		
		public function get shapeColor():uint {
			return _shapeColor;
		}
		
		public function get baseAlpha():Number {
			return _baseAlpha;
		}

		
		//****************** SETTERS ****************** ******************  ******************
		
		public function set baseGeometry(value:String):void {
			
			var validForm:Boolean = true;
			
			for each (var form:String in baseForms) {
				if (value == form) {
					break;
				}
			}
			
			if (!validForm) {
				throw new Error("Invalid geometry form");
			} else {
				_baseGeometry = value;
			}
		}
		
		public function set shapeGeometry(value:String):void {
			_shapeGeometry = value;
			
			var validForm:Boolean = true;
			
			for each (var form:String in shapeForms) {
				if (value == form) {
					break;
				}
			}
			
			if (!validForm) {
				throw new Error("Invalid geometry form");
			} else {
				_shapeGeometry = value;
			}
		}
		
		public function set baseColor(value:uint):void {
			_baseColor = value;
		}
		
		public function set shapeColor(value:uint):void {
			_shapeColor = value;
		}
		
		public function set baseAlpha(value:Number):void {
			_baseAlpha = value;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ******************

		public function draw():void {
			if (!shapeGeometry) {
				throw new Error("You must define shape geometry");
			}
			
			if (base) {
				throw new Error("Button is already constructed");
			}
			
			//-----Base
			shape = new Shape();
			shape.graphics.beginFill(baseColor,baseAlpha);
			
			switch (baseGeometry) {
				
				case CIRCLE:
					shape.graphics.drawCircle(0,0,5);
					break;
				
				case SQUARE:
					shape.graphics.drawRect(-5,-5,10,10);
					break;
				
				case ROUNDSQUARE:
					shape.graphics.drawRoundRect(-5,-5,10,10,6);
					break;
			}
			
			shape.graphics.endFill();
			this.addChild(shape);
			
			//-----Shape
			shape = new Shape();
			shape.graphics.beginFill(shapeColor);
			
			switch (shapeGeometry) {
				
				case CIRCLE:
					shape.graphics.drawCircle(0,0,2);
					break;
				
				case SQUARE:
					shape.graphics.drawRect(-2,-2,4,4);
					break;
				
				case ROUNDSQUARE:
					shape.graphics.drawRoundRect(-2,-2,4,4,2);
					break;
				
				case CROSS:
					shape.graphics.drawRect(-1,-4,2,8);
					shape.graphics.drawRect(-4,-1,8,2);
					shape.graphics.drawRect(-1,-1,2,2);
					shape.rotation = 45;
					break;
				
				case PLUS:
					shape.graphics.drawRect(-1,-4,2,8);
					shape.graphics.drawRect(-4,-1,8,2);
					shape.graphics.drawRect(-1,-1,2,2);
					break;
				
				case MINUS:
					shape.graphics.drawRect(-4,-1,8,2);
					break;
			}
			
			shape.graphics.endFill();
			this.addChild(shape);
			
		}

	}
}