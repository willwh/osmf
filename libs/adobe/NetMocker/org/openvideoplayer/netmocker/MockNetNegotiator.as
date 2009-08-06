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
package org.openvideoplayer.netmocker
{
	import flash.net.NetConnection;
	
	import org.openvideoplayer.net.NetNegotiator;
	
	public class MockNetNegotiator extends NetNegotiator
	{
		public function MockNetNegotiator()
		{
			_netConnectionExpectation = NetConnectionExpectation.VALID_CONNECTION;
		}
		
		/**
		 * The client's expectation for how this object's NetConnection will
		 * behave after connect() is called.
		 **/ 
		public function set netConnectionExpectation(value:NetConnectionExpectation):void
		{
			this._netConnectionExpectation = value;
		}
		
		public function get netConnectionExpectation():NetConnectionExpectation
		{
			return _netConnectionExpectation;
		}
		
	    /**
	     * @inheritDoc
	     **/
	    override protected function createNetConnection():NetConnection
	    {
			var mockNetConnection:MockNetConnection = new MockNetConnection();
			if (netConnectionExpectation != null)
			{
				mockNetConnection.expectation = this.netConnectionExpectation;
			}
			return mockNetConnection;
			
	    }
	    
	    private var _netConnectionExpectation:NetConnectionExpectation;
	}
}