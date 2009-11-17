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
	 * Base class for defining a switching rule.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class SwitchingRuleBase implements ISwitchingRule
	{
		/**
		 * Constructor.
		 * 
		 * @param metrics The INetStreamMetrics implementation the class will use.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function SwitchingRuleBase(metrics:INetStreamMetrics)
		{
			_metrics = metrics;
		}

		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function getNewIndex():int
		{
			return -1;
		}
				
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get detail():SwitchingDetail
		{
			return _detail;
		}
		
		/**
		 * Utility method for updating detail.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		protected function updateDetail(detailCode:int, moreDetail:String):void
		{
			if (_detail == null)
			{
				_detail = new SwitchingDetail(detailCode, moreDetail);
			}
			else
			{
				_detail.update(detailCode, moreDetail);
			}
		}
		
		protected function get metrics():INetStreamMetrics
		{
			return _metrics;
		}
		
		private var _metrics:INetStreamMetrics;
		private var _detail:SwitchingDetail;
	}
}
