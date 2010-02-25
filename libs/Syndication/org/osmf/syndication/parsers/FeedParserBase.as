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
package org.osmf.syndication.parsers
{
	import __AS3__.vec.Vector;
	
	import org.osmf.syndication.model.Feed;
	import org.osmf.syndication.model.extensions.FeedExtension;
	import org.osmf.syndication.parsers.extensions.FeedExtensionParser;
	
	/**
	 * Base class for all feed parsers.
	 **/
	public class FeedParserBase
	{
		/**
		 * Add a feed extension parser. A feed extension parser knows how to
		 * parse specific feed extension XML tags, such as
		 * the iTunes or Media RSS extensions to RSS 2.0.
		 **/
		public function addFeedExtensionParser(parser:FeedExtensionParser):void
		{
			if (_feedExtensionParsers == null)
			{
				_feedExtensionParsers = new Vector.<FeedExtensionParser>;
			} 
			
			_feedExtensionParsers.push(parser);
		}
		
		/**
		 * Get all feed extension parsers.
		 **/
		protected function getFeedExtensionParsers():Vector.<FeedExtensionParser>
		{
			return _feedExtensionParsers;
		}

		/**
		 * Override this method in a specific feed parser class.
		 **/
		public function parse(xml:XML):Feed
		{
			return null;
		}
		
		private var _feedExtensionParsers:Vector.<FeedExtensionParser>;
	}
}
