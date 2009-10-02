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
package org.osmf.net
{
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	
	import org.osmf.traits.AudibleTrait;
	
	/**
	 * The NetStreamAudibleTrait class implements the IAudible interface that uses a NetStream.
	 * This trait is used by AudioElements.
	 * <p>Sets the soundTransform object on the NetStream in response to audio
	 * property changes.</p>
	 * @private
	 */ 
	public class NetStreamAudibleTrait extends AudibleTrait
	{
		/**
		 * Constructor.
		 * @param netStream NetStream created for the ILoadable that belongs to the media element
		 * that uses this trait.
		 * @see NetLoader
		 */ 
		public function NetStreamAudibleTrait(netStream:NetStream)
		{
			super();
			
			this.netStream = netStream;
		}
		
		override protected function processVolumeChange(newVolume:Number):void
		{
			var soundTransform:SoundTransform = netStream.soundTransform;				
			soundTransform.volume = muted ? 0 : newVolume;
			netStream.soundTransform = soundTransform;
		}
		
		override protected function processMutedChange(newMuted:Boolean):void
		{
			var soundTransform:SoundTransform = netStream.soundTransform;			
			soundTransform.volume = newMuted ? 0 : volume;
			netStream.soundTransform = soundTransform;
		}

		override protected function processPanChange(newPan:Number):void
		{
			var soundTransform:SoundTransform = netStream.soundTransform;					
			soundTransform.pan = newPan;
			netStream.soundTransform = soundTransform;
		}
				
		private var netStream:NetStream;		
	}
}