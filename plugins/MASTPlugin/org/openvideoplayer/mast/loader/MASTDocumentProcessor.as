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
*  Contributor(s): Akamai Technologies
* 
*****************************************************/
package org.openvideoplayer.mast.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.mast.managers.MASTConditionManager;
	import org.openvideoplayer.mast.model.*;
	import org.openvideoplayer.mast.traits.MASTPlayableTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.LoadableTrait;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.vast.loader.VASTLoadedContext;
	import org.openvideoplayer.vast.loader.VASTLoader;
	import org.openvideoplayer.vast.media.DefaultVASTMediaFileResolver;
	import org.openvideoplayer.vast.media.IVASTMediaFileResolver;
	import org.openvideoplayer.vast.media.VASTMediaGenerator;
	
	public class MASTDocumentProcessor extends EventDispatcher
	{
		// Supported source formats
		private static const SOURCE_FORMAT_VAST:String = "vast";
		
		public function MASTDocumentProcessor()
		{
			super();
		}
		
		public function processDocument(document:MASTDocument, mediaElement:MediaElement):void
		{
			// Set up a listener for each trigger.
			for each (var trigger:MASTTrigger in document.triggers)
			{
				var condition:MASTCondition;
				
				for each (condition in trigger.startConditions)
				{
					processMASTCondition(trigger, condition, mediaElement, true);
				}

				for each (condition in trigger.endConditions)
				{
					processMASTCondition(trigger, condition, mediaElement, false);
				}
			}
		}
		
		/**
		 * Loads any payload (source) associated with a trigger.
		 * <p>
		 * To add support for an additional payload, override this
		 * method.
		 * </p>
		 */
		public function loadSources(trigger:MASTTrigger, condition:MASTCondition):void
		{
			for each (var source:MASTSource in trigger.sources)
			{
				if (source.format == SOURCE_FORMAT_VAST)
				{
					loadVastDocument(source, condition);
				}
			}
		}
		
		private function processMASTCondition(trigger:MASTTrigger, condition:MASTCondition, mediaElement:MediaElement, start:Boolean):void
		{
			var conditionManager:MASTConditionManager = new MASTConditionManager();
			conditionManager.addEventListener("conditionTrue", onConditionTrue);
			conditionManager.setContext(mediaElement, condition);
		
			function onConditionTrue(event:Event):void
			{
				conditionManager.removeEventListener("conditionTrue", onConditionTrue);
				loadSources(trigger, condition);
			}
		}
		
		/**
		 * Loads a VAST document specified in the MASTSource object.
		 * 
		 * @param source The MASTSource object containing the VAST document to load.
		 * @param condition The MASTCondition object that is causing the source to be loaded.
		 */
		public function loadVastDocument(source:MASTSource, condition:MASTCondition):void
		{
			var loadableTrait:LoadableTrait
				= new LoadableTrait(new VASTLoader(), new URLResource(new URL(source.url)));
			
			loadableTrait.addEventListener
				( LoadableStateChangeEvent.LOADABLE_STATE_CHANGE
				, onLoadableStateChange
				);
			loadableTrait.load();
			
			function onLoadableStateChange(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					loadableTrait.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
						
					// Get the appropriate inline MediaElements.
					var loadedContext:VASTLoadedContext = event.loadable.loadedContext as VASTLoadedContext;
					var generator:VASTMediaGenerator = new VASTMediaGenerator();
					var resolver:IVASTMediaFileResolver = new DefaultVASTMediaFileResolver();
					
					dispatchEvent(new MASTDocumentProcessedEvent(generator.createMediaElements(loadedContext.vastDocument), condition));
				}
			}
		}
	}
}
