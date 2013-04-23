package view.explode {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import model.Neighbourhood;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ExplodeGroup extends Sprite {
		
		//****************** Properties ****************** ******************  ****************** 
		
		protected var _maxWidth					:Number;						//Max width area.
		protected var _separatorCaliber			:int = 2;						//Separator caliber
		
		protected var titleTF					:TextField;
		protected var infoTF					:TextField;
		protected var titleStyle				:TextFormat;
		protected var infoStyle					:TextFormat;
		protected var separator					:Sprite;
		protected var bg						:Sprite;
		
		protected var _groupMetaData			:String;
		
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function ExplodeGroup() {
			
			titleStyle = new TextFormat();
			titleStyle.font = "Myriad Pro";
			titleStyle.size = 20;
			titleStyle.color = 0x666666;
			titleStyle.align = "center";
			
			infoStyle = new TextFormat();
			infoStyle.font = "Myriad Pro";
			infoStyle.size = 13;
			infoStyle.color = 0x666666;
			infoStyle.align = "center";
			infoStyle.leading = 1.7;
			
			titleTF = new TextField();
			titleTF.selectable = false;
			titleTF.mouseEnabled = false;
			titleTF.autoSize = "left";
			
			infoTF = new TextField();
			infoTF.selectable = false;
			infoTF.mouseEnabled = false;
			infoTF.autoSize = "left";
			infoTF.multiline = true;
			infoTF.wordWrap = true;
			
			bg = new Sprite();
			bg.buttonMode = true;
			bg.mouseChildren = false;
		}
		
		
		//****************** INITIALIZE ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param titleString
		 * 
		 */
		public function init(titleString:String, data:Object = null):void {
			//title
			titleTF.text = titleString;
			titleTF.setTextFormat(titleStyle);
			bg.addChild(titleTF);
			
			//bg
			bg.graphics.beginFill(0x999999,.1);
			bg.graphics.drawRect(0,0,titleTF.width + 4,titleTF.height);
			bg.graphics.endFill();
			this.addChild(bg);
			
			titleTF.x = (bg.width/2) - (titleTF.width/2);		//Text at the center
			titleTF.y = (bg.height/2) - (titleTF.height/2);		//Text at the center
			
			bg.x = (maxWidth/2) - (bg.width/2);					//bg at the center
			
			
			if (data) {
				
				var neighbourhood:Neighbourhood;
				var year:String;
				var totalShapes:int = 0;
				
				switch (data.contentType.toLowerCase()) {
					
					case "community":
						
						//info
						neighbourhood = data.meta as Neighbourhood;
						
						year = neighbourhood.period.toString();
						if (year == "0") year = "--";
						
						totalShapes = neighbourhood.shapes.length;
						
						infoTF.htmlText = "Year: <b>" + year + "</b><br>" +"Shapes: <b>" + totalShapes + "</b>";
						
						break;
					
					case "period":
						
						var neighbourhoods:String = "";
						
						
						for each (neighbourhood in data.meta) {
						
						//info
						year = neighbourhood.period.toString();
						if (year == "0") year = "--"
						
						totalShapes += neighbourhood.shapes.length;
						
						neighbourhoods +=  neighbourhood.name + " (" + year + "): <b>" + neighbourhood.shapes.length + "</b> shapes";
						
						if (data.meta.indexOf(neighbourhoods) != data.meta.length) {
							neighbourhoods += "<br />"
						}
						
					}
						
						//save info
						groupMetaData = "Communities:<br/>" + neighbourhoods;
						
						//print info
						if (data.meta.length == 1) {
							infoTF.htmlText = "Community: <b> " + data.meta.length + " </b><br/>Shapes: <b>" + totalShapes + "</b>";
						} else {
							infoTF.htmlText = "Communities: <b> " + data.meta.length + " </b><br/>Shapes: <b>" + totalShapes + "</b>";
						}
						
						
						
						break;
				}
				
				infoTF.setTextFormat(infoStyle);
				infoTF.y = titleTF.height;
				this.addChild(infoTF);
				
				infoTF.x = (maxWidth/2) - (infoTF.width/2)					//Text at the center
			}
			
		}
		
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get groupMetaData():String {
			return _groupMetaData;
		}

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get maxWidth():Number {
			return _maxWidth;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get title():String {
			return titleTF.text;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get titleRect():Rectangle {
			var rect:Rectangle = new Rectangle();
			
			rect.x = bg.x;
			rect.y = bg.y;
			rect.width = bg.width;
			rect.height = bg.height;
			
			return rect;
		}
		
		//****************** SETTERS ****************** ******************  ****************** 

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set groupMetaData(value:String):void {
			_groupMetaData = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set maxWidth(value:Number):void {
			_maxWidth = value;
		}
		
		/**
		 * titleSize. Set font size. 
		 * @param value:uint
		 * 
		 */
		public function set titleSize(value:uint):void {
			titleStyle.size = value;
		}
		
		/**
		 * Set Separator Caliber. 
		 * @param value:uint
		 * 
		 */
		public function set separatorCaliber(value:uint):void {
			_separatorCaliber = value;
		}
		
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function addSeparator():Boolean {
			
			if (!separator) {
				separator =  new Sprite;
				
				separator.graphics.lineStyle(_separatorCaliber,0x333333,.3);
				separator.graphics.beginFill(0xFFFFFF,1);
				separator.graphics.lineTo(0,620);
				separator.graphics.endFill();
				
				separator.x = _maxWidth + (ExplodeInfoView.gap/2);			//position at the right margin
				
				this.addChild(separator);
				
				TweenMax.from(separator,1,{alpha:0,scaleY:0,delay:1});
				
				return true;
			}
			
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function removeSeparator():Boolean {
			
			if (separator) {
				this.removeChild(separator);
				separator = null;
				
				return true;
			}
			
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		public function organize():void {
			TweenMax.to(bg, .5, {x: (maxWidth/2) - (titleTF.width/2)});						//Text in the center
			
			if (infoTF) {
				infoTF.width = maxWidth;
				TweenMax.to(infoTF, .5, {x: (maxWidth/2) - (infoTF.width/2)});				//Text in the center
			}
			if (separator) TweenMax.to(separator, .5, {x: _maxWidth + (ExplodeInfoView.gap/2)});	//Separator on the right margin
		}
		
		
	}
}