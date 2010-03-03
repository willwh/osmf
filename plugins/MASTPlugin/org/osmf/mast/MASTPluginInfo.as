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
package org.osmf.mast
{
	import __AS3__.vec.Vector;
	
	import org.osmf.mast.media.MASTProxyElement;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaFactoryItemType;
	import org.osmf.net.NetLoader;
	import org.osmf.media.PluginInfo;

	/**
	 * Encapsulation of a MAST plugin.
	 **/
	public class MASTPluginInfo extends PluginInfo
	{
		// Constants for specifying the MAST document URL on the resource metadata
		public static const MAST_METADATA_NAMESPACE:String = "http://www.akamai.com/mast/1.0";
		public static const MAST_METADATA_KEY_URI:String = "uri";
		
		/**
		 * Constructor.
		 */	
		public function MASTPluginInfo()
		{		
			var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
			
			var loader:NetLoader = new NetLoader();
			var item:MediaFactoryItem = new MediaFactoryItem
				( "org.osmf.mast.MASTPluginInfo"
				, loader.canHandleResource
				, createMASTProxyElement
				, MediaFactoryItemType.PROXY
				);
			items.push(item);
			
			super(items);
		}
		
		private function createMASTProxyElement():MediaElement
		{
			return new MASTProxyElement();
		}
	}
}
