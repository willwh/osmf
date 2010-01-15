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
	import org.osmf.composition.ParallelElement;
	import org.osmf.composition.SerialElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.smil.model.SMILDocument;
	import org.osmf.smil.model.SMILElement;
	import org.osmf.smil.model.SMILElementType;
	import org.osmf.smil.model.SMILMediaElement;
	import org.osmf.smil.model.SMILMetaElement;
	import org.osmf.utils.URL;
	import org.osmf.net.NetLoader;
	import org.osmf.video.VideoElement;
	import org.osmf.net.dynamicstreaming.*;
	import org.osmf.media.*;
	
	/**
	 * A utility class for creating MediaElements from a <code>SMILDocument</code>.
	 */
	public class SMILMediaGenerator implements ISMILMediaGenerator
	{
		/**
		 * Creates the relevant MediaElement from the SMILDocument.
		 * 
		 * @param smilDocument The SMILDocument to use for media creation.
		 * @returns A new MediaElement based on the information found in the SMILDocument.
		 */
		public function createMediaElement(smilDocument:SMILDocument, factory:MediaFactory):MediaElement
		{
			var mediaResource:MediaResourceBase = null;
			
			if (DEBUG)
			{
				traceElements(smilDocument);
			}
			
			var mediaElement:MediaElement;
			
			for (var i:int = 0; i < smilDocument.numElements; i++)
			{
				var smilElement:SMILElement = smilDocument.getElementAt(i);
				switch (smilElement.type)
				{
					case SMILElementType.SWITCH:
						mediaResource = createDynamicStreamingResource(smilElement, smilDocument);
						break;
					case SMILElementType.PARALLEL:
						mediaElement = createParallelElement(smilElement);
						break;
					case SMILElementType.SEQUENCE:
						mediaElement = createSerialElement(smilElement);
						break;
				}
			}

			if (mediaElement == null)
			{
				mediaElement = factory.createMediaElement(mediaResource);
			}
			
			return mediaElement;
		}
		
		private function createSerialElement(parent:SMILElement):MediaElement
		{
			var serialElement:SerialElement = new SerialElement();
			
			for (var i:int = 0; i < parent.numChildren; i++)
			{
				var smilElement:SMILElement = parent.getChildAt(i);
				switch (smilElement.type)
				{
					case SMILElementType.VIDEO:
						var videoElement:VideoElement = new VideoElement(new NetLoader());
						var resource:URLResource = new URLResource(new URL((smilElement as SMILMediaElement).src));
						videoElement.resource = resource;
						serialElement.addChild(videoElement);
						break;
				}
			}
			
			return serialElement;
		}
		
		private function createParallelElement(parent:SMILElement):MediaElement
		{
			var parallelElement:ParallelElement = new ParallelElement();
			
			for (var i:int = 0; i < parent.numChildren; i++)
			{
				var smilElement:SMILElement = parent.getChildAt(i);
				switch (smilElement.type)
				{
					case SMILElementType.VIDEO:
						var videoElement:VideoElement = new VideoElement(new NetLoader());
						var resource:URLResource = new URLResource(new URL((smilElement as SMILMediaElement).src));
						videoElement.resource = resource;
						parallelElement.addChild(videoElement);
						break;
				}
			}
			
			return parallelElement;
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
					var dsi:DynamicStreamingItem = new DynamicStreamingItem(videoElement.src, videoElement.bitrate);
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
			if (DEBUG)
			{
				trace(">>> SMILMediaGenerator.traceElements()  ");
				for (var i:int = 0; i < smilDocument.numElements; i++)
				{
					var smilElement:SMILElement = smilDocument.getElementAt(i);
					traceElement(smilElement)
				}	
				
				function traceElement(e:SMILElement, level:int=0):void
				{
					trace("     level: "+level+" element type = " + e.type);
					level++;
					for (var j:int = 0; j < e.numChildren; j++)
					{
						traceElement(e.getChildAt(j), level);
					}
					level--;
				}
			}
		}
		
		private static const DEBUG:Boolean = true;		
	}
}
