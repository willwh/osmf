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
	import org.osmf.events.MutedChangeEvent;
	import org.osmf.events.PanChangeEvent;
	import org.osmf.events.VolumeChangeEvent;
	
	/**
	 * Dispatched when the trait's <code>volume</code> property has changed.
	 * 
	 * @eventType org.osmf.events.VolumeChangeEvent.VOLUME_CHANGE
	 */	
	[Event(name="volumeChange",type="org.osmf.events.VolumeChangeEvent")]
	
	/**
  	 * Dispatched when the trait's <code>muted</code> property has changed.
  	 * 
  	 * @eventType org.osmf.events.MutedChangeEvent.MUTED_CHANGE
	 */	
	[Event(name="mutedChange",type="org.osmf.events.MutedChangeEvent")]
	
	/**
 	 * Dispatched when the trait's <code>pan</code> property has changed.
 	 * 
 	 * @eventType org.osmf.events.PanChangeEvent.PAN_CHANGE 
	 */	
	[Event(name="panChange",type="org.osmf.events.PanChangeEvent")]
	
	/**
	 * The AudibleTrait class provides a base IAudible implementation.
	 * It can be used as the base class for a more specific audible trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 */	
	public class AudibleTrait extends MediaTraitBase implements IAudible
	{
		// IAudible
		//
		
		/**
		 * @inheritDoc
		 */		
		public function get volume():Number
		{
			return _volume;
		}
		
		/**
		 * @inheritDoc
		 */		
		final public function set volume(value:Number):void
		{
			// Coerce the value into our range:
			if (isNaN(value))
			{
				value = 0;
			}
			else if (value > 1)
			{
				value = 1;
			}
			else if (value < 0)
			{
				value = 0;
			}
			
			if (value != _volume)
			{
				if (canProcessVolumeChange(value))
				{
					processVolumeChange(value);
					
					var oldVolume:Number = _volume;
					_volume = value;
					
					postProcessVolumeChange(oldVolume);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get muted():Boolean
		{
			return _muted;
		}
		
		/**
		 * Indicates whether the AudibleTrait is muted or sounding.
		 */
		final public function set muted(value:Boolean):void
		{
			if (_muted != value)
			{
				if (canProcessMutedChange(value))
				{
					processMutedChange(value);
					
					_muted = value;
					
					postProcessMutedChange(!_muted);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get pan():Number
		{
			return _pan;
		}
		
		/**
		 * @inheritDoc
		 */
		final public function set pan(value:Number):void
		{
			// Coerce the value into our range:
			if (isNaN(value))
			{
				value = 0;
			}
			else if (value > 1)
			{
				value = 1;
			}
			else if (value < -1)
			{
				value = -1;
			}
			
			if (_pan != value)
			{
				if (canProcessPanChange(value))
				{
					processPanChange(value);
					
					var oldPan:Number = _pan;
					_pan = value;
					
					postProcessPanChange(oldPan);
				}
			}
		}
	
		// Internals
		//
		
		private var _volume:Number = 1;
		private var _muted:Boolean = false;
		private var _pan:Number = 0;
		
		/**
		 * Called before the <code>volume</code> property is changed.
		 * @param newVolume Proposed new <code>volume</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override this method
		 * can return <code>false</code> to abort the change.
		 * 
		 */		
		protected function canProcessVolumeChange(newVolume:Number):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>volume</code> value is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 * @param newVolume New <code>volume</code> value.
		 * 
		 */
		protected function processVolumeChange(newVolume:Number):void
		{
		} 
		
		/**
		 * Called just after the <code>volume</code> value has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the volumeChange event.</p> 
		 * @param oldVolume Previous <code>volume</code> value.
		 * 
		 */		
		protected function postProcessVolumeChange(oldVolume:Number):void
		{
			dispatchEvent(new VolumeChangeEvent(oldVolume,_volume));
		}
		
		/**
		 * Called before the <code>muted</code> property is toggled.
		 * @param newMuted Proposed new <code>muted</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override this method
		 * can return <code>false</code> to abort the change.
		 * 
		 */		
		protected function canProcessMutedChange(newMuted:Boolean):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>muted</code> value is toggled. 
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 * @param newMuted New <code>muted</code> value.
		 */		
		protected function processMutedChange(newMuted:Boolean):void
		{
		}
		
		/**
		 * Called just after the <code>muted</code> property has been toggled.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the mutedChange event.</p>
		 * @param oldMuted Previous <code>muted</code> value.
		 * 
		 */		
		protected function postProcessMutedChange(oldMuted:Boolean):void
		{
			dispatchEvent(new MutedChangeEvent(_muted));
		}
		
		/**
		 * Called before the <code>pan</code> property is changed.
		 * @param newPan Proposed new <code>pan</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override this method
		 * can return <code>false</code> in order to abort the change.
		 * 
		 */		
		protected function canProcessPanChange(newPan:Number):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>pan</code> value is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 * @param newPan New <code>pan</code> value.
		 */		
		protected function processPanChange(newPan:Number):void
		{	
		}
		
		/**
		 * Called just after the <code>pan</code> value has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the panChange event.</p>
		 * @param oldPan Previous <code>pan</code> value.
		 * 
		 */		
		protected function postProcessPanChange(oldPan:Number):void
		{
			dispatchEvent(new PanChangeEvent(oldPan,_pan));
		}
	}
}