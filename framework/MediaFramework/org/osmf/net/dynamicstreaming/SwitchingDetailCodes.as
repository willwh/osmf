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

package org.osmf.net.dynamicstreaming
{
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * The SwitchingDetailCodes class provides static constants for switching detail codes,
	 * as well as a means for retrieving a description for a particular switching detail
	 * code.  Switching detail codes are used to describe a switch up or switch down
	 * called for by a switching rule.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */ 
	public final class SwitchingDetailCodes
	{
		public static const SWITCHING_UP_BANDWIDTH_SUFFICIENT:int			= 1;
		public static const SWITCHING_DOWN_BANDWIDTH_INSUFFICIENT:int		= 2;
		public static const SWITCHING_DOWN_BUFFER_INSUFFICIENT:int			= 3;
		public static const SWITCHING_DOWN_FRAMEDROP_UNACCEPTABLE:int		= 4;
		public static const SWITCHING_DOWN_OTHER:int						= 5;
		public static const SWITCHING_UP_OTHER:int							= 6;
		public static const SWITCHING_MANUAL:int							= 7;

		/**
		 * Returns a description of the switching detail for the specified detail code.  If
		 * the detail code is unknown, returns the empty string.
		 * 
		 * @param detailCode The code for the switching detail.
		 * 
		 * @return A description of the detail for the specified detail code.
		 **/
		public static function getDescriptionForSwitchingDetail(detailCode:int):String
		{
			var description:String = "";
			
			for (var i:int = 0; i < detailMap.length; i++)
			{
				if (detailMap[i].code == detailCode)
				{
					description = OSMFStrings.getString(detailMap[i].description);
					break;
				}
			}
			
			return description;
		}
		
		private static const detailMap:Array = 
		[
			{code:SWITCHING_UP_BANDWIDTH_SUFFICIENT,		description:OSMFStrings.SWITCHING_UP_BANDWIDTH_SUFFICIENT},
			{code:SWITCHING_DOWN_BANDWIDTH_INSUFFICIENT,	description:OSMFStrings.SWITCHING_DOWN_BANDWIDTH_INSUFFICIENT},
			{code:SWITCHING_DOWN_BUFFER_INSUFFICIENT,		description:OSMFStrings.SWITCHING_DOWN_BUFFER_INSUFFICIENT},
			{code:SWITCHING_DOWN_FRAMEDROP_UNACCEPTABLE,	description:OSMFStrings.SWITCHING_DOWN_FRAMEDROP_UNACCEPTABLE},
			{code:SWITCHING_DOWN_OTHER,						description:OSMFStrings.SWITCHING_DOWN_OTHER},
			{code:SWITCHING_UP_OTHER,						description:OSMFStrings.SWITCHING_UP_OTHER},
			{code:SWITCHING_MANUAL,							description:OSMFStrings.SWITCHING_MANUAL}
		];
	}
}
