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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const CREATED:String = "created";
		
		/**
		 * The NetConnectionFactoryEvent.CREATION_FAILED constant defines the value of the
		 * type property of the event object for a NetConnectionFactoryEvent when the 
		 * the class has failed at establishing a connected NetConnection.
		 * 
		 * @eventType CREATION_FAILED
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const CREATION_FAILED:String = "creationfailed";

		/**
		 * Constructor.
		 * 
		 * @param type Event type.
 		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
 		 * @param netConnection NetConnection to which this event refers.
 		 * @param loadable ILoadable to which this event refers.
 		 * @param shareable Specifies if this NetConnection may be shared between ILoadables.
		 **/
		public function NetConnectionFactoryEvent
			( type:String
			, bubbles:Boolean=false
			, cancelable:Boolean=false
			, netConnection:NetConnection=null
			, loadable:ILoadable=null
			, shareable:Boolean=false
			)
		{
			super(type, bubbles, cancelable);

			_netConnection = netConnection;
			_loadable = loadable;
			_shareable = shareable;
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
			return _netConnection;
		}

		/**
		 * ILoadable to which this event refers.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get loadable():ILoadable
		{
			return _loadable;
		}
		
		/**
		 * Specifies if this NetConnection may be shared between ILoadables.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get shareable():Boolean
		{
			return _shareable
		}
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new NetConnectionFactoryEvent(type, bubbles, cancelable, _netConnection, _loadable, shareable);
		}  
		
		private var _netConnection:NetConnection;
		private var _loadable:ILoadable;
		private var _shareable:Boolean;
	}
}