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
package org.osmf.tracking
{
	import org.osmf.events.BeaconEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.PlayableTrait;
	
	internal class BeaconPlayableTrait extends PlayableTrait
	{
		public function BeaconPlayableTrait(owner:MediaElement, beacon:Beacon)
		{
			super(owner);
			
			this.beacon = beacon;
		}

		override protected function processPlayingChange(newPlaying:Boolean):void
		{
			if (newPlaying)
			{
				// A play equals a "ping".
				beacon.addEventListener(BeaconEvent.PING_COMPLETE, onBeaconEvent);
				beacon.addEventListener(BeaconEvent.PING_FAILED, onBeaconEvent);
				beacon.ping();
				
				function onBeaconEvent(event:BeaconEvent):void
				{
					beacon.removeEventListener(BeaconEvent.PING_COMPLETE, onBeaconEvent);
					beacon.removeEventListener(BeaconEvent.PING_FAILED, onBeaconEvent);
					
					if (event.type == BeaconEvent.PING_FAILED)
					{
						dispatchEvent
							( new MediaErrorEvent
								( MediaErrorEvent.MEDIA_ERROR
								, false
								, false
								, new MediaError(MediaErrorCodes.BEACON_FAILURE_ERROR, event.errorText)
								)
							);
					}
				}

			}
		}
		
		override protected function postProcessPlayingChange(oldPlaying:Boolean):void
		{
			super.postProcessPlayingChange(oldPlaying);
			
			if (oldPlaying == false)
			{
				// When the play() is finished, we reset our state to "not playing",
				// since this trait has completed its work.
				resetPlaying();
			}
		}

		private var beacon:Beacon;
	}
}