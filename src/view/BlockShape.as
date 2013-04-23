package view {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Block Shape.
	 * <p>This class repreents a city shape model on the screen</p>
	 *  
	 * @author lucaju
	 * 
	 */
	public class BlockShape extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		protected var _id				:int;							//Block ID. Heps to keep track of the changes in the model.
		protected var _neighbourhood	:int;							//Neighbouthood ID. Helps to find and group this shape.
		protected var _location			:Point;							//Save the relative geolocation on the screen 
		protected var _vector			:Vector.<Number>;				//Keeps the vector that defines the geometric shape.
		protected var _surface			:Number;						//Keeps the shape surface area
		protected var scale				:Number = 1;					//Keeps the origianl shape scale. Default: 1.
		
		protected var _highlighted		:Boolean = false;				//higlighted Toggle. Deault = false/
		protected var _selected			:Boolean = false;				//Selected Toggle. Deault = false/
		protected var _dimed			:String;						//Dim Toggle. Deault = false/
		
		protected var _registrationTL	:Point							//Keep the Top Left Registration point	
		
		protected var highlightColor	:uint = 0xF15A24;				//Highlisht Color. Default = 0x4363AE (blue)
		protected var selectColor		:uint = 0x4363AE;				//Highlisht Color. Default = 0xF15A24 (orange)
		
		//protected var _numTrees		:int 				= 0;		//Save the number of trees in this block

		
		//****************** Constructor ****************** ******************  ****************** 
		/**
		 * Contructor.
		 * <p>Requeired:</p>
		 * <p>Block ID - It has to match the CtyShape ID model</p>
		 * <p>Optional:</p>
		 * <p>Scale - Is set according to the proportion between the map and the screen. The default value is 1.</p> 
		 * 
		 * @param id_:int
		 * @param _scale:Number = 1
		 * 
		 */
		public function BlockShape(id_:int, _scale:Number = 1) {
			_id = id_;
			scale = _scale;
		}
		
		
		//****************** INIT ****************** ****************** ****************** 
		
		/**
		 * INIT. Initiate the Block Shape.
		 * <p>Required:<>
		 * <p>Cordenates: An Array of points (x,y) of each shape's vertice.
		 * <p>A nre vector will be build to draw the geometric shape.</p>
		 * <p>Surface methd will be automatically called to calculate the its area.</p>
		 *  
		 * @param coords:Array
		 * 
		 */
		public function init(coords:Array):void {
			var origin:Point = new Point(coords[0].x, coords[0].y);
			
			var shape:Array = new Array();
			
			for each (var coord:Point in coords) {
				//populate vector parts
				shape.push((coord.x - origin.x) * scale);
				shape.push((coord.y - origin.y) * scale);
			}
			
			//create vector and save the vector
			vector = Vector.<Number>(shape);
			
			var command:Vector.<int> = new Vector.<int>();
			var c:int = 0;
			
			//vector coordinates loop
			for (var i:int = 0; i < shape.length; i++) {
				
				if(i%2 == 0) {
					if (i==0) {
						command[c] = 1;
					} else {
						command[c] = 2;
					}
						
					c++;
				}
				
			}
			
			//draw object
			this.graphics.beginFill(0x333333);
			this.graphics.drawPath(command,vector);
			this.graphics.endFill();
			
			this.alpha = .6;
			
			//surface
			surface = calculateSurface();
			
			//TOP LEFT REGISRATION
			var bounds:Rectangle = this.getBounds(this);
			
			_registrationTL = new Point();
			_registrationTL.x = bounds.x;
			_registrationTL.y = bounds.y;
			
			//listeners
			//this.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDown);
			//this.addEventListener(MouseEvent.MOUSE_UP, _mouseUp);
			
		}
		
		
		//****************** GETTERS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get registrationTL():Point {
			return _registrationTL;
		}
		
		/**
		 * ID. Returns Block ID.
		 *  
		 * @return:int
		 * 
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * Neighbourhood. Returns Block's neighbourhood. 
		 * 
		 * @return:int
		 * 
		 */
		public function get neighbourhood():int {
			return _neighbourhood;
		}
		
		/**
		 * Location. Returns block's relative geolocation on the screen 
		 *  
		 * @return 
		 * 
		 */
		public function get location():Point {
			return _location;
		}
		
		/**
		 * Vector. Returns the vector that defines the geometric shape.
		 *  
		 * @param value
		 * 
		 */
		public function get vector():Vector.<Number> {
			return _vector;
		}
		
		/**
		 * Surface. Returns shape's surface area.
		 * 
		 * @return:Number
		 * 
		 */
		public function get surface():Number {
			return _surface;
		}
		
		/**
		 * Highlight. Returns block's current highlight condition.
		 * 
		 * @return:boolean
		 * 
		 */
		public function get highlighted():Boolean {
			return _highlighted;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get selected():Boolean {
			return _selected;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get dimed():String {
			return _dimed;
		}
		
		/*
		public function get numTrees():int {
		return _numTrees;
		}
		*/
		
		
		//****************** SETTERS ****************** ****************** ****************** 
		
		/**
		 * Neighbourhood. Set block's neighbourhood.
		 *  
		 * @param value
		 * 
		 */
		public function set neighbourhood(value:int):void {
			_neighbourhood = value;
		}
		
		/**
		 * Location. Set block's relative position in the screen.
		 *  
		 * @param value
		 * 
		 */
		public function set location(value:Point):void {
			_location = value;
		}
		
		/**
		 * Vector. Save the vector that defines the geometric shape.
		 *  
		 * @param value
		 * 
		 */
		public function set vector(value:Vector.<Number>):void {
			_vector = value;
		}
		
		/**
		 * Surface. Save shape's surface area.
		 *  
		 * @param value
		 * 
		 */
		public function set surface(value:Number):void {
			_surface = value;
		}
		
		/**
		 * Highlight. Set block's current highlight condition.
		 * <p>Automatically calls for highlight method to cahnge its appearance</p> 
		 * 
		 * @param value:Boolean
		 * 
		 */
		public function set highlighted(value:Boolean):void {
			_highlighted = value;
			
			if (!selected) {
				
				//kill tween if one overlap another
				if (TweenMax.getTweensOf(this).length > 0) {
					var tw:TweenMax = TweenMax.getTweensOf(this)[0] as TweenMax;
					tw._kill();
				}
				
				if (highlighted) {
					TweenMax.to(this,.5,{tint:highlightColor, delay:Math.random()});
				} else {
					TweenMax.to(this,.2,{removeTint:true, delay:Math.random()});
					
				}
				
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void {
			_selected = value;
			
			if (selected) {
				TweenMax.to(this,.5,{tint:selectColor});
			} else {
				if (highlighted) {
					TweenMax.to(this,.5,{tint:highlightColor});
				} else {
					TweenMax.to(this,.5,{removeTint:true});
				}
			}
		}
		
		/*
		public function set numTrees(value:int):void {
		_numTrees = value;
		}
		*/
		
		
		//****************** PROTECTED METHODS ****************** ****************** ******************
		
		/**
		 * Calculate Surface. Performs area calculation in the geometric form of the shape.
		 *  
		 * @return: Number
		 * 
		 */
		protected function calculateSurface():Number {
			
			//calculate are of a non convex irregular poligon
			//A = (1/2)[Det(x1,x2,y1,y2)+Det(x2,x3,y2,y3)+ ... +Det(xn,x1,yn,y1)],
			//where Det(a,b,c,d) = a*d-b*c.
			
			var i:int = 0; 
			var j:int = 0; 
			var k:int = 0;
			var l:int = 0;
			
			var n:int = vector.length; 
			var surf:Number = 0;
			
			for(i=0 ; i<n ; i+=2){ 
				j = (i+1) % n;
				k = (i+2) % n;
				l = (i+3) % n;
				
				surf += (vector[i] * vector[l]) - (vector[j] * vector[k]); 
			}
			
			surf = surf / 2;
			
			if (surf < 0) {
				surf = -surf;
			}
			
			return surf;
		}
		
		
		//****************** PUBLIC METHODS ****************** ****************** ******************
		
		/**
		 * 
		 * @param value
		 * @param phase
		 * 
		 */
		public function dim(value:Boolean, phase:String = "update"):void {
			
			_dimed = phase;
			
			switch (phase) {
				case "start":
					TweenMax.to(this,2 * Math.random(),{alpha:.1, delay:Math.random()});
					break;
				
				case "update":
					if (value) {
						//this.alpha = .1;
						TweenMax.to(this,.2,{alpha:.1, delay:Math.random()});
					} else {
						TweenMax.to(this,.5,{alpha:.6, delay:Math.random()});
					}
					break;
				
				case "end":
					TweenMax.to(this,2 * Math.random(),{alpha:.6, delay:1.2+Math.random()});
					break;
				
				case "out":
					TweenMax.to(this,2 * Math.random(),{alpha:0});
					break;
				
			}
		}
		
		
		//****************** EVENTS ****************** ****************** ******************
		
		/**
		 * Mouse Down. Set the action for mouse down.
		 * 
		 * @param event
		 * 
		 */
		protected function _mouseDown(event:MouseEvent):void {
			this.startDrag();
		}
		
		/**
		 * Mouse Up. Set the action for mouse up.
		 * 
		 * @param event
		 * 
		 */
		protected function _mouseUp(event:MouseEvent):void {
			this.stopDrag();
		}

		
	}
}