/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
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