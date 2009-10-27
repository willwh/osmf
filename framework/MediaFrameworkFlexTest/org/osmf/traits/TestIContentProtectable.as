package org.osmf.traits
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
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
			protectable.addEventListener(TraitEvent.AUTHENTICATION_COMPLETE, eventCatcher);
			prodAuthSuccess();
			assertEquals(events.length, 1);						
		}   
		
		public function testAuthenticationSuccessToken():void
		{
			protectable.addEventListener(TraitEvent.AUTHENTICATION_COMPLETE, eventCatcher);
			protectable.authenticate("test","test");
			prodAuthSuccess();
			assertEquals(events.length, 1);						
		}   	
		
		public function testDates():void
		{			
			Assert.assertEquals(-1, protectable.period);
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
			protectable.dispatchEvent(new TraitEvent(TraitEvent.AUTHENTICATION_COMPLETE));
		}
		
		protected var events:Array;
		protected var protectable:IContentProtectable;
		
	}
}