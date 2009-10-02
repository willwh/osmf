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
package
{
	import com.adobe.strobe.plugins.smil.info.SMILPluginInfo;
	import com.adobe.strobe.plugins.smil.media.SMILElement;
	import com.adobe.strobe.plugins.smil.parsing.SMILParser;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import org.osmf.plugin.IPluginInfo;

	/**
	 * This class is at the root of the plugin SWF. The property <code>pluginInfo</code> is what the Strobe
	 * framework looks for.
	 */
	public class SamplePlugin extends Sprite
	{
		/**
		 * Constructor
		 */
		public function SamplePlugin()
		{
			_smilPluginInfo = new SMILPluginInfo();
		}
		
		
		/**
		 * Property used by the Strobe framework in order to get access to the class that 
		 * implements the IPluginInfo interface
		 */
		public function get pluginInfo():IPluginInfo
		{
			return _smilPluginInfo;
		}
		
		private var _smilPluginInfo:SMILPluginInfo;

	}
}
