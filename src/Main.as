package {
	
	//imports
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import controller.PipelineController;
	
	import model.DataModel;
	
	import util.DeviceInfo;
	
	import view.MainView;
	
	/**
	 * 
	 * @author lucaju
	 * 
	 */
	[SWF(width="1280", height="752", backgroundColor="#ffffff", frameRate="30")]
	public class Main extends Sprite {	
		
		//****************** Properties ****************** ****************** ****************** 
		private var dataModel						:DataModel;
		private var pipelineController				:PipelineController
		private var mainView						:MainView;
		
		private var settings						:Settings;
		
		//private var dataTreesModel:DataTreesModel;
		
		
		//****************** Constructor ****************** ****************** ****************** 
		
		public function Main() {
			
			//settings
			settings = new Settings();
			
			//align
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//Models
			dataModel = new DataModel();
			
			//Controler
			pipelineController = new PipelineController([dataModel]);
			
			//View
			mainView = new MainView(pipelineController);
			mainView.setModel(dataModel);
			addChild(mainView);
			mainView.init();
			
			//background
			var background:Sprite = new Sprite();
			this.addChildAt(background,0);
			
			var loaderimageLoader:Loader = new Loader();
			
			loaderimageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImage)
			loaderimageLoader.load(new URLRequest("images/background2.png"));
			background.addChild(loaderimageLoader);
			
			//trace
			trace (DeviceInfo.metrics());
		}
		
		
		//****************** PRIVATE METHODS ****************** ****************** ****************** 
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function loadImage(event:Event):void {
			event.target.content.width = stage.stageWidth;
			event.target.content.height = stage.stageHeight;	
		}
	}
}