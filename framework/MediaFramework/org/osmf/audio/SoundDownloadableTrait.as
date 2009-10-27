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
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	
	import org.osmf.events.BytesTotalChangeEvent;
	import org.osmf.traits.DownloadableTrait;

	/**
	 * This class extends Downloadable trait to provide access to the bytesLoaded and bytesTotal properties
	 * of Sound.
	 */
	internal class SoundDownloadableTrait extends DownloadableTrait
	{
		/**
		 * Constructor
		 * 
		 * @param sound The Sound object from which the values for bytesDownloaed and bytesTotal will be obtained.
		 */
		public function SoundDownloadableTrait(sound:Sound)
		{
			super(NaN, NaN);

			_sound = sound;
			_sound.addEventListener(Event.OPEN, bytesTotalCheckingHandler);
			_sound.addEventListener(ProgressEvent.PROGRESS, bytesTotalCheckingHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get bytesDownloaded():Number
		{
			return _sound.bytesLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get bytesTotal():Number
		{
			return _sound.bytesTotal;
		}
		
		//
		// Internals
		//

		private function bytesTotalCheckingHandler(_:Event):void
		{
			if (_lastBytesTotal != _sound.bytesTotal)
			{
				var event:BytesTotalChangeEvent
					= new BytesTotalChangeEvent
						( _lastBytesTotal
						, _sound.bytesTotal
						);
						
				_lastBytesTotal = _sound.bytesTotal;
				dispatchEvent(event);
			}
		}	
		
		private var _lastBytesTotal:Number;
		private var _sound:Sound;
	}
}