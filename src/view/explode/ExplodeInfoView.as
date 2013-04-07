package view.explode {
	
	//imports
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import controller.PipelineController;
	
	import events.PipelineEvents;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	import view.tooltip.ToolTipManager;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	public class ExplodeInfoView extends AbstractView {
		
		//****************** Properties ****************** ******************  ****************** 
		
		static public var gap				:Number = 40;			//Gap between groups
		static public var groupWidth		:Number;				//Holds the maximum width of each group
		
		protected var _contentType			:String;				//Holds explosion content type
		
		protected var groups				:Array;					//Holds groups
		protected var explodeGroup			:ExplodeGroup;			//Group
		
		protected var toolTipManager		:ToolTipManager;
		
		//****************** Constructor ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param c
		 * 
		 */
		public function ExplodeInfoView(c:IController) {
			
			super(c);
			groups = new Array();
			
			//listener
			this.getController().getModel("DataModel").addEventListener(PipelineEvents.CHANGE, modelChange);
			
		}	
		
		//****************** GETTERS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get contentType():String {
			return _contentType;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get numGroups():int {
			return groups.length;
		}
		
		//****************** SETTERS ****************** ******************  ****************** 

		/**
		 * 
		 * @param value
		 * 
		 */
		public function set contentType(value:String):void {
			_contentType = value;
		}

		
		//****************** INITIALIZE ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function init():void {
			
			this.addEventListener(MouseEvent.CLICK, groupClick);
		}
		
		/**
		 * 
		 * @param content
		 * 
		 */
		public function addBulk():void {
			
			//get info
			var highlightedContentType:String = PipelineController(this.getController()).getHighlightedContentType();
				
			contentType = highlightedContentType;
				
			var content:Array = PipelineController(this.getController()).getHighlightedContent(contentType);
			
			
			//set group Max Width based on the nuber of groups to add
			groupWidth = (stage.stageWidth - ((content.length-1) * gap)) / content.length;
			
			//add groups
			for each (var title:String in content) {
				
				//get info
				var info:Object = new Object();
				info.contentType = contentType;
				
				switch (contentType.toLowerCase()) {
					case "community":
						info.title = title;
						info.meta = PipelineController(this.getController()).getNeighbourhoodByName(title);
						break;
					
					case "period":
						info.title = title;
						
						var start:int;
						var end:int;
						
						var pArr:Array = title.split(" - ");
						start = pArr[0];
						end = pArr[1];
						
						info.meta = PipelineController(this.getController()).getNeighbourhoodsByPeriod(start,end);
						break;
					
				}
				
				//create group
				explodeGroup = ExplodeGroupFactory.addExplodeGroup();
				groups.push(explodeGroup);
				
				explodeGroup.maxWidth = groupWidth;
				explodeGroup.init(title, info);
				
				this.addChild(explodeGroup);
				
			}
			
			//organize
			organize();
			
			//listener
			this.getController().getModel("DataModel").addEventListener(PipelineEvents.CHANGE, modelChange);
			
			//Dispatch event
			var data:Object = {};
			data.source = content;
			data.action = "addBulk";
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.SELECT, data));
		}
		
		
		//****************** PROTECTED METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param title
		 * 
		 */
		protected function addGroup(title:String):void {
			
			//get info
			var info:Object = new Object();
			info.contentType = contentType;
			
			switch (contentType.toLowerCase()) {
				case "community":
					info.title = title;
					info.meta = PipelineController(this.getController()).getNeighbourhoodByName(title);
					break;
				
				case "period":
					info.title = title;
					
					var start:int;
					var end:int;
					
					var pArr:Array = title.split(" - ");
					start = pArr[0];
					end = pArr[1];
					
					info.meta = PipelineController(this.getController()).getNeighbourhoodsByPeriod(start,end);
					break;
				
			}
			
			//add group
			explodeGroup = ExplodeGroupFactory.addExplodeGroup();
			groups.push(explodeGroup);
			
			explodeGroup.maxWidth = groupWidth;
			explodeGroup.init(title, info);
			
			this.addChild(explodeGroup);
			
			//organize
			organize();
			
			//Dispatch event
			var data:Object = {};
			data.source = title;
			data.action = "add";
			
			this.dispatchEvent(new PipelineEvents(PipelineEvents.SELECT, data));
		}
		
		/**
		 * 
		 * @param title
		 * 
		 */
		protected function removeGroup(title:String):void {
			
			//event data
			var data:Object = {};
			data.source = title;
			data.action = "remove";
			
			//Find group to remove
			for each (explodeGroup in groups) {
				if (explodeGroup.title == title) {
					TweenMax.to(explodeGroup, .5, {y: -30, alpha:0, onComplete:killGroup, onCompleteParams:[explodeGroup]});
					groups.splice(groups.indexOf(explodeGroup),1);
					break;	
				}
			}
			
			//Organize if still have groups, otherwise clear. 
			if (numGroups != 0) {
				organize();
			} else {
				clear();
				data.action = "removeAll";
			}
			
			//Dispatch event
			this.dispatchEvent(new PipelineEvents(PipelineEvents.SELECT, data));
		}
		
		/**
		 * 
		 * 
		 */
		protected function organize():void {
			
			//recalculating max width
			groupWidth = (stage.stageWidth - ((groups.length-1) * gap)) / groups.length;
				
			var i:int = 0;
			
			for each (explodeGroup in groups) {
				
				explodeGroup.maxWidth = groupWidth;
				
				
				//add or remove separator. Separator stands at the right side. So, the last on the lis does not have separator.
				if (groups.indexOf(explodeGroup) != groups.length-1) {
					explodeGroup.addSeparator();
				} else {
					explodeGroup.removeSeparator();
				}
				
				//organize inside the group
				explodeGroup.organize();
				
				TweenMax.to(explodeGroup, .5, {x: (groupWidth * i) + (gap * i)});
				
				i++;
			}
			
			
		}
		
		//****************** PUBLIC METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * 
		 */
		public function clear(method:String = ""):void {
			
			//remove all groups
			for each (explodeGroup in groups) {
				TweenMax.to(explodeGroup, .5, {y: -30, alpha:0, onComplete:killGroup, onCompleteParams:[explodeGroup]});
			}
			
			//empty array
			groups = [];
			
			//stop listening
			if (method == "all") {
				this.getController().getModel("DataModel").removeEventListener(PipelineEvents.CHANGE, modelChange);
			}
		}
		
		//****************** EVENTS ****************** ******************  ******************
		
		protected function modelChange(event:PipelineEvents):void {
			
		//	if (numGroups == 0) {
				
			//	trace ("oi")
				//init();
								
			//} else {
				
				switch(event.parameters.action) {
					case "add":
						
						var highlightedContentType:String = PipelineController(this.getController()).getHighlightedContentType();
						if (highlightedContentType != contentType) {
							clear();
							contentType = highlightedContentType;
						}
						
						addGroup(event.parameters.source);
						break
					
					case "remove":
						removeGroup(event.parameters.source);
						break;
				}
			//}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function groupClick(event:MouseEvent):void {
			//add tooltip	
			
			if (event.target.parent is ExplodeGroup) {
				
				var group:ExplodeGroup = event.target.parent as ExplodeGroup;
				
				if (group.metaData) {
				
					var targetLocation:Point = group.parent.localToGlobal(new Point(group.x + group.titleRect.x, group.titleRect.y));
					
					var groupInfo:Object = new Object();
					groupInfo.position = new Point(targetLocation.x, targetLocation.y)
					groupInfo.dimension = new Point(group.titleRect.width,group.titleRect.height);
					groupInfo.info = group.metaData;
					
					//add tooltip	
					ToolTipManager.addToolTip(groupInfo,"top");
					
					event.stopPropagation();
					
					groupInfo = null;
					targetLocation = null;
				}
				
				group = null;
			}
			
		}	
		
		
		//****************** PRIVATE METHODS ****************** ******************  ****************** 
		
		/**
		 * 
		 * @param obj
		 * 
		 */
		private function killGroup(obj:ExplodeGroup):void {
			this.removeChild(obj);
		}
		
	}
}