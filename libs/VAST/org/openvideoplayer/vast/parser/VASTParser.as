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
	import org.openvideoplayer.vast.model.VASTDocument;
	import org.openvideoplayer.vast.model.VASTInlineAd;
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
		 * @returns The parsed document, or null if any error was
		 * encountered during the parse. 
		 */
		public function parse(xml:XML):VASTDocument 
		{
			if (xml == null)
			{
				throw new ArgumentError();
			}
			
			var vastDocument:VASTDocument = null;

			if (xml.localName() == "VideoAdServingTemplate")
			{
				vastDocument = new VASTDocument();
					
				var ads:Vector.<VASTAd> = new Vector.<VASTAd>();
				
				try 
				{
					// A VAST document can contain multiple Ad tags
					var adTags:XMLList = xml.*;
					
					for each (var adNode:XML in adTags) 
					{
						var vastAdObj:VASTAd = new VASTAd(adNode.@id);
						
						parseAdTag(adNode, vastAdObj);
						vastDocument.addAd(vastAdObj);
					}
				}
				catch(err:Error) 
				{
					CONFIG::LOGGING
					{
						logger.debug("parse() - Exception occurred : " + err.message);
					}
					vastDocument = null;
				}
			}
			return vastDocument;
		}
		
		private function parseAdTag(adNode:XML, vastAdObj:VASTAd):void 
		{
			var children:XMLList = adNode.children();
			
			for (var i:uint = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case "element":
						switch (child.localName()) 
						{
							case "InLine":
								parseInLineTag(child, vastAdObj);
								break;
							case "Wrapper":
								parseWrapperTag(child, vastAdObj);
								break;
							default:
								CONFIG::LOGGING
								{
									logger.debug("parseAdTag() - Unsupported VAST tag :"+child.localName());
								}
								break;							
						}
						break;
				}
			}
		}
		
		private function parseInLineTag(inlineNode:XML, vastAdObj:VASTAd):void 
		{
			var vastInlineObj:VASTInlineAd = new VASTInlineAd();

			vastAdObj.inlineAd = vastInlineObj;
		}
		
		private function parseWrapperTag(wrapperNode:XML, vastAdObj:VASTAd):void 
		{
			var vastWrapperObj:VASTWrapperAd = new VASTWrapperAd();

			var children:XMLList = wrapperNode.children();
			
			for (var i:uint = 0; i < children.length(); i++) 
			{
				var child:XML = children[i];
				
				switch (child.nodeKind()) 
				{
					case "element":
						switch(child.localName()) 
						{
							case "VASTAdTagURL":
								vastWrapperObj.vastAdTagURL = child.URL.toString();
								break;
						}
				}
			}

			vastAdObj.wrapperAd = vastWrapperObj;
		}
		
		CONFIG::LOGGING
		private static const logger:ILogger = Log.getLogger("VASTParser");
	}
}
