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

package org.osmf.chrome.fonts
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Fonts
	{
		/**
		 * The free 'type writer' font is a bitmap font that fits the default
		 * chrome design nicely. It can be downloaded from:
		 *
		 * http://fontstruct.fontshop.com/fontstructions/show/212255
		 *
		 * Once the font (type_writer.ttf) is embedded in a SWF (by placing
		 * it in a Flash Authoring project's Library, and marking it for
		 * export, as 'TypeWriterFont'), then uncomment the commented lines for
		 * the font to get used on the UI:
		 */
		 		
		/*
		//[Embed(source="../assets/fonts/type_writer.ttf", fontName="Type Writer Regular", mimeType="application/x-font-truetype")]
		[Embed(source="../assets/fonts/TypeWriterFont.swf#TypeWriterFont")]
		private static var TYPE_WRITER:Class;
		*/
		
		public static function defaultTextFormat():TextFormat
		{
			var result:TextFormat
				= new TextFormat
					( ""
					, 11
					, 0xFFFFFF
					);
			
			/*
			result
				= new TextFormat
					( new TYPE_WRITER().fontName
					, 8
					, 0xffffff
					);
			
			*/
			
			return result; 
		}
		
		public static function getDefaultTextField():TextField
		{
			var result:TextField = new TextField();
			result.defaultTextFormat = defaultTextFormat();
			result.selectable = false;
			
			// Uncomment on using embedded font:
			// result.embedFonts = true;
			
			return result;
		}
	}
}