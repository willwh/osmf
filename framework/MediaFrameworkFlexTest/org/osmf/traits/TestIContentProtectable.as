package org.osmf.traits
{
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	import org.osmf.events.AuthenticationCompleteEvent;
	import org.osmf.events.AuthenticationFailedEvent;
	import org.osmf.events.TraitEvent;
	import org.osmf.utils.InterfaceTestCase;

	public class TestIContentProtectable extends InterfaceTestCase
	{
		public function TestIContentProtectable()
		{
			super();
		}
		
		override public function setUp():void
		{
			super.setUp();			
			events = [];
			protectable = super.interfaceObj as IContentProtectable;		
		}
		
		public function testNeedsAuthentication():void
		{
			protectable.addEventListener(TraitEvent.AUTHENTICATION_NEEDED, eventCatcher);
			prodAuthNeeded()
			assertEquals(events.length, 1);						
		}  
		
		public function testAuthenticationFailed():void
		{
			protectable.addEventListener(AuthenticationFailedEvent.AUTHENTICATION_FAILED, eventCatcher);
			prodAuthFailed();
			assertEquals(events.length, 1);						
		}
		
		public function testAuthenticationSuccess():void
		{
			protectable.addEventListener(AuthenticationCompleteEvent.AUTHENTICATION_COMPLETE, eventCatcher);
			prodAuthSuccess();
			assertEquals(events.length, 1);						
		}   
		
		public function testAuthenticationSuccessToken():void
		{
			protectable.addEventListener(AuthenticationCompleteEvent.AUTHENTICATION_COMPLETE, eventCatcher);
			prodAuthSuccessToken();
			assertEquals(events.length, 1);						
		}   	
		
		public function testDates():void
		{			
			Assert.assertEquals(NaN, protectable.period);
			Assert.assertNull(protectable.startDate);
			Assert.assertNull(protectable.endDate);
		}
			
							
		protected function eventCatcher(event:Event):void
		{
			events.push(event);
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
			protectable.dispatchEvent(new AuthenticationCompleteEvent(null));
		}
		
		protected function prodAuthSuccessToken():void
		{
			protectable.dispatchEvent(new AuthenticationCompleteEvent(null));
		}
		
		protected var events:Array;
		protected var protectable:IContentProtectable;
		
	}
}