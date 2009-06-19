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