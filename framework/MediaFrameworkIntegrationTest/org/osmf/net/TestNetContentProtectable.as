package org.osmf.net
{
	import org.osmf.traits.TestContentProtectable;

	public class TestNetContentProtectable extends TestContentProtectable
	{
		public function TestNetContentProtectable()
		{
			super();
		}
		
		
		override protected function createInterfaceObject(... args):Object
		{			
			return new NetContentProtectableTrait();
		}
		
		protected function prodAuthNeeded():void
		{
			protectable.dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_NEEDED));
		}
		
		protected function prodAuthFailed():void
		{
			protectable.dispatchEvent(new AuthenticationFailedEvent(45, "Error"));
		}
		
		protected function prodAuthSuccess():void
		{
			protectable.dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_COMPLETE));
		}
		
		
	}
}