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
package org.osmf.examples.buffering
{
	import org.osmf.media.MediaElement;
	import org.osmf.proxies.ListenerProxyElement;
	import org.osmf.traits.BufferTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	
	/**
	 * Proxy class which sets the IBufferable.bufferTime property to
	 * an initial value when the IBufferable trait is available, and
	 * an expanded value when the proxied MediaElement first exits
	 * the buffer state.
	 **/
	public class DualThresholdBufferingProxyElement extends ListenerProxyElement
	{
		public function DualThresholdBufferingProxyElement(initialBufferTime:Number, expandedBufferTime:Number, wrappedElement:MediaElement)
		{
			super(wrappedElement);
			
			this.initialBufferTime = initialBufferTime;
			this.expandedBufferTime = expandedBufferTime;
		}

		override protected function processTraitAdd(traitType:String):void
		{
			if (traitType == MediaTraitType.BUFFER)
			{
				// As soon as we can buffer, set the initial buffer time.
				var bufferTrait:BufferTrait = getTrait(MediaTraitType.BUFFER) as BufferTrait;
				bufferTrait.bufferTime = initialBufferTime;
			}
		}

		override protected function processBufferingChange(buffering:Boolean):void
		{
			// As soon as we stop buffering, make sure our buffer time is
			// set to the maximum.
			if (buffering == false)
			{
				var bufferTrait:BufferTrait = getTrait(MediaTraitType.BUFFER) as BufferTrait;
				bufferTrait.bufferTime = expandedBufferTime;
			}
		}
		
		override protected function processSeekingChange(seeking:Boolean, time:Number):void
		{
			// Whenever we seek, reset our buffer time to the minimum so that
			// playback starts quickly after the seek.
			if (seeking == true)
			{
				var bufferTrait:BufferTrait = getTrait(MediaTraitType.BUFFER) as BufferTrait;
				bufferTrait.bufferTime = initialBufferTime;
			}
		}
		
		override protected function processPlayStateChange(playState:String):void
		{
			// Whenever we pause, reset our buffer time to the minimum so that
			// playback starts quickly after the unpause.
			if (playState == PlayState.PAUSED)
			{
				var bufferTrait:BufferTrait = getTrait(MediaTraitType.BUFFER) as BufferTrait;
				bufferTrait.bufferTime = initialBufferTime;
			}
		}
 		
		private var initialBufferTime:Number;
		private var expandedBufferTime:Number;
	}
}