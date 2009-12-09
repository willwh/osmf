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
	/**
	 * The SwitchingDetail class contains the details for why a switch was called for by
	 * a switching rule.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class SwitchingDetail
	{
		/**
		 * Constructor.
		 * 
		 * @param detailCode The detail code for the switching detail.  Used to look up a
		 * corresponding description.  Detail codes 0-100 are reserved for use
		 * by the framework.
		 * @param moreInfo An optional string that contains more information about the
		 * switching detail.
		 **/		
		public function SwitchingDetail(detailCode:int, moreInfo:String=null)
		{
			update(detailCode, moreInfo);
		}
				
		/**
		 * The detail code for the switching detail.
		 * 
		 * <p>Framework detail codes are defined in <code>SwitchingDetailCodes</code>.
		 * </p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get detailCode():int
		{
			return _detailCode;
		}
				
		/**
		 * The description for the switching detail.
		 * 
		 * <p>Framework detail codes are defined in <code>SwitchingDetailCodes</code>.
		 * </p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * The option "more info" string contains additional information a 
		 * switching rule might want to provide about a switch, such as
		 * the number of dropped frames, current bandwidth, etc.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get moreInfo():String
		{
			return _moreInfo;
		}
		
		/**
		 * Returns a description of the switching detail for the specified switching
		 * detail code.  If the code is unknown, returns an empty string.
		 * 
		 * @param detailCode The detail code for this switching detail.
		 *
		 * @return A description of the detail with the specified detail code.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function getDescriptionForDetailCode(errorCode:int):String
		{
			return SwitchingDetailCodes.getDescriptionForSwitchingDetail(errorCode);
		}
		
		/**
		 * Allows re-use of a SwitchingDetail object. Since switching rules are checked
		 * very frequently, such as twice per second, it is more efficient for a switching
		 * rule to re-use the same SwitchingDetail object by using this method rather 
		 * than creating a new one each time.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		internal function update(detailCode:int, moreInfo:String=null):void
		{
			_detailCode = detailCode;
			_moreInfo = moreInfo;
			_description = getDescriptionForDetailCode(detailCode);			
		}
		
		private var _detailCode:int;
		private var _description:String;
		private var _moreInfo:String;

	}
}
