package org.osmf.traits
{
	import org.osmf.events.AuthenticationCompleteEvent;
	import org.osmf.events.AuthenticationFailedEvent;
	
	public class TestContentProtectable extends TestIContentProtectable
	{
		public function TestContentProtectable()
		{
			super();
		}
		
		override protected function createInterfaceObject(... args):Object
		{			
			return new ContentProtectableTrait();
		}
		
		public function testAuthMethod():void
		{
			assertNull(protectable.authenticationMethod);
		}
		
		override protected function prodAuthFailed():void
		{
			protectable.authenticate("test","test");
			protectable.dispatchEvent(new AuthenticationFailedEvent(45, "Error"));
		}
		
		override protected function prodAuthSuccess():void
		{
			protectable.authenticate("test","test");
			protectable.dispatchEvent(new AuthenticationCompleteEvent(null));
		}
		
		override protected function prodAuthSuccessToken():void
		{
			protectable.authenticateWithToken("testtest");
			protectable.dispatchEvent(new AuthenticationCompleteEvent(null));
		}
		
		
	}
}