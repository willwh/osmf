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
*  Contributor(s): Adobe Systems Inc.
*   
*****************************************************/
package org.openvideoplayer.vast.parser
{
	import __AS3__.vec.Vector;
	
	import org.openvideoplayer.logging.ILogger;
	import org.openvideoplayer.logging.Log;
	import org.openvideoplayer.vast.model.VASTAd;
	import org.openvideoplayer.vast.model.VASTAdBase;
	import org.openvideoplayer.vast.model.VASTAdPackageBase;
	import org.openvideoplayer.vast.model.VASTCompanionAd;
	import org.openvideoplayer.vast.model.VASTDocument;
	import org.openvideoplayer.vast.model.VASTInlineAd;
	import org.openvideoplayer.vast.model.VASTNonLinearAd;
	import org.openvideoplayer.vast.model.VASTTrackingEvent;
	import org.openvideoplayer.vast.model.VASTTrackingEventType;
	import org.openvideoplayer.vast.model.VASTUrl;
	import org.openvideoplayer.vast.model.VASTVideoClick;
	import org.openvideoplayer.vast.model.VASTWrapperAd;

	/**
	 * This class parses a VAST document into a VAST object model.
	 */
	public class VASTParser
	{		
		/**
		 * Constructor.
		 */
		public function VASTParser()
		{
			super();
		}
		
		/**
		 * A synchronous method to parse the raw VAST XML data into a VAST
		 * object model.
		 * 
		 * @throws ArgumentError If xml is null.
		 * 
		 * @returns The parsed document, or null if any error was encountered
		 * during the parse. 
		 */
		public function parse(xml:XML):VASTDocument 
		{
			if (xml == null)
			{
				throw new ArgumentError();
			}
			
			var vastDocument:VASTDocument = null;

			if (xml.localName() == ROOT_TAG)
			{
				vastDocument = new VASTDocument();
					
				try 
				{
					for (var i:int = 0; i < xml.Ad.length(); i++)
					{
						var adXML:XML = xml.Ad[i];
						
						var id:String = parseAttributeAsString(adXML, "id");
						var vastAd:VASTAd = new VASTAd(id);
						parseAdTag(adXML, vastAd);
						vastDocument.addAd(vastAd);
					}
				}
				catch (error:Error) 
				{
					CONFIG::LOGGING
					{
						logger.debug("Exception during parsing: " + error.message);
					}
					vastDocument = null;
				}
			}
			
			return vastDocument;
		}
		
		private function parseAdTag(xml:XML, vastAd:VASTAd):void 
		{
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch (child.localName()) 
						{
							case INLINE:
								parseInLineTag(child, vastAd);
								break;
							case WRAPPER:
								parseWrapperTag(child, vastAd);
								break;
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseAdTag() - Unsupported VAST tag: " + child.localName());
								}
								break;							
						}
						break;
				}
			}
		}
		
		private function parseInLineTag(xml:XML, vastAd:VASTAd):void 
		{
			var vastInlineAd:VASTInlineAd = new VASTInlineAd();
			
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch (child.localName()) 
						{
							case AD_SYSTEM:
								vastInlineAd.adSystem = child.toString();
								break;
							case AD_TITLE:
								vastInlineAd.adTitle = child.toString();
								break;
							case DESCRIPTION:
								vastInlineAd.description = child.toString();
								break;
							case SURVEY:
								vastInlineAd.surveyURL = parseURL(child);
								break;
							case ERROR:
								vastInlineAd.errorURL = parseURL(child);
								break;
							case IMPRESSION:
								parseImpressionTag(child, vastInlineAd);
								break;
							case TRACKING_EVENTS:
								parseTrackingEvents(child, vastInlineAd);
								break;
							case VIDEO:
								// TODO
								//parseVideo(child, vastInlineAd);
								break;
							case COMPANION_ADS:
								parseInlineCompanionAds(child, vastInlineAd);
								break;
							case NON_LINEAR_ADS:
								parseInlineNonLinearAds(child, vastInlineAd);
								break;
							case EXTENSIONS:
								parseExtensions(child, vastInlineAd);
								break;
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseInlineTag() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}

			vastAd.inlineAd = vastInlineAd;
		}
		
		private function parseWrapperTag(xml:XML, vastAd:VASTAd):void 
		{
			var vastWrapperAd:VASTWrapperAd = new VASTWrapperAd();

			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch (child.localName()) 
						{
							case AD_SYSTEM:
								vastWrapperAd.adSystem = child.toString();
								break;
							case VAST_AD_TAG_URL:
								vastWrapperAd.vastAdTagURL = parseURL(child);
								break;
							case COMPANION_ADS:
								parseWrapperCompanionAds(child, vastWrapperAd);
								break;
							case NON_LINEAR_ADS:
								parseWrapperNonLinearAds(child, vastWrapperAd);
								break;
							case ERROR:
								vastWrapperAd.errorURL = parseURL(child);
								break;
							case IMPRESSION:
								parseImpressionTag(child, vastWrapperAd);
								break;
							case TRACKING_EVENTS:
								parseTrackingEvents(child, vastWrapperAd);
								break;
							case VIDEO_CLICKS:
								parseVideoClicks(child, vastWrapperAd);
								break;
							case EXTENSIONS:
								parseExtensions(child, vastWrapperAd);
								break;
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseWrapperTag() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}

			vastAd.wrapperAd = vastWrapperAd;
		}
		
		private function parseImpressionTag(xml:XML, vastAdPackage:VASTAdPackageBase):void 
		{
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case URL:
								vastAdPackage.addImpression(parseVASTUrl(child));
								break;
						}
						break;
				}
			}
		}
				
		private function parseTrackingEvents(xml:XML, vastAdPackage:VASTAdPackageBase):void 
		{
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case TRACKING:
							{
								var eventType:String = parseAttributeAsString(child, "event");
								var trackingEvent:VASTTrackingEvent =
									new VASTTrackingEvent
										(VASTTrackingEventType.fromString(eventType)
										);
								var trackingURLs:Vector.<VASTUrl> = parseURLTags(child);
									
								if (trackingURLs.length > 0 &&
									trackingEvent.type != null) 
								{
									trackingEvent.urls = trackingURLs;
									vastAdPackage.addTrackingEvent(trackingEvent);
								}
								break;
							}
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseTrackingEvents() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}
		}
		
		private function parseURLTags(xml:XML, maxNumURLs:int=-1):Vector.<VASTUrl> 
		{
			var urls:Vector.<VASTUrl> = new Vector.<VASTUrl>;
			
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				// Stop when we hit the maximum allowed number (if we have one).
				if (maxNumURLs >= 0 &&
					urls.length >= maxNumURLs)
				{
					break;
				}
				
				switch(child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch (child.localName()) 
						{
							case URL:
							{
								urls.push(parseVASTUrl(child));
								break;
							}
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseURLTags() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}
			return urls;
		}
		
		private function parseInlineCompanionAds(xml:XML, vastInlineAd:VASTInlineAd):void 
		{
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case COMPANION:
							{
								parseInlineCompanionAd(child, vastInlineAd);								
								break;
							}
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseInlineCompanionAds() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}
		}

		private function parseInlineCompanionAd(xml:XML, vastInlineAd:VASTInlineAd):void 
		{
			var companionAd:VASTCompanionAd = new VASTCompanionAd();
			parseAdBase(xml, companionAd);
			
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case ALT_TEXT:
								companionAd.altText = child.toString();
								break;
							case COMPANION_CLICK_THROUGH:
								companionAd.clickThroughURL = parseURL(child);
								break;
						}
						break;
				}
			}
			
			vastInlineAd.addCompanionAd(companionAd);
		}
		
		private function parseWrapperCompanionAds(xml:XML, vastWrapperAd:VASTWrapperAd):void 
		{
			var children:XMLList = xml.children();
			
			if (children.length() > 0) 
			{
				var child:XML = children[0];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case COMPANION_IMPRESSION:
							{
								vastWrapperAd.companionImpressions = parseURLTags(child);
								break;
							}
							case COMPANION_AD_TAG:
							{
								var urls:Vector.<VASTUrl> = parseURLTags(child, 1);
								if (urls.length > 0)
								{
									vastWrapperAd.companionAdTag = urls[0];
								}
								break;
							}
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseWrapperCompanionAds() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}
		}
		
		private function parseWrapperNonLinearAds(xml:XML, vastWrapperAd:VASTWrapperAd):void 
		{
			var children:XMLList = xml.children();
			
			if (children.length() > 0) 
			{
				var child:XML = children[0];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case NON_LINEAR_IMPRESSION:
							{
								vastWrapperAd.nonLinearImpressions = parseURLTags(child);
								break;
							}
							case NON_LINEAR_AD_TAG:
							{
								var urls:Vector.<VASTUrl> = parseURLTags(child, 1);
								if (urls.length > 0)
								{
									vastWrapperAd.nonLinearAdTag = urls[0];
								}
								break;
							}
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseWrapperNonLinearAds() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}
		}
		
		private function parseInlineNonLinearAds(xml:XML, vastInlineAd:VASTInlineAd):void 
		{
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case NON_LINEAR:
							{
								parseInlineNonLinearAd(child, vastInlineAd);								
								break;
							}
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseInlineNonLinearAds() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}
		}
		
		private function parseInlineNonLinearAd(xml:XML, vastInlineAd:VASTInlineAd):void 
		{
			var nonLinearAd:VASTNonLinearAd = new VASTNonLinearAd();
			parseAdBase(xml, nonLinearAd);

			nonLinearAd.scalable 			= parseAttributeAsBoolean(xml, "scalable")
			nonLinearAd.maintainAspectRatio = parseAttributeAsBoolean(xml, "maintainAspectRatio");
			nonLinearAd.apiFramework 		= parseAttributeAsString (xml, "apiFramework");
			
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case NON_LINEAR_CLICK_THROUGH:
								nonLinearAd.clickThroughURL = parseURL(child);
								break;
						}
						break;
				}
			}
			
			vastInlineAd.addNonLinearAd(nonLinearAd);
		}

		private function parseAdBase(xml:XML, vastAdBase:VASTAdBase):void
		{
			var children:XMLList = xml.children();
			
			vastAdBase.id 				= parseAttributeAsString(xml, "id");
			vastAdBase.width 			= parseAttributeAsInt	(xml, "width");
			vastAdBase.height 			= parseAttributeAsInt	(xml, "height");
			vastAdBase.expandedWidth 	= parseAttributeAsInt	(xml, "expandedWidth");
			vastAdBase.expandedHeight 	= parseAttributeAsInt	(xml, "expandedHeight");
			vastAdBase.resourceType 	= parseAttributeAsString(xml, "resourceType");
			vastAdBase.creativeType 	= parseAttributeAsString(xml, "creativeType");

			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case URL:
								vastAdBase.url = parseURL(child);
								break;
							case CODE:
								vastAdBase.code = child.toString();
								break;
							case AD_PARAMETERS:
								vastAdBase.adParameters = child.toString();
								break;
						}
						break;
				}
			}
		}

		private function parseExtensions(xml:XML, vastAdPackage:VASTAdPackageBase):void 
		{
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case EXTENSION:
								vastAdPackage.addExtension(child);
								break;
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseExtensions() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}
		}
		
		private function parseVideoClicks(xml:XML, vastAdPackage:VASTWrapperAd):void
		{
			var videoClick:VASTVideoClick = new VASTVideoClick();
			
			var children:XMLList = xml.children();
			
			for (var i:int = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case NODEKIND_ELEMENT:
						switch(child.localName()) 
						{
							case CLICK_THROUGH:
							{
								var urls:Vector.<VASTUrl> = parseURLTags(child, 1);
								if (urls.length > 0)
								{
									videoClick.clickThrough = urls[0];
								}
								break;
							}
							case CLICK_TRACKING:
							{
								videoClick.clickTrackings = parseURLTags(child);
								break;
							}
							case CUSTOM_CLICK:
							{
								videoClick.customClicks = parseURLTags(child);
								break;
							}
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseVideoClicks() - Unsupported VAST tag: " + child.localName());
								}
								break;								
						}
						break;
				}
			}
			
			vastAdPackage.videoClick = videoClick;
		}

		private function parseVASTUrl(xml:XML):VASTUrl
		{
			return new VASTUrl(parseURL(xml), parseAttributeAsString(xml, "id"));
		}
		
		private function parseURL(node:XML):String
		{
			var child:String = node.children()[0];
			
			// Strip all leading and trailing whitespace.
			return child != null ? child.replace(/^\s*|\s*$/g, "") : child;
		}

		private function parseAttributeAsString(xml:XML, attribute:String):String
		{
			if (xml.@[attribute].length() > 0)
			{
				return xml.@[attribute];
			}
			
			return null;
		}
		
		private function parseAttributeAsBoolean(xml:XML, attribute:String):Boolean
		{
			return xml.@[attribute] == "true";
		}

		private function parseAttributeAsInt(xml:XML, attribute:String):int
		{
			return xml.@[attribute];
		}

		private static const NODEKIND_ELEMENT:String = "element";
				
		private static const ROOT_TAG:String 					= "VideoAdServingTemplate";
		private static const INLINE:String 						= "InLine";
		private static const WRAPPER:String 					= "Wrapper";
		private static const AD_SYSTEM:String 					= "AdSystem";
		private static const AD_TITLE:String 					= "AdTitle";
		private static const DESCRIPTION:String 				= "Description";
		private static const SURVEY:String 						= "Survey";
		private static const ERROR:String 						= "Error";
		private static const VAST_AD_TAG_URL:String 			= "VASTAdTagURL";
		private static const IMPRESSION:String 					= "Impression";
		private static const TRACKING_EVENTS:String 			= "TrackingEvents";
		private static const TRACKING:String 					= "Tracking";
		private static const URL:String 						= "URL";
		private static const CODE:String 						= "Code";
		private static const VIDEO:String 						= "Video";
		private static const VIDEO_CLICKS:String 				= "VideoClicks";
		private static const CLICK_TRACKING:String 				= "ClickTracking";
		private static const CLICK_THROUGH:String 				= "ClickThrough";
		private static const CUSTOM_CLICK:String 				= "CustomClick";
		private static const COMPANION_ADS:String 				= "CompanionAds";
		private static const COMPANION:String 					= "Companion";
		private static const COMPANION_CLICK_THROUGH:String 	= "CompanionClickThrough";
		private static const COMPANION_IMPRESSION:String		= "CompanionImpression";
		private static const COMPANION_AD_TAG:String			= "CompanionAdTag";
		private static const ALT_TEXT:String 					= "AltText";
		private static const AD_PARAMETERS:String 				= "AdParameters";
		private static const NON_LINEAR_ADS:String 				= "NonLinearAds";
		private static const NON_LINEAR:String 					= "NonLinear";
		private static const NON_LINEAR_CLICK_THROUGH:String 	= "NonLinearClickThrough";
		private static const NON_LINEAR_IMPRESSION:String		= "NonLinearImpression";
		private static const NON_LINEAR_AD_TAG:String			= "NonLinearAdTag";
		private static const EXTENSIONS:String 					= "Extensions";
		private static const EXTENSION:String 					= "Extension";

		CONFIG::LOGGING
		private static const logger:ILogger = Log.getLogger("VASTParser");
	}
}
