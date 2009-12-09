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
	import org.osmf.events.AudioEvent;
	
	/**
	 * Dispatched when the trait's <code>volume</code> property has changed.
	 * 
	 * @eventType org.osmf.events.AudioEvent.VOLUME_CHANGE
	 */	
	[Event(name="volumeChange",type="org.osmf.events.AudioEvent")]
	
	/**
  	 * Dispatched when the trait's <code>muted</code> property has changed.
  	 * 
  	 * @eventType org.osmf.events.AudioEvent.MUTED_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="mutedChange",type="org.osmf.events.AudioEvent")]
	
	/**
 	 * Dispatched when the trait's <code>pan</code> property has changed.
 	 * 
 	 * @eventType org.osmf.events.AudioEvent.PAN_CHANGE 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="panChange",type="org.osmf.events.AudioEvent")]
	
	/**
	 * The AudibleTrait class provides a base IAudible implementation.
	 * It can be used as the base class for a more specific audible trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public class AudibleTrait extends MediaTraitBase implements IAudible
	{
		// IAudible
		//
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get volume():Number
		{
			return _volume;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
					
					_volume = value;
					
					postProcessVolumeChange();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get muted():Boolean
		{
			return _muted;
		}
		
		/**
		 * Indicates whether the AudibleTrait is muted or sounding.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		final public function set muted(value:Boolean):void
		{
			if (_muted != value)
			{
				if (canProcessMutedChange(value))
				{
					processMutedChange(value);
					
					_muted = value;
					
					postProcessMutedChange();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get pan():Number
		{
			return _pan;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
					
					_pan = value;
					
					postProcessPanChange();
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function processVolumeChange(newVolume:Number):void
		{
		} 
		
		/**
		 * Called just after the <code>volume</code> value has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the volumeChange event.</p> 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessVolumeChange():void
		{
			dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE, false, false, false, _volume));
		}
		
		/**
		 * Called before the <code>muted</code> property is toggled.
		 * @param newMuted Proposed new <code>muted</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override this method
		 * can return <code>false</code> to abort the change.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function canProcessMutedChange(newMuted:Boolean):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>muted</code> value is toggled. 
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 * @param newMuted New <code>muted</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processMutedChange(newMuted:Boolean):void
		{
		}
		
		/**
		 * Called just after the <code>muted</code> property has been toggled.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the mutedChange event.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessMutedChange():void
		{
			dispatchEvent(new AudioEvent(AudioEvent.MUTED_CHANGE, false, false, _muted));
		}
		
		/**
		 * Called before the <code>pan</code> property is changed.
		 * @param newPan Proposed new <code>pan</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override this method
		 * can return <code>false</code> in order to abort the change.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function canProcessPanChange(newPan:Number):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>pan</code> value is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 * @param newPan New <code>pan</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processPanChange(newPan:Number):void
		{	
		}
		
		/**
		 * Called just after the <code>pan</code> value has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the panChange event.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessPanChange():void
		{
			dispatchEvent(new AudioEvent(AudioEvent.PAN_CHANGE, false, false, false, NaN, _pan));
		}
	}
}