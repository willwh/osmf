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
	import flash.net.NetStream;
	
	import org.osmf.media.IURLResource;
	import org.osmf.media.LoadableMediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.net.*;
	import org.osmf.traits.IDownloadable;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SeekableTrait;
	import org.osmf.traits.TemporalTrait;
	import org.osmf.utils.MediaFrameworkStrings;

   /** 
	 * AudioElement is a media element specifically created for audio playback.
	 * It supports both streaming and progressive formats.
	 * <p>AudioElement can load and present any MP3 or AAC file.
	 * It supports MP3 files over HTTP, as well as audio-only streams from
	 * Flash Media Server.</p>
     * <p>The AudioElement has IAudible, IBufferable, ILoadable, IPausable, IPlayable, ISeekable,
     * and ITemporal traits.</p>
	 * <p>The basic steps for creating and using an AudioElement are:
	 * <ol>
	 * <li>Create a new IURLResource pointing to the URL of the audio stream or file
	 * containing the sound to be loaded.</li>
	 * <li>Create a new NetLoader or SoundLoader.  NetLoader is used for streaming
	 * audio, SoundLoader for progressive audio.</li>
	 * <li>Create the new AudioElement, 
	 * passing the ILoader and IURLResource
	 * as parameters.</li>
	 * <li>Get the AudioElement's ILoadable trait using the 
	 * <code>MediaElement.getTrait(LOADABLE)</code> method.</li>
	 * <li>Load the audio using the ILoadable's <code>load()</code> method.</li>
	 * <li>Control the media using the AudioElement's traits, and handle its trait
	 * change events.</li>
	 * <li>When done with the AudioElement, unload the audio using the  
	 * using the ILoadable's <code>unload()</code> method.</li>
	 * </ol>
	 * </p>
	 * 
	 * @see org.osmf.net.NetLoader
	 * @see org.osmf.audio.SoundLoader
	 * @see org.osmf.media.IURLResource
	 * @see org.osmf.media.MediaElement
	 * @see org.osmf.traits
	 */
	public class AudioElement extends LoadableMediaElement
	{
		/**
		 * Constructor.  
		 * @param loader Loader used to load the sound. This must be either a
		 * NetLoader (for streaming audio) or a SoundLoader (for progressive audio).
		 * @param resource URL that points to the audio source that the AudioElement will use.  
		 * @see org.osmf.net.NetLoader
		 * 
		 * @throws ArgumentError If loader is null, or neither a NetLoader nor a SoundLoader.
		 */ 
		public function AudioElement(loader:ILoader, resource:IURLResource=null)
		{
			super(loader, resource);
			
			if (!(loader is NetLoader || loader is SoundLoader))
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_PARAM);
			}
		}
		
		/**
		 *  @private 
		 */ 
		override protected function processLoadedState():void
		{
			var loadable:ILoadable = getTrait(MediaTraitType.LOADABLE) as ILoadable;
			var urlResource:URLResource = resource as URLResource;

			var seekable:SeekableTrait;
			var temporal:TemporalTrait;
			
			// Different paths for streaming vs. progressive.
			var netLoadedContext:NetLoadedContext = loadable.loadedContext as NetLoadedContext;
			if (netLoadedContext)
			{
				// Streaming Audio
				//
				
				var stream:NetStream = netLoadedContext.stream;
				
				addTrait(MediaTraitType.PLAYABLE, new NetStreamPlayableTrait(this, stream, urlResource));
				seekable = new NetStreamSeekableTrait(stream);
				temporal = new NetStreamTemporalTrait(stream);
				seekable.temporal = temporal;
				addTrait(MediaTraitType.SEEKABLE, seekable);
				addTrait(MediaTraitType.TEMPORAL, temporal);
				addTrait(MediaTraitType.PAUSABLE, new NetStreamPausableTrait(this, stream));
				addTrait(MediaTraitType.AUDIBLE, new NetStreamAudibleTrait(stream));	
				addTrait(MediaTraitType.BUFFERABLE, new NetStreamBufferableTrait(stream));
			}
			else
			{
				// Progressive Audio
				//
				
				var soundLoadedContext:SoundLoadedContext = loadable.loadedContext as SoundLoadedContext;

				soundAdapter = new SoundAdapter(this, soundLoadedContext.sound);
				
				addTrait(MediaTraitType.PLAYABLE, new AudioPlayableTrait(this, soundAdapter));
				seekable = new AudioSeekableTrait(soundAdapter);				
				temporal = new AudioTemporalTrait(soundAdapter);
				seekable.temporal = temporal;
				addTrait(MediaTraitType.SEEKABLE, seekable);
				addTrait(MediaTraitType.TEMPORAL, temporal);
				addTrait(MediaTraitType.PAUSABLE, new AudioPausableTrait(this, soundAdapter));
				addTrait(MediaTraitType.AUDIBLE, new AudioAudibleTrait(soundAdapter));	
			}
		}	
		
		/**
		 * @private
		 */
		override protected function processLoadingState():void
		{
			var context:SoundLoadedContext
				= (getTrait(MediaTraitType.LOADABLE) as ILoadable).loadedContext as SoundLoadedContext;
				
			if (context != null && context.sound != null)
			{
				var downloadable:IDownloadable = new SoundDownloadableTrait(context.sound);
				addTrait(MediaTraitType.DOWNLOADABLE, downloadable);
			}
		} 
		
		/**
		 * @private 
		 */ 
		override protected function processUnloadingState():void
		{
			removeTrait(MediaTraitType.PLAYABLE);
			removeTrait(MediaTraitType.SEEKABLE);
			removeTrait(MediaTraitType.TEMPORAL);
			removeTrait(MediaTraitType.PAUSABLE);
			removeTrait(MediaTraitType.AUDIBLE);
			removeTrait(MediaTraitType.BUFFERABLE);
			removeTrait(MediaTraitType.DOWNLOADABLE);

			if (soundAdapter != null)
			{
				// Halt the sound.
				soundAdapter.pause();
			}
			soundAdapter = null;
		}	
					
		private var soundAdapter:SoundAdapter;
	}
}