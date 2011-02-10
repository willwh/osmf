package
{
	import flash.display.Sprite;
	import flexunit.flexui.FlexUnitTestRunnerUIAS;
	
	import org.flexunit.runner.Request;
	import org.osmf.media.videoClasses.TestStageVideoManager;
	
	public class OSMFStageVideoTest extends Sprite
	{
		public function OSMFStageVideoTest()
		{
			onCreationComplete();	
		}
		
		private function onCreationComplete():void
		{
			var testRunner:FlexUnitTestRunnerUIAS = new FlexUnitTestRunnerUIAS();
			this.addChild(testRunner); 
			
			testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "OSMFStageVideoTest");
		}
		
		public function currentRunTestSuite():Array
		{
			var testsToRun:Array = new Array();
			
			testsToRun.push(Request.methods(org.osmf.media.videoClasses.TestStageVideoManager,["testAddRemoveStageVideoAvailable"]));
			testsToRun.push(Request.methods(org.osmf.media.videoClasses.TestStageVideoManager,["testPositioning"]));
			testsToRun.push(Request.methods(org.osmf.media.videoClasses.TestStageVideoManager,["testSerialWorkflow"]));
			testsToRun.push(Request.methods(org.osmf.media.videoClasses.TestStageVideoManager,["testCompositeWorkflow"]));
			testsToRun.push(Request.methods(org.osmf.media.videoClasses.TestStageVideoManager,["testNotEnoughStageVideoObjests"]));
			
			return testsToRun;
		}
	}
}