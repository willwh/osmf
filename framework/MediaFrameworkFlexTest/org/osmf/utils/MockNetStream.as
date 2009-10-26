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
package org.osmf.utils
{
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class MockNetStream extends NetStream
	{
		public function MockNetStream(connection:NetConnection)
		{
			super(connection);
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}

		override public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}	
		
		override public function get bytesTotal():uint
		{
			return _bytesTotal;
		}
		
		public function set bytesLoaded(value:uint):void
		{
			_bytesLoaded = value;
		}	
		
		public function set bytesTotal(value:uint):void
		{
			_bytesTotal = value;
		}
		
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
	}
}