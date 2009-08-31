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

package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.SwitchingChangeEvent;
	import org.openvideoplayer.net.dynamicstreaming.SwitchingDetail;
	
	/**
	 * Dispatched when a stream switch is requested, completed, or failed.
	 * 
	 * @eventType org.openvideoplayer.events.SwitchingChangeEvent
	 */
	[Event(name="switchingChange",type="org.openvideoplayer.events.SwitchingChangeEvent")]
		
	/**
	 * The SwitchableTrait class provides a base ISwitchable implementation.
	 * It can be used as the base class for a more specific Switchable trait
	 * subclass.
	 */	
	public class SwitchableTrait extends MediaTraitBase implements ISwitchable
	{
		public function SwitchableTrait()
		{
			super();
			_newState = _oldState = SwitchingChangeEvent.SWITCHSTATE_UNDEFINED;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoSwitch():Boolean
		{
			return true;
		}
		
		public function set autoSwitch(value:Boolean):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentIndex():int
		{
			return -1;
		}
			
		/**
		 * @inheritDoc
		 */	
		public function get maxIndex():int
		{
			return -1;
		}
		
		public function set maxIndex(value:int):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function get switchUnderway():Boolean
		{
			return false;
		}
				
		public function switchTo(index:int):void
		{
		}
		
		/**
		 * A handy utility method for classes extending this class. Keeps track of
		 * the last state and dispatches a SwitchingChangeEvent containing the new state
		 * and the old state.
		 */
		protected function updateSwitchState(newState:int, detail:SwitchingDetail=null):void
		{
			_oldState = _newState;
			_newState = newState;
			dispatchEvent(new SwitchingChangeEvent(_newState, _oldState, detail));
		}
		
		private var _newState:int;
		private var _oldState:int;
		
	}
}
