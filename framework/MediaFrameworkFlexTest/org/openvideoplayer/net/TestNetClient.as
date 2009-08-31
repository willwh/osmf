/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.openvideoplayer.net
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.net.NetClient;

	public class TestNetClient extends TestCase
	{
		public function testCallProperty():void
		{
			var client:NetClient = new NetClient();
			var eventName:String = "onEvent";
			var sentinel:String = "12345TestSentinel";
			var myFuncCalled:Boolean = false;
			
			function myFunc(testVal:String):void
			{
				assertEquals(testVal, sentinel);
				myFuncCalled = true;
			}
			
			var func:Function = client.onEvent;
			
			assertNull(func);
			assertFalse(myFuncCalled);
			
			client.addHandler("onEvent", myFunc);
			
			client.onEvent(sentinel);
						
			assertTrue(myFuncCalled);						
		}
		
		public function testAddHandler():void
		{
			var client:NetClient = new NetClient();
			var eventName:String = "onEvent";
			var sentinel:String = "12345TestSentinel";
			var myFuncCalled:Boolean = false;
			
			function myFunc(testVal:String):void
			{
				assertEquals(testVal, sentinel);
				myFuncCalled = true;
			}
			
			var func:Function = client.onEvent;
			
			assertNull(func);
			assertFalse(myFuncCalled);
			
			client.addHandler("onEvent", myFunc);
			
			func = client.onEvent;
			func.apply(this, [sentinel]);
			
			assertNotNull(func);
			assertTrue(myFuncCalled);					
		}
		
		public function testRemoveHandler():void
		{
			var client:NetClient = new NetClient();
			var eventName:String = "onEvent";
			var sentinel:String = "12345TestSentinel";
			var myFuncCalled:Boolean = false;
			
			function myFunc(testVal:String):void
			{
				assertEquals(testVal, sentinel);
				myFuncCalled = true;
			}
			
			var func:Function = client.onEvent;
			
			assertNull(func);
			assertFalse(myFuncCalled);
			
			client.addHandler("onEvent", myFunc);
			client.removeHandler("onEvent", myFunc);
			
			func = client.onEvent;
			func.apply(this, [sentinel]);
			
			//The function will exist for the lifetime of the netclient, once the register is called for the first time.
			assertNotNull(func);
			//However nothing should have been called due to the unregister call.
			assertFalse(myFuncCalled);					
		}
		
		public function testMultipleListeners():void
		{
			var client:NetClient = new NetClient();
			var eventName:String = "onEvent";
			var sentinel:String = "12345TestSentinel";
			var myFuncCalled:Boolean = false;
			var myFunc2Called:Boolean = false;
			
			function myFunc(testVal:String):void
			{
				assertEquals(testVal, sentinel);
				myFuncCalled = true;
			}
			
			function myFunc2(testVal:String):void
			{
				assertEquals(testVal, sentinel);
				myFunc2Called = true;
			}
			
			client.addHandler("onEvent", myFunc);
			client.addHandler("onEvent", myFunc2);
			
			var func:Function = client.onEvent;
			
			assertNotNull(func);
			
			func.apply(this, [sentinel]);
			
			assertTrue(myFuncCalled);		
			assertTrue(myFunc2Called);					
			
		}
		
	}
}