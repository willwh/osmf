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
package org.osmf.net.httpstreaming
{
	import flash.utils.ByteArray;
	
	import org.osmf.net.httpstreaming.f4f.F4FConstants;
	
	public class HTTPStreamingTestsHelper
	{
		public static function createAdobeBootstrapBox(live:Boolean, update:Boolean):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			
			writeAbstAttributes(live, update, ba);
			
			return ba;
		}
		
		private static function writeAbstAttributes(live:Boolean, update:Boolean, ba:ByteArray):void
		{
			writeFullBox("abst", ba);
			// bootstrapinfo_version = 100
			ba.writeUnsignedInt(100);
			wrteAbstFlags(live, update, ba);
			// timescale is ms
			ba.writeUnsignedInt(1000);
			// current media time
			ba.writeUnsignedInt(0);
			ba.writeUnsignedInt(22000);
			// smpte time code offset
			ba.writeUnsignedInt(0);
			ba.writeUnsignedInt(0);
			// movie identifier
			ba.writeUTFBytes("movie");
			ba.writeByte(0);
				
			// server entry count
			ba.writeByte(1);
			// server base url
			ba.writeUTFBytes("http://www.httpstreaming.net/server_base_url");
			ba.writeByte(0);
			// quality entry count
			ba.writeByte(0);
			// drm data
			ba.writeUTFBytes("");
			ba.writeByte(0);
			// metadata
			ba.writeUTFBytes("");
			ba.writeByte(0);
			
			writeSegmentRuntables(ba);
			writeFragmentRuntables(ba);		
		}
		
		private static function writeSegmentRuntables(ba:ByteArray):void
		{
			// segment runtable count
			ba.writeByte(1);

			writeFullBox("asrt", ba);
			// quality entry count
			ba.writeByte(0);
			// entry count
			ba.writeUnsignedInt(1);
			// entries
			// first segment
			ba.writeUnsignedInt(1);
			// fragments per segment
			ba.writeUnsignedInt(16);
		}
		
		private static function writeFragmentRuntables(ba:ByteArray):void
		{
			// fragment runtable count
			ba.writeByte(1);
			
			writeFullBox("afrt", ba);
			// time scale ms
			ba.writeUnsignedInt(1000);
			// quality entry count
			ba.writeByte(0);
			// entry count
			ba.writeUnsignedInt(7);

			/**
			 *	Fragment runtable entries
			 *  
			 *  first_fragment		first_fragment_time_stamp		fragment_duration		discontinuity_indicator
			 *  	1					0								4000					-
			 * 		5					16000							0						1
			 * 		6					16000							0						2
			 * 		7					16000							500						-
			 * 		11					18000							0						3
			 * 		12					18000							1000					-
			 * 		16					22000							0						0 
			 */
			writeFragmentRuntableEntry(1, 0, 0, 4000, 0, ba);
			writeFragmentRuntableEntry(5, 0, 16000, 0, 1, ba);
			writeFragmentRuntableEntry(6, 0, 16000, 0, 2, ba);
			writeFragmentRuntableEntry(7, 0, 16000, 500, 0, ba);
			writeFragmentRuntableEntry(11, 0, 18000, 0, 3, ba);
			writeFragmentRuntableEntry(12, 0, 18000, 1000, 0, ba);
			writeFragmentRuntableEntry(16, 0, 22000, 0, 0, ba);
		}

		private static function writeFragmentRuntableEntry(
			firstFragment:uint, hbts:uint, lbts:uint, duration:uint, discontinuityIndicator:uint, ba:ByteArray):void
		{
			ba.writeUnsignedInt(firstFragment);				// first fragment
			ba.writeUnsignedInt(hbts);						// high 32-bit of time stamp
			ba.writeUnsignedInt(lbts);						// low 32-bit of time stamp
			ba.writeUnsignedInt(duration);					// fragment duration
			if (duration == 0)
			{ 
				ba.writeByte(discontinuityIndicator);		// discontinuity indicator
			} 
		} 
		
		private static function writeFullBox(type:String, ba:ByteArray):void
		{
			ba.writeUnsignedInt(0);
			ba.writeUTFBytes(type);
			// version = 0
			ba.writeByte(0);
			// flags= 0
			ba.writeByte(0);
			ba.writeByte(0);
			ba.writeByte(0);			
		}	
			
		private static function wrteAbstFlags(live:Boolean, update:Boolean, ba:ByteArray):void
		{
			if (live)
			{
				if (update)
				{
					ba.writeByte(0x0300);
				}
				else
				{
					ba.writeByte(0x0200);
				}
			}
			else
			{
				if (update)
				{
					ba.writeByte(0x0100);
				}
				else
				{
					ba.writeByte(0x0000);
				}
			}
		}
	}
}