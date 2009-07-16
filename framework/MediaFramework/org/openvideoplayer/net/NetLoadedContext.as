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
package org.openvideoplayer.net
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.openvideoplayer.traits.ILoadedContext;

    /**
	 * The NetLoadedContext contains information about the output of a load operation
	 * performed by a NetLoader. 
	 * This information is used by plugins for managing media playback 
	 * that streams from an RTMP server.
	 * 
	 * @see NetLoader 
	 */
	public class NetLoadedContext implements ILoadedContext
	{
		/**
		 *  Constructor.
		 * 	@param connection Connection created by the load operation.
		 * 	@param stream Stream created by the load operation.
		 * 	@see NetLoader#load()
		 */ 
		public function NetLoadedContext(connection:NetConnection, stream:NetStream)
		{
			_connection = connection;
			_stream = stream;
		}
		
		/**
		 * The connected NetConnection, used for streaming audio and video.
		 */

	    public function get connection():NetConnection
	    {	   	
	   		return _connection;
	   	}
	   
        /**
		 * The NetStream associated with the NetConnection, used
         * for streaming audio and video.
		 */
	    public function get stream():NetStream
	    {	   	
	   		return _stream;
	   	}

	   	private var _stream:NetStream;
	   	private var _connection:NetConnection;

	}
}