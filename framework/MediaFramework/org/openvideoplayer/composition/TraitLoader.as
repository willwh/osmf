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
package org.openvideoplayer.composition
{
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	
	/**
	 * Dispatched when the requested MediaElement has been found, or when it
	 * has been determined that no such MediaElement exists.
	 * 
	 * @eventType org.openvideoplayer.composition.events.TraitLoaderEvent.TRAIT_FOUND
	 */
	[Event(name="traitFound",type="org.openvideoplayer.composition.events.TraitLoaderEvent")]

	/**
	 * Utility class for doing conditional loads of MediaElements.
	 **/
	internal class TraitLoader extends EventDispatcher
	{
		/**
		 * Iterates over a list of MediaElements looking for a given trait, and
		 * returns the first MediaElement in the list which either has the trait,
		 * or which acquires the trait as a result of being loaded.  (As such,
		 * has the side effect of loading all MediaElements in the list up until
		 * it finds one with the requested trait.
		 **/
		public function findOrLoadMediaElementWithTrait(mediaElements:Array, traitType:MediaTraitType):void
		{
			var noSuchTrait:Boolean = true;
			
			for each (var mediaElement:MediaElement in mediaElements)
			{
				var loadable:ILoadable = mediaElement.getTrait(MediaTraitType.LOADABLE) as ILoadable;
				
				if (mediaElement.hasTrait(traitType))
				{
					// If the next MediaElement has the requested trait, then
					// we're done.
					//
					
					noSuchTrait = false;
					
					dispatchFindOrLoadEvent(mediaElement);
					break;
				}
				else if (loadable != null &&
						 loadable.loadState != LoadState.LOADED)
				{
					// If the next MediaElement doesn't have the trait, but has
					// the ILoadable trait and is not yet loaded, then we should
					// load it in case the trait gets added as a result of the
					// load operation.
					//
					
					// We're not sure yet if there's a trait.
					noSuchTrait = false;
					
					loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
					
					// If it's already loading, then we only need to wait for
					// the event.
					if (loadable.loadState != LoadState.LOADING)
					{
						loadable.load();
					}
					break;
					
					function onLoadableStateChange(event:LoadableStateChangeEvent):void
					{
						var loadable:ILoadable = event.target as ILoadable;
						if (loadable.loadState == LoadState.LOADED)
						{
							if (mediaElement.hasTrait(traitType))
							{
								dispatchFindOrLoadEvent(mediaElement);
							}
							else
							{
								// Recursively call this method, after stripping
								// off all MediaElements up to and including
								// the one we're iterating over (i.e. the one
								// we just loaded).
								findOrLoadMediaElementWithTrait
									( mediaElements.slice(mediaElements.indexOf(mediaElement)+1)
									, traitType
									);
							}
						}
					}
				}
			}
			
			if (noSuchTrait)
			{
				dispatchFindOrLoadEvent(null);
			}
		}
		
		private function dispatchFindOrLoadEvent(mediaElement:MediaElement):void
		{
			dispatchEvent(new TraitLoaderEvent(mediaElement));
		}
	}
}