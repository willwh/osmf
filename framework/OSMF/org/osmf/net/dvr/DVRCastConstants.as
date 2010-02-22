/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.net.dvr
{
	import org.osmf.metadata.FacetKey;
	
	/**
	 * @private
	 * 
	 * Defines DVRCast related constants values
	 */	
	internal class DVRCastConstants
	{
		public static const KEY_STREAM_INFO:FacetKey				= new FacetKey("streamInfo");
		public static const KEY_RECORDING_INFO:FacetKey				= new FacetKey("recordingInfo");
		
		public static const RPC_GET_STREAM_INFO:String				= "DVRGetStreamInfo";
		public static const RPC_SUBSCRIBE:String 					= "DVRSubscribe";
		public static const RPC_UNSUBSCRIBE:String 					= "DVRUnsubscribe";
		
		public static const RESULT_GET_STREAM_INFO_SUCCESS:String	="NetStream.DVRStreamInfo.Success";
		public static const RESULT_GET_STREAM_INFO_RETRY:String		="NetStream.DVRStreamInfo.Retry";
		
		public static const STREAM_INFO_UPDATE_DELAY:Number 		= 3000;
		public static const LOCAL_DURATION_UPDATE_INTERVAL:Number 	= 500;
	}
}