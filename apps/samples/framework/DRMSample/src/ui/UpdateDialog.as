package ui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	public class UpdateDialog extends UpdateDialogLayout
	{
		public function UpdateDialog()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onComplete);
		}
		
		protected function onComplete(event:Event):void
		{
			PopUpManager.centerPopUp(this);
		}
		
		override protected function childrenCreated():void
		{
			cancel.addEventListener(MouseEvent.CLICK, onCancel);
		}
		
		private function onCancel(event:Event):void
		{
			PopUpManager.removePopUp(this);
		}
		
	}
}