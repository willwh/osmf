/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.smil.media
{
	import org.osmf.elements.CompositeElement;
	import org.osmf.elements.ParallelElement;
	import org.osmf.elements.SerialElement;
	import org.osmf.elements.DurationElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.net.DynamicStreamingItem;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.smil.model.SMILDocument;
	import org.osmf.smil.model.SMILElement;
	import org.osmf.smil.model.SMILElementType;
	import org.osmf.smil.model.SMILMediaElement;
	import org.osmf.smil.model.SMILMetaElement;
	import org.osmf.utils.URL;
	
	/**
	 * A utility class for creating MediaElements from a <code>SMILDocument</code>.
	 */
	public class SMILMediaGenerator
	{
		/**
		 * Creates the relevant MediaElement from the SMILDocument.
		 * 
		 * @param smilDocument The SMILDocument to use for media creation.
		 * @returns A new MediaElement based on the information found in the SMILDocument.
		 */
		public function createMediaElement(smilDocument:SMILDocument, factory:MediaFactory):MediaElement
		{
			this.factory = factory;
			
			CONFIG::LOGGING
			{
				traceElements(smilDocument);
			}
			
			var mediaElement:MediaElement;
			
			for (var i:int = 0; i < smilDocument.numElements; i++)
			{
				var smilElement:SMILElement = smilDocument.getElementAt(i);
				mediaElement = internalCreateMediaElement(null, smilDocument, smilElement);
			}
							
			return mediaElement;
		}
		
		/**
		 * Recursive function to create a media element and all of it's children.
		 */
		private function internalCreateMediaElement(parentMediaElement:MediaElement, smilDocument:SMILDocument, 
													smilElement:SMILElement):MediaElement
		{
			var mediaResource:MediaResourceBase = null;
			
			var mediaElement:MediaElement;
			
			switch (smilElement.type)
			{
				case SMILElementType.SWITCH:
					mediaResource = createDynamicStreamingResource(smilElement, smilDocument);
					break;
				case SMILElementType.PARALLEL:
					var parallelElement:ParallelElement = new ParallelElement();
					mediaElement = parallelElement;
					break;
				case SMILElementType.SEQUENCE:
					var serialElement:SerialElement = new SerialElement();
					mediaElement = serialElement;
					break;
				case SMILElementType.VIDEO:
					var resource:URLResource = new URLResource(new URL((smilElement as SMILMediaElement).src));
					var videoElement:MediaElement = factory.createMediaElement(resource);
					var smilVideoElement:SMILMediaElement = smilElement as SMILMediaElement;
					
					if (!isNaN(smilVideoElement.clipBegin) && smilVideoElement.clipBegin > 0 &&
					    !isNaN(smilVideoElement.clipEnd) && smilVideoElement.clipEnd > 0)
					{
						var kvFacet:KeyValueFacet = new KeyValueFacet(MetadataNamespaces.SUBCLIP_METADATA);
						kvFacet.addValue(MetadataNamespaces.SUBCLIP_START_ID, smilVideoElement.clipBegin);
						kvFacet.addValue(MetadataNamespaces.SUBCLIP_END_ID, smilVideoElement.clipEnd);
						resource.metadata.addFacet(kvFacet);
					}
										
					var duration:Number = (smilElement as SMILMediaElement).duration;
					if (!isNaN(duration) && duration > 0)
					{
						(videoElement as VideoElement).defaultDuration = duration;
					}
					(parentMediaElement as CompositeElement).addChild(videoElement);
					break;
				case SMILElementType.IMAGE:
					var imageResource:URLResource = new URLResource(new URL((smilElement as SMILMediaElement).src)); 
					var imageElement:MediaElement = factory.createMediaElement(imageResource);
					var dur:Number = (smilElement as SMILMediaElement).duration;
					var durationElement:DurationElement = new DurationElement(dur, imageElement);
					(parentMediaElement as CompositeElement).addChild(durationElement);
					break;
				case SMILElementType.AUDIO:
					var audioResource:URLResource = new URLResource(new URL((smilElement as SMILMediaElement).src));
					var audioElement:MediaElement = factory.createMediaElement(audioResource);
					(parentMediaElement as CompositeElement).addChild(audioElement);
					break;
			}
			
			if (mediaElement != null)
			{
				for (var i:int = 0; i < smilElement.numChildren; i++)
				{
					var childElement:SMILElement = smilElement.getChildAt(i);
					internalCreateMediaElement(mediaElement, smilDocument, childElement);
				}
			}
			else if (mediaResource != null)
			{
				mediaElement = factory.createMediaElement(mediaResource);
			}
			
			return mediaElement;			
		}
		
		private function createDynamicStreamingResource(switchElement:SMILElement, smilDocument:SMILDocument):MediaResourceBase
		{
			var dsr:DynamicStreamingResource = null;
			var hostURL:URL;
			
			for (var i:int = 0; i < smilDocument.numElements; i++)
			{
				var smilElement:SMILElement = smilDocument.getElementAt(i);
				switch (smilElement.type)
				{
					case SMILElementType.META:
						hostURL = (smilElement as SMILMetaElement).base; 
						if (hostURL != null)
						{
							dsr = createDynamicStreamingItems(switchElement, hostURL);
						}
						break;
				}
			}	
			
			return dsr;
		}
		
		private function createDynamicStreamingItems(switchElement:SMILElement, hostURL:URL):DynamicStreamingResource
		{
			var dsr:DynamicStreamingResource = null;
			var streamItems:Vector.<DynamicStreamingItem> = new Vector.<DynamicStreamingItem>();
			
			for (var i:int = 0; i < switchElement.numChildren; i++)
			{
				var smilElement:SMILElement = switchElement.getChildAt(i);
				if (smilElement.type == SMILElementType.VIDEO)
				{
					var videoElement:SMILMediaElement = smilElement as SMILMediaElement;
					
					// We need to divide the bitrate by 1000 because the DynamicStreamingItem class 
					// requires the bitrate in kilobits per second.
					var dsi:DynamicStreamingItem = new DynamicStreamingItem(videoElement.src, videoElement.bitrate/1000);
					streamItems.push(dsi);
				}
			}
			
			if (streamItems.length)
			{
				dsr = new DynamicStreamingResource(hostURL);
				dsr.streamItems = streamItems;
			}
			
			return dsr;		
		}
		
		
		private function traceElements(smilDocument:SMILDocument):void
		{
			CONFIG::LOGGING
			{
				debugLog(">>> SMILMediaGenerator.traceElements()  ");
				
				for (var i:int = 0; i < smilDocument.numElements; i++)
				{
					var smilElement:SMILElement = smilDocument.getElementAt(i);
					traceElement(smilElement)
				}	
				
				function traceElement(e:SMILElement, level:int=0):void
				{
					var levelMarker:String = "*";
					
					for (var j:int = 0; j < level; j++)
					{
						levelMarker += "*";
					}
					
					debugLog(levelMarker + e.type);
					level++;
					
					for (var k:int = 0; k < e.numChildren; k++)
					{
						traceElement(e.getChildAt(k), level);
					}
					
					level--;
				}
			}
		}
		
		private function debugLog(msg:String):void
		{
			CONFIG::LOGGING
			{
				if (logger != null)
				{
					logger.debug(msg);
				}
			}
		}
		
		CONFIG::LOGGING
		{
			private static const logger:ILogger = org.osmf.logging.Log.getLogger("SMILParser");
		}

		private var factory:MediaFactory;		
	}
}
