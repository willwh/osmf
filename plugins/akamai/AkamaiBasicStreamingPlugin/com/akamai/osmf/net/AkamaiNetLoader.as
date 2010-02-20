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

package com.akamai.osmf.net
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.media.URLResource;
	import org.osmf.net.NetConnectionFactoryBase;
	import org.osmf.net.NetLoader;

	/**
	 * The AkamaiNetLoader class provides the means for
	 * creating a custom <code>NetStream</code> class, 
	 * in this case, an <code>AkamaiNetStream</code>.
	 * 
	 * @see AkamaiNetStream
	 */ 
	public class AkamaiNetLoader extends NetLoader
	{
		/**
		 * @inheritDoc
		 */
		public function AkamaiNetLoader(factory:NetConnectionFactoryBase)
		{
			super(factory);
		}

		/**
		 * @inheritDoc
		**/
		override protected function createNetStream(connection:NetConnection, resource:URLResource):NetStream
		{
			var ns:AkamaiNetStream =  new AkamaiNetStream(connection, resource);
			
			return ns;
		}
	}
}
