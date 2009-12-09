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
	
	import org.osmf.events.LoadEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.traits.ILoadedContext;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	
	[ExcludeClass]
	
	/**
	 * @private
	 **/
	internal class SoundLoadTrait extends LoadTrait
	{
		public function SoundLoadTrait(loader:ILoader, resource:IMediaResource)
		{
			super(loader, resource);
		}
		
		override protected function processLoadStateChange(newState:String, newContext:ILoadedContext):void
		{
			if (newState == LoadState.READY)
			{
				var context:SoundLoadedContext = newContext as SoundLoadedContext;
				sound = context.sound;
				sound.addEventListener(Event.OPEN, bytesTotalCheckingHandler, false, 0, true);
				sound.addEventListener(ProgressEvent.PROGRESS, bytesTotalCheckingHandler, false, 0, true);
			}
			else if (newState == LoadState.UNINITIALIZED)
			{
				sound = null;
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
		override public function get bytesLoaded():Number
		{
			return sound ? sound.bytesLoaded : NaN;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		override public function get bytesTotal():Number
		{
			return sound ? sound.bytesTotal : NaN;
		}
		
		// Internals
		//

		private function bytesTotalCheckingHandler(_:Event):void
		{
			if (lastBytesTotal != sound.bytesTotal)
			{
				var event:LoadEvent
					= new LoadEvent
						( LoadEvent.BYTES_TOTAL_CHANGE
						, false
						, false
						, null
						, sound.bytesTotal
						);
						
				lastBytesTotal = sound.bytesTotal;
				dispatchEvent(event);
			}
		}	
		
		private var lastBytesTotal:Number;
		private var sound:Sound;
	}
}