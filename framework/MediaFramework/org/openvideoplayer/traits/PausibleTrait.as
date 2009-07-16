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
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.PausedChangeEvent;

	/**
	 * Dispatched when the trait's paused property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.PausedChangeEvent.PAUSED_CHANGE
	 */
	[Event(name="pausedChange",type="org.openvideoplayer.events.PausedChangeEvent")]

	/**
	 * The PausibleTrait class provides a base IPausible implementation. 
	 * It can be used as the base class for a more specific pausible trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 */	
	public class PausibleTrait extends MediaTraitBase implements IPausible
	{
		// Public Interface
		//
		
		/**
		 * Resets the <code>paused</code> property of the trait.
		 * Changes the value of <code>paused</code> from <code>true</code> to <code>false</code>.
		 * <p>Used after a call to <code>canProcessPausedChange(true)</code> returns
		 * <code>true</code>.</p>
		 * 
		 * @see #canProcessPausedChange()
		 * @see #processPausedChange()
		 * @see #postProcessPausedChange()
		 */		
		final public function resetPaused():void
		{
			if (_paused == true && canProcessPausedChange(false))
			{
				processPausedChange(false);
				
				_paused = false;
				
				postProcessPausedChange(true);
			}
		}
		
		// IPausible
		//
		
		/**
		 * @inheritDoc
		 */		
		public function get paused():Boolean
		{
			return _paused;
		}
		
		/**
		 * @inheritDoc
		 */		
		final public function pause():void
		{
			if (_paused == false && canProcessPausedChange(true))
			{
				processPausedChange(true);
				
				_paused = true;
				
				postProcessPausedChange(false);
			}
		}
		
		// Internals
		//
		
		private var _paused:Boolean;
		
		/**
		 * Called before the trait's <code>paused</code> property
		 * is updated by the <code>pause()</code> or <code>resetPaused()</code> method.
		 * 
		 * @param newPaused Proposed new <code>paused</code> value.
		 * @return Returns <code>false</code> to abort the change
		 * or <code>true</code> to proceed with processing. The default is <code>true</code>.
		 * 
		 */		
		protected function canProcessPausedChange(newPaused:Boolean):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>paused</code> value is changed.
		 * 
		 * <p>Subclasses implement this method to communicate the change to the media being paused or reset.</p>
		 * 
		 * @param newPaused New <code>paused</code> value.
		 */		
		protected function processPausedChange(newPaused:Boolean):void
		{
		}
		
		/**
		 * Called just after the trait's <code>paused</code> value has changed.
		 * 
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the pausedChanged event.</p>
		 * @param oldPaused Previous <code>paused</code> value.
		 */		
		protected function postProcessPausedChange(oldPaused:Boolean):void
		{
			dispatchEvent(new PausedChangeEvent(!oldPaused));	
		}
		
	}
}