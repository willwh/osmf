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
	import org.osmf.traits.IBufferable;
	import org.osmf.traits.MediaTraitType;
	
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

		override protected function processTraitAdd(traitType:MediaTraitType):void
		{
			if (traitType == MediaTraitType.BUFFERABLE)
			{
				var bufferable:IBufferable = getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
				bufferable.bufferTime = initialBufferTime;
			}
		}

		override protected function processBufferingChange(buffering:Boolean):void
		{
			if (buffering == false)
			{
				var bufferable:IBufferable = getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
				bufferable.bufferTime = expandedBufferTime;
			}
		}
		
		private var initialBufferTime:Number;
		private var expandedBufferTime:Number;
	}
}