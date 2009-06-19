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
package org.openvideoplayer.display
{
	import flash.events.Event;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;

    /**
	 * Dispatched when the <code>width</code> and/or <code>height</code> property of the 
	 * source media has changed.
	 * 
	 * @eventType org.openvideoplayer.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */		
	 [Event(name="dimensionChange", type="org.openvideoplayer.events.DimensionChangeEvent")]

	/**
	 * The MediaElementSprite class is designed to display media with IViewable and ISpatial properties.  It is based off
	 * of flash.display.Sprite to be both compatible with Flash and Flex workflows.   The IViewable and ISpatial events
	 * are adapted though this UI wrapper class. 
	 */
	public class MediaElementSprite extends ScalableSprite
	{
		/**
		 * Constructor
		 */ 
		public function MediaElementSprite()
		{
			super();				
		}
							
		/**
		 * Source MediaElement controlled by this MediaElementSprite.  
		 */
		public function set element(value:MediaElement):void
		{
			if(_source)
			{
				_source.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
				_source.removeEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);		
				if(_source.hasTrait(MediaTraitType.VIEWABLE)) //Take care of event listeners
				{	
					onTraitRemove(new TraitsChangeEvent(TraitsChangeEvent.TRAIT_REMOVE, MediaTraitType.VIEWABLE));
				}
				if(_source.hasTrait(MediaTraitType.SPATIAL))
				{	
					onTraitRemove(new TraitsChangeEvent(TraitsChangeEvent.TRAIT_REMOVE, MediaTraitType.SPATIAL));
				}
			}
			_source = value;	
			if(_source)
			{	
				_source.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
				_source.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
				if(_source.hasTrait(MediaTraitType.VIEWABLE)) 
				{					
					onTraitAdd(new TraitsChangeEvent(TraitsChangeEvent.TRAIT_ADD, MediaTraitType.VIEWABLE));
				}
				if(_source.hasTrait(MediaTraitType.SPATIAL))
				{
					onTraitAdd(new TraitsChangeEvent(TraitsChangeEvent.TRAIT_ADD, MediaTraitType.SPATIAL));
				}
			}	
		}
		
		
		public function get element():MediaElement
		{
			return _source;
		}	
		
		 private function onTraitAdd(event:TraitsChangeEvent):void
		 {	
		 	switch (event.traitType)
		 	{
		 		case MediaTraitType.SPATIAL:
		 			_source.getTrait(MediaTraitType.SPATIAL).addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensions);
					setIntrinsicSize(ISpatial(_source.getTrait(MediaTraitType.SPATIAL)).width, ISpatial(_source.getTrait(MediaTraitType.SPATIAL)).height);
		 			break;
		 		case MediaTraitType.VIEWABLE:
		 			_source.getTrait(MediaTraitType.VIEWABLE).addEventListener(ViewChangeEvent.VIEW_CHANGE, onView);
		 			view = (_source.getTrait(MediaTraitType.VIEWABLE) as IViewable).view;		 			
		 			break;		 			
		 	}
		 }
		 
		 private function onTraitRemove(event:TraitsChangeEvent):void
		 {
		 	switch (event.traitType)
		 	{
		 		case MediaTraitType.SPATIAL:
		 			_source.getTrait(MediaTraitType.SPATIAL).removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensions);
		 			break;
		 		case MediaTraitType.VIEWABLE:
		 			_source.getTrait(MediaTraitType.VIEWABLE).removeEventListener(ViewChangeEvent.VIEW_CHANGE, onView);		 			
		 			break;		 			
		 	}
		 }
		 
		 private function onDimensions(event:DimensionChangeEvent):void
		 {
		 	setIntrinsicSize(event.newWidth, event.newHeight);	
		 	dispatchEvent(event.clone());	 	
		 }
		 
		 private function onView(event:ViewChangeEvent):void
		 {
		 	view = event.newView;
		 }
		 
		 private var _source:MediaElement;
	}
}