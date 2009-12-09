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
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.net.NetConnectionFactory;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.LoadTrait;
	
	/**
	 * DynamicStreamingNetLoader extends NetLoader to provide
	 * dynamic stream switching functionality. This class is
	 * "backwards compatible" meaning if it is not handed a 
	 * DynamicStreamingResource it will call the base class
	 * implementation for both <code>load</code> and <code>unload</code>
	 * methods.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class DynamicStreamingNetLoader extends NetLoader
	{
		/**
		 * Constructor.
		 * 
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function DynamicStreamingNetLoader(allowConnectionSharing:Boolean=true, factory:NetConnectionFactory=null)
		{
			super(allowConnectionSharing, factory);
		}
				
		/**
		 * Overridden to allow the creation of a DynamicNetStream object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override protected function createNetStream(connection:NetConnection, loadTrait:LoadTrait):NetStream
		{			
			return new DynamicNetStream(connection);
		}
	}
}
