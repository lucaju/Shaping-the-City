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
	import view.MapView;
	
	[SWF(width="1280", height="752", backgroundColor="#ffffff", frameRate="30")]
	public class Main extends Sprite {	
		
		//properties
		private var dataModel:DataModel;
		//private var dataTreesModel:DataTreesModel;
		
		private var pipelineController:PipelineController
		private var pipelineView:MainView;
		
		private var background:Sprite 
		private var url:URLRequest;
		private var loaderimageLoader:Loader;
		
		private var mainView:MapView;
		
		private var settings:Settings;
		
		public function Main() {
			
			//settings
			settings = new Settings();
			trace (DeviceInfo.metrics());
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//background
			background = new Sprite();
			url = new URLRequest("images/new_background4.jpg");
			loaderimageLoader = new Loader();
			loaderimageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImage)
			loaderimageLoader.load(url);
			background.addChild(loaderimageLoader)
			background.alpha = .3;
			addChild(background);
			
			//Starting models
			//dataTreesModel = new DataTreesModel();
			dataModel = new DataModel();
			
			//starting controler
			pipelineController = new PipelineController([dataModel]);
			
			//Starting View
			pipelineView = new MainView(pipelineController);
			pipelineView.setModel(dataModel);
			addChild(pipelineView);
			pipelineView.init();
			
		}
		
		private function loadImage(e:Event):void {
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;	
		}
	}
}