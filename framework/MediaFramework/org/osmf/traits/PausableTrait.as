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
package org.osmf.traits
{
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Dispatched when the trait's paused property has changed.
	 * 
	 * @eventType org.osmf.events.PausedChangeEvent.PAUSED_CHANGE
	 */
	[Event(name="pausedChange",type="org.osmf.events.PausedChangeEvent")]

	/**
	 * The PausableTrait class provides a base IPausable implementation. 
	 * It can be used as the base class for a more specific Pausable trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public class PausableTrait extends MediaTraitBase implements IPausable
	{
		// Public Interface
		//

		/**
		 * Constructor.
		 *
		 * @param owner The owning MediaElement of this trait.  Allows the
		 * trait to keep its own state in sync with the state of the
		 * PlayableTrait, and vice-versa.
		 * 
		 * @throws ArgumentError If owner is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function PausableTrait(owner:MediaElement)
		{
			if (owner == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			this.owner = owner;
		}
		
		/**
		 * Resets the <code>paused</code> property of the trait.
		 * Changes the value of <code>paused</code> from <code>true</code> to <code>false</code>.
		 * <p>Used after a call to <code>canProcessPausedChange(true)</code> returns
		 * <code>true</code>.</p>
		 * 
		 * @see #canProcessPausedChange()
		 * @see #processPausedChange()
		 * @see #postProcessPausedChange()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		
		// IPausable
		//
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get paused():Boolean
		{
			return _paused;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		final public function pause():void
		{
			var playable:PlayableTrait = owner.getTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
			
			if (	_paused == false
				 && 	(  playable == null
				 		|| playable.playing == true
				 		)
				 && canProcessPausedChange(true))
			{
				processPausedChange(true);
				
				if (playable != null)
				{
					// Keep the PlayableTrait (if any) in sync with this change.
					playable.resetPlaying();
				}

				_paused = true;
				
				postProcessPausedChange(false);
			}
		}
		
		// Internals
		//
		
		/**
		 * Called before the trait's <code>paused</code> property
		 * is updated by the <code>pause()</code> or <code>resetPaused()</code> method.
		 * 
		 * @param newPaused Proposed new <code>paused</code> value.
		 * @return Returns <code>false</code> to abort the change
		 * or <code>true</code> to proceed with processing. The default is <code>true</code>.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessPausedChange(oldPaused:Boolean):void
		{
			dispatchEvent(new PausedChangeEvent(!oldPaused));	
		}

		private var owner:MediaElement;
		private var _paused:Boolean;
	}
}