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
package org.osmf.audio
{
	import org.osmf.traits.SeekableTrait;
	
	internal class AudioSeekableTrait extends SeekableTrait
	{
		public function AudioSeekableTrait(soundAdapter:SoundAdapter)
		{			
			this.soundAdapter = soundAdapter;
		}

		/** 
		 * inheritDoc
		 */
		override protected function processSeekingChange(newSeeking:Boolean, time:Number):void
		{
			if (newSeeking)
			{
				soundAdapter.seek(time);	
				lastSeekTime = time;
			}					
		}
		
		/** 
		 * inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		override protected function postProcessSeekingChange(seeking:Boolean):void
		{
			super.postProcessSeekingChange(seeking);
			if (!seeking)  //if we just started seeking, finish since this operation is async
			{
				processSeekCompletion(lastSeekTime);
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
		override public function canSeekTo(time:Number):Boolean
		{
			// Validate that the time is in range.  Note that we return true
			// if the time is less than the duration *or* the current time.  The
			// latter is for the case where the media has no (NaN) duration, but
			// is still progressing.  Presumably it should be possible to seek
			// backwards.
			return 		isNaN(time) == false
					&& 	time >= 0
					&&	(time <= soundAdapter.estimatedDuration || time <= soundAdapter.currentTime);
		}
			
		private var lastSeekTime:Number;		
		private var soundAdapter:SoundAdapter;
	}
}