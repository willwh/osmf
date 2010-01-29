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
	
	import org.osmf.media.DefaultTraitResolver;
	import org.osmf.media.LoadableMediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.net.*;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	import org.osmf.utils.OSMFStrings;

   /** 
	 * AudioElement is a media element specifically created for audio playback.
	 * It supports both streaming and progressive formats.
	 * <p>AudioElement can load and present any MP3 or AAC file.
	 * It supports MP3 files over HTTP, as well as audio-only streams from
	 * Flash Media Server.</p>
	 * <p>The basic steps for creating and using an AudioElement are:
	 * <ol>
	 * <li>Create a new URLResource pointing to the URL of the audio stream or file
	 * containing the sound to be loaded.</li>
	 * <li>Create a new NetLoader or SoundLoader.  NetLoader is used for streaming
	 * audio, SoundLoader for progressive audio.</li>
	 * <li>Create the new AudioElement, 
	 * passing the ILoader and URLResource
	 * as parameters.</li>
	 * <li>Get the AudioElement's LoadTrait using the 
	 * <code>MediaElement.getTrait(MediaTraitType.LOAD)</code> method.</li>
	 * <li>Load the audio using the LoadTrait's <code>load()</code> method.</li>
	 * <li>Control the media using the AudioElement's traits, and handle its trait
	 * change events.</li>
	 * <li>When done with the AudioElement, unload the audio
	 * using the LoadTrait's <code>unload()</code> method.</li>
	 * </ol>
	 * </p>
	 * 
	 * @see org.osmf.net.NetLoader
	 * @see org.osmf.audio.SoundLoader
	 * @see org.osmf.media.URLResource
	 * @see org.osmf.media.MediaElement
	 * @see org.osmf.traits
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class AudioElement extends LoadableMediaElement
	{
		/**
		 * Constructor.  
		 * @param resource URLResource that points to the audio source that the AudioElement
		 * will use.
		 * @param loader Loader used to load the sound. This must be either a
		 * NetLoader (for streaming audio) or a SoundLoader (for progressive audio).
		 * If null, the appropriate Loader will be created based on the type of the
		 * resource.
		 * @see org.osmf.net.NetLoader
		 * 
		 * @throws ArgumentError If loader is neither a NetLoader nor a SoundLoader.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function AudioElement(resource:URLResource=null, loader:ILoader=null)
		{
			super(resource, loader, [SoundLoader, NetLoader]);
			
			if (!(loader == null || loader is NetLoader || loader is SoundLoader))
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
		}
		
		/**
       	 * Defines the duration that the element's TimeTrait will expose until the
       	 * element's content is loaded.
       	 * 
       	 * Setting this property to a positive value results in the element becoming
       	 * temporal. Any other value will remove the element's TimeTrait, unless the
       	 * loaded content is exposing a duration. 
       	 *  
       	 *  @langversion 3.0
       	 *  @playerversion Flash 10
       	 *  @playerversion AIR 1.5
       	 *  @productversion OSMF 1.0
       	 */       	
       	public function set defaultDuration(value:Number):void
		{
			if (isNaN(value) || value < 0)
			{
				if (defaultTimeTrait != null)
				{
					// Remove the default trait if the default duration
					// gets set to not a number:
					removeTraitResolver(MediaTraitType.TIME);
					defaultTimeTrait = null;
				}
			}
			else 
			{
				if (defaultTimeTrait == null)
				{		
					// Add the default trait if when default duration
					// gets set:
					defaultTimeTrait = new ModifiableTimeTrait();
		       		addTraitResolver
		       			( MediaTraitType.TIME
		       			, new DefaultTraitResolver
		       				( MediaTraitType.TIME
		       				, defaultTimeTrait
		       				)
		       			);
		  		}
		  		
		  		defaultTimeTrait.duration = value; 
			}	
		}
		
		public function get defaultDuration():Number
		{
			return defaultTimeTrait ? defaultTimeTrait.duration : NaN;
		}
		
		/**
		 * @private
		 */
		override protected function createLoadTrait(resource:MediaResourceBase, loader:ILoader):LoadTrait
		{
			return 	loader is NetLoader
				  ? new NetStreamLoadTrait(loader, resource)
				  : new SoundLoadTrait(loader, resource);
		}

		
		/**
		 * @private 
		 */ 
		override protected function processReadyState():void
		{
			var loadTrait:LoadTrait = getTrait(MediaTraitType.LOAD) as LoadTrait;

			var timeTrait:TimeTrait;
			
			// Different paths for streaming vs. progressive.
			var netLoadedContext:NetLoadedContext = loadTrait.loadedContext as NetLoadedContext;
			if (netLoadedContext)
			{
				// Streaming Audio
				//
				
				var stream:NetStream = netLoadedContext.stream;
				
				addTrait(MediaTraitType.PLAY, new NetStreamPlayTrait(stream, resource));
				timeTrait = new NetStreamTimeTrait(stream, resource);
				addTrait(MediaTraitType.TIME, timeTrait);
				addTrait(MediaTraitType.SEEK, new NetStreamSeekTrait(timeTrait, stream));
				addTrait(MediaTraitType.AUDIO, new NetStreamAudioTrait(stream));	
				addTrait(MediaTraitType.BUFFER, new NetStreamBufferTrait(stream));
			}
			else
			{
				// Progressive Audio
				//
				
				var soundLoadedContext:SoundLoadedContext = loadTrait.loadedContext as SoundLoadedContext;

				soundAdapter = new SoundAdapter(this, soundLoadedContext.sound);
				
				addTrait(MediaTraitType.PLAY, new AudioPlayTrait(soundAdapter));
				timeTrait = new AudioTimeTrait(soundAdapter);
				addTrait(MediaTraitType.TIME, timeTrait);
				addTrait(MediaTraitType.SEEK, new AudioSeekTrait(timeTrait, soundAdapter));
				addTrait(MediaTraitType.AUDIO, new AudioAudioTrait(soundAdapter));	
			}
		}	
				
		/**
		 * @private 
		 */ 
		override protected function processUnloadingState():void
		{
			removeTrait(MediaTraitType.PLAY);
			removeTrait(MediaTraitType.SEEK);
			removeTrait(MediaTraitType.TIME);
			removeTrait(MediaTraitType.AUDIO);
			removeTrait(MediaTraitType.BUFFER);

			if (soundAdapter != null)
			{
				// Halt the sound.
				soundAdapter.pause();
			}
			soundAdapter = null;
		}	
					
		private var soundAdapter:SoundAdapter;
		private var defaultTimeTrait:ModifiableTimeTrait;
	}
}