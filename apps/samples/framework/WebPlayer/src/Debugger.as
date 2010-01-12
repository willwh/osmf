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

package
{
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	import org.osmf.media.MediaElement;
	
	public class Debugger
	{
		public function Debugger(instanceId:String)
		{
			this.instanceId = instanceId;
				
			sender = new LocalConnection();
			sender.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			sender.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			sender.addEventListener(StatusEvent.STATUS, onStatus);
			
			send("debugger instance constructed", instanceId);
		}
		
		public function send(...parameters):void
		{
			parameters.unshift(new Date());
			parameters.unshift(instanceId);
			parameters.unshift("debug");
			parameters.unshift(SENDER_NAME);
			sender.send.apply(this, parameters);
		}

		// Internals
		//
		
		private var sender:LocalConnection;
		private var instanceId:String;
		
		private static const SENDER_NAME:String = "_OSMFWebPlayerDebugger";
		
		private function onAsyncError(event:AsyncErrorEvent):void
		{
			
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			
		}
		
		private function onStatus(event:StatusEvent):void
		{
			trace(event.code);
		}
	}
}