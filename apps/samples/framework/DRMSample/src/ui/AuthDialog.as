package ui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import org.osmf.events.AuthenticationFailedEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.traits.IContentProtectable;
	
	public class AuthDialog extends AuthDialogLayout
	{
		public var trait:IContentProtectable;
		
		public function AuthDialog()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:Event):void
		{
			PopUpManager.centerPopUp(this);	
		}
		
		override protected function childrenCreated():void
		{
			authenticate.addEventListener(MouseEvent.CLICK, attemptAuth);
			cancel.addEventListener(MouseEvent.CLICK, closeDialog);
			
		}
		
		private function closeDialog(event:Event):void
		{
			PopUpManager.removePopUp(this);
		}
		
		private function authFailed(event:AuthenticationFailedEvent):void
		{
			Alert.show(event.detail + " Code: " + event.errorID, "Auth failed"); 
		}
		
		private function attemptAuth(event:MouseEvent):void
		{
			trait.addEventListener(TraitEvent.AUTHENTICATION_COMPLETE, closeDialog);
			trait.addEventListener(AuthenticationFailedEvent.AUTHENTICATION_FAILED, authFailed);
			trait.authenticate(username.text, password.text);
		}
		
	}
}