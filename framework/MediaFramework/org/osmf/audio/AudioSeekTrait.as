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
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	
	internal class AudioSeekTrait extends SeekTrait
	{
		public function AudioSeekTrait(timeTrait:TimeTrait, soundAdapter:SoundAdapter)
		{
			super(timeTrait);
			
			this.soundAdapter = soundAdapter;
		}

		/** 
		 * @inheritDoc
		 */
		override protected function processSeekingChange(newSeeking:Boolean, time:Number):void
		{
			if (newSeeking)
			{
				soundAdapter.seek(time);	
			}					
		}
		
		/** 
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override protected function postProcessSeekingChange(time:Number):void
		{
			super.postProcessSeekingChange(time);
			
			// If we just started seeking, finish since this operation is async.
			if (seeking == true)
			{
				processSeekCompletion(time);
			}
		}
			
		private var soundAdapter:SoundAdapter;
	}
}