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
		 */ 
		override public function canSeekTo(time:Number):Boolean
		{
			return 		isNaN(time) == false
					&&	time <= soundAdapter.estimatedDuration
					&&	time >= 0
		}
			
		private var lastSeekTime:Number;		
		private var soundAdapter:SoundAdapter;
	}
}