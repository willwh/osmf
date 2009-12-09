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
*  Contributor(s): Akamai Technologies
*  
*****************************************************/

package org.osmf.events
{
	import flash.events.Event;
	import flash.net.NetConnection;
	
	/**
	 * A NetNegotiator dispatches this event when it has either succeeded or failed at
	 * negotiating a connected NetConnection. 
	 */	
	public class NetNegotiatorEvent extends Event
	{
		/**
		 * The NetNegotiatorEvent.CONNECTED constant defines the value of the
		 * type property of the event object for a NetNegotiatorEvent when the 
		 * the class has succeeded in negotiating a connected NetConnection.
		 * 
		 * @eventType CONNECTED
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const CONNECTED:String = "connected";
		
		/**
		 * The NetNegotiatorEvent.CONNECTION_FAILED constant defines the value of the
		 * type property of the event object for a NetNegotiatorEvent when the 
		 * the class has failed at negotiating a connected NetConnection. The specific reason for
		 * the failure is captured in the constructor mediaError argument, which is captured by the 
		 * NetConnectionFactory and dispatched as a mewdiaErrorEvent against the appropriate ILoadable.
		 * 
		 * @eventType CONNECTION_FAILED
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const CONNECTION_FAILED:String = "connectionfailed";

		/**
		 * Constructor.
		 *  
		 * @param type Event type.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
 		 * @param netConnection NetConnection to which this event refers.
 		 * @param mediaError A MediaError associated with this event.
		 **/
		public function NetNegotiatorEvent
			( type:String
			, bubbles:Boolean=false
			, cancelable:Boolean=false
			, netConnection:NetConnection=null
			, mediaError:MediaError=null
			)
		{
			super(type, bubbles, cancelable);

			_netConnection = netConnection;
			_mediaError = mediaError;
		}
		
		/**
		 * NetConnection to which this event refers.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get netConnection():NetConnection
		{
			return _netConnection
		}
		
		/**
		 * A MediaError associated with this event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get mediaError():MediaError
		{
			return _mediaError
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new NetNegotiatorEvent(type, bubbles, cancelable, _netConnection, _mediaError);
		}  
		
		private var _netConnection:NetConnection;
		private var _mediaError:MediaError;
	}
}