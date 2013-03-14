package view {
	
	//imports
	import flash.geom.Point;
	
	//import controller.PipelineController;
	
	import events.PipelineEvents;
	
	//import model.DataTreesModel;
	//import model.TreeModel;
	
	import mvc.AbstractView;
	import mvc.IController;
	
	public class TreesView extends AbstractView {
		
		//properties
		private var treeCollection:Array;
		private var proportion:Object;
		private var tree:Tree;
		
		public function TreesView(c:IController) {
			
			super(c);
		}
		
		public function init():void {
			
			//get model through controlles
			//var m:DataTreesModel = DataTreesModel(PipelineController(this.getController()).getModel("trees"));
			
			//--------- Load editions		
			//PipelineController(this.getController()).loadTrees();
			
			//add listeners
			//m.addEventListener(PipelineEvents.COMPLETE, _complete);
			
			
			
		}
		
		protected function _complete(e:PipelineEvents):void {
			
			//proportion = PipelineController(this.getController()).getTreePropportions();
			
			//get data
			var trees:Array = e.parameters.data;
			
			//init
			treeCollection = new Array();
			
			var origin:Point = proportion.origin;
			var scale:Number = proportion.rate;
			
			var i:int = 0;
			
			/*
			for each (var treeModel:TreeModel in trees) {
				
				tree = new Tree(treeModel.id, treeModel.location);
				tree.x = (tree.location.x - origin.x) * scale;
				tree.y = (tree.location.y - origin.y) * scale;
				
				tree.diameter = treeModel.diameter;
				tree.condition = treeModel.condition;
				
				tree.init();
				
				this.addChild(tree);
				
				treeCollection.push(tree);
				
				
				i++;
				trace (tree.x, tree.y)
				
				//TweenMax.from(tree,.1,{alpha:0, delay:(i*0.01) + 32});
			}
			*/
			
			//trace ("i: " +i)
		}
		
		public function setProportion(value:Object):void {
			proportion = value;
		}
		
		public function getShapes():Array {
			return treeCollection.concat();
		}
	}
}