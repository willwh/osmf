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
	
	import org.osmf.traits.ILoadable;
	
	/**
	 * A NetConnectionFactory dispatches this event when it has either succeeded or failed at
	 * establishing a NetConnection. 
	 */	
	public class NetConnectionFactoryEvent extends Event 
	{
		/**
		 * The NetConnectionFactoryEvent.CREATED constant defines the value of the
		 * type property of the event object for a NetConnectionFactoryEvent when the 
		 * the class has succeeded in establishing a connected NetConnection.
		 * 
		 * @eventType CREATED 
		 */	
		public static const CREATED:String = "created";
		
		/**
		 * The NetConnectionFactoryEvent.CREATION_FAILED constant defines the value of the
		 * type property of the event object for a NetConnectionFactoryEvent when the 
		 * the class has failed at establishing a connected NetConnection.
		 * 
		 * @eventType CREATION_FAILED
		 */
		public static const CREATION_FAILED:String = "creationfailed";

		/**
		 * Constructor.
		 * 
		 **/
		public function NetConnectionFactoryEvent(	type:String,
													netConnection:NetConnection = null,
													loadable:ILoadable = null,
													shareable:Boolean = false,
													bubbles:Boolean = false,
													cancelable:Boolean = false
													)
		{
			_netConnection = netConnection;
			_loadable = loadable;
			_shareable = shareable;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * ILoadable to which this event refers
		 */
		public function get loadable():ILoadable
		{
			return _loadable;
		}
		
		/**
		 * NetConnection to which this event refers
		 */
		public function get netConnection():NetConnection
		{
			return _netConnection
		}
		
		/**
		 * Specifies if this NetConnection may be shared between ILoadables.
		 */
		public function get shareable():Boolean
		{
			return _shareable
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new NetConnectionFactoryEvent(type,_netConnection,_loadable,bubbles,cancelable);
		}  
		
		private var _netConnection:NetConnection;
		private var _loadable:ILoadable;
		private var _shareable:Boolean;
	}
}