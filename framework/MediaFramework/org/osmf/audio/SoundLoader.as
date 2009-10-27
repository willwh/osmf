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
	import __AS3__.vec.Vector;
	
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IURLResource;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoaderBase;
	import org.osmf.utils.*;

	/**
	 * The SoundLoader class implements ILoader to provide
	 * loading support to the AudioElement class for progressive audio.
	 * <p>Creates a flash.media.Sound object, which it uses to load and
	 * unload the audio file.</p>
	 * <p>The audio file is loaded from the URL provided by the
	 * <code>resource</code> property of the ILoadable that is passed
	 * to the SoundLoader's <code>load()</code> method.</p>
	 *
	 * @see AudioElement
	 * @see org.osmf.traits.ILoadable
	 * @see flash.media.Sound
	 */ 
	public class SoundLoader extends LoaderBase
	{
		/**
		 * Constructs a new SoundLoader.
		 */ 
		public function SoundLoader()
		{
			super();
		}
		
		/**
		 * Indicates whether this SoundLoader is capable of handling the specified resource.
		 * Returns <code>true</code> for IURLResources with MP3 extensions or media/mime
		 * types that match MP3.
		 * @param resource Resource proposed to be loaded.
		 */ 
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			var rt:int = MetadataUtils.checkMetadataMatchWithResource(resource, MEDIA_TYPES_SUPPORTED, MIME_TYPES_SUPPORTED);
			if (rt != MetadataUtils.METADATA_MATCH_UNKNOWN)
			{
				return rt == MetadataUtils.METADATA_MATCH_FOUND;
			}			
			
			// If no metadata matches, then we can only handle if the URL
			// extension matches.
			var urlResource:IURLResource = resource as IURLResource;
			if (urlResource != null && 
				urlResource.url != null)
			{
				return urlResource.url.path.search(/\.mp3$/i) != -1;
			}

			return false;
		}
		
		/**
		 * Loads the Sound object.. 
		 * <p>Updates the ILoadable's <code>loadedState</code> property to LOADING
		 * while loading and to LOADED upon completing a successful load.</p> 
		 * 
		 * @see org.osmf.traits.LoadState
		 * @param ILoadable ILoadable to be loaded.
		 */ 
		override public function load(loadable:ILoadable):void
		{
			super.load(loadable);
						
			var sound:Sound = new Sound();
			var context:SoundLoadedContext = new SoundLoadedContext(sound);
			updateLoadable(loadable, LoadState.LOADING, context);
			toggleSoundListeners(sound, true);

			var urlRequest:URLRequest = new URLRequest((loadable.resource as IURLResource).url.toString());
			
			try
			{
				sound.load(urlRequest);
			}
			catch (ioError:IOError)
			{
				onIOError(null, ioError.message);
			}
			catch (securityError:SecurityError)
			{
				handleSecurityError(securityError.message);
			}

			function toggleSoundListeners(sound:Sound, on:Boolean):void
			{
				if (on)
				{
					sound.addEventListener(ProgressEvent.PROGRESS, onProgress)
					sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				}
				else
				{
					sound.removeEventListener(ProgressEvent.PROGRESS, onProgress)
					sound.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				}
			}

			function onProgress(event:ProgressEvent):void
			{
				// There's no "loaded" event associated with the Sound class.
				// We can't rely on the "open" event, because that can get
				// fired prior to an "ioError" event (which seems like a bug).
				// But we can assume that if we get a progress event, then the
				// load has succeeded.
				//
				 
				toggleSoundListeners(sound, false);

				updateLoadable(loadable, LoadState.LOADED, context);
			}

			function onIOError(ioEvent:IOErrorEvent, ioEventDetail:String=null):void
			{	
				toggleSoundListeners(sound, false);
				
				updateLoadable(loadable, LoadState.LOAD_FAILED);
				loadable.dispatchEvent
					( new MediaErrorEvent
						( new MediaError
							( MediaErrorCodes.AUDIO_IO_LOAD_ERROR
							, ioEvent ? ioEvent.text : ioEventDetail
							)
						)
					);
			}

			function handleSecurityError(securityErrorDetail:String):void
			{	
				toggleSoundListeners(sound, false);
				
				updateLoadable(loadable, LoadState.LOAD_FAILED);
				loadable.dispatchEvent
					( new MediaErrorEvent
						( new MediaError
							( MediaErrorCodes.AUDIO_SECURITY_LOAD_ERROR
							, securityErrorDetail
							)
						)
					);
			}
		}

		/**
		 * Unloads the Sound object.  
		 * 
		 * <p>Updates the ILoadable's <code>loadedState</code> property to UNLOADING
		 * while unloading and to CONSTRUCTED upon completing a successful unload.</p>
		 *
		 * @param ILoadable ILoadable to be unloaded.
		 * @see org.osmf.traits.LoadState
		 */ 
		override public function unload(loadable:ILoadable):void
		{
			super.unload(loadable);

			var context:SoundLoadedContext = loadable.loadedContext as SoundLoadedContext;
			updateLoadable(loadable, LoadState.UNLOADING, context);
			try
			{			
				context.sound.close();
			}
			catch (error:IOError)
			{
				// Swallow, either way the Sound is now unloaded.
			}
			updateLoadable(loadable, LoadState.CONSTRUCTED);
		}
		
		// Internals
		//

		private static const MIME_TYPES_SUPPORTED:Vector.<String> = Vector.<String>(["audio/mpeg"]);
			
		private static const MEDIA_TYPES_SUPPORTED:Vector.<String> = Vector.<String>([MediaType.AUDIO]);
	}
}