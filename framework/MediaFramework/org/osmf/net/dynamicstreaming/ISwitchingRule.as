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
	import flash.events.IEventDispatcher;

	/**
	 * ISwitchingRule defines the interface that all switching rules must implement.
	 */
	public interface ISwitchingRule
	{
		/**
		 * Returns the index value in the active <code>DynamicStreamingResource</code> to which this 
		 * heuristics implementation thinks the bitrate should shift.  It's up to the calling function 
		 * to act on this. This index will range in value from -1 to n-1,where n is the number of bitrate items available.
		 * A value of -1 means that this rule does not suggest a switch away from the current item. A
		 * value from 0 to n-1 indicates that the caller should switch to that index immediately.
		 */
        function getNewIndex():int;
		
		/**
		 * Returns the SwitchingDetail object which contains the detail for why the rule is suggesting 
		 * the new index.  
		 */
		function get detail():SwitchingDetail;		
	}
}
