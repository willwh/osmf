package org.osmf.chrome.fonts
{
	import flash.text.TextFormat;
	
	public class Fonts
	{
		/**
		 * The free 'type writer' font is a bitmap font that fits the default
		 * chrome design nicely. It can be downloaded from:
		 *
		 * http://fontstruct.fontshop.com/fontstructions/show/212255
		 *
		 * Once the font (type_writer.ttf) is placed in ../assets/fonts, then
		 * uncomment the commented lines for the font to get used on the UI:
		 */
		 		
		/*
		[Embed(source="../assets/fonts/type_writer.ttf", fontName="Type Writer Regular", mimeType="application/x-font-truetype")]
		private static var TYPE_WRITER:String;
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
					( "Type Writer Regular"
					, 8
					, 0xFFFFFF
					);
			*/
			
			return result; 
		}

	}
}