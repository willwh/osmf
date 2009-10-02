/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.events
{
	import flash.events.Event;
	
	import org.osmf.net.dynamicstreaming.SwitchingDetail;
	
	/**
	 * A trait that implements the ISwitchable interface dispatches
	 * this event when a switching change has occurred.
	 */		
	public class SwitchingChangeEvent extends TraitEvent
	{
		/**
		 * The SwitchingChangeEvent.SWITCHING_CHANGE constant defines the value
		 * of the type property of the event object for a switchingChange
		 * event.
		 * 
		 * @eventType SWITCHING_CHANGE  
		 */		
		public static const SWITCHING_CHANGE:String = "switchingChange";
		
		/**
		 * This means a switch request was made but is not
		 * complete and has not failed.
		 */
		public static const SWITCHSTATE_REQUESTED:int	= 1;
				
		/**
		 * This means the switch was completed and is visible to the 
		 * user.
		 */
		public static const SWITCHSTATE_COMPLETE:int	= 2;
		
		/**
		 * This means the switch request failed.  The current index remains unchanged.
		 */
		public static const SWITCHSTATE_FAILED:int		= 3;
		

		public static const SWITCHSTATE_UNDEFINED:int	= 0;
		
		/**
		 * Constructor
		 * 
		 * @param newState The new switching state, should be one of the contants defined in this class.
		 * @param oldState The previous switching state, should be one of the contents defined in this class.
		 * @param switchingDetail A SwitchingDetail object containing the details for the switching change.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
 		 * @param cancelable Specifies whether the behavior associated with the event can be prevented. 
 		 * 
		 */		
		public function SwitchingChangeEvent(newState:int, oldState:int=SWITCHSTATE_UNDEFINED, switchingDetail:SwitchingDetail=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(SWITCHING_CHANGE, bubbles, cancelable);
			_newState = newState;
			_oldState = oldState;
			_detail = switchingDetail;
		}
		
		/**
		 * The new switching state as specified in the constructor.
		 */
		public function get newState():int
		{
			return _newState;
		}
		
		/**
		 * The previous switching state as specified in the constructor.
		 */
		public function get oldState():int
		{
			return _oldState;
		}
		
		/**
		 * The SwitchingDetail specified in the constructor.
		 */
		public function get detail():SwitchingDetail
		{
			return _detail;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new SwitchingChangeEvent(_newState, _oldState, _detail);
		}
		
		
		private var _detail:SwitchingDetail;
		private var _newState:int;
		private var _oldState:int;		
	}
}
