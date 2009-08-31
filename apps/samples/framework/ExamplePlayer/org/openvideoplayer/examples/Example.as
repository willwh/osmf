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
package org.openvideoplayer.examples
{
	import org.openvideoplayer.media.MediaElement;
	
	/**
	 * Encapsulation of an example MediaElement.
	 **/
	public class Example
	{
		/**
		 * Constructor.
		 **/
		public function Example(name:String, description:String, mediaElementCreatorFunc:Function)
		{
			_name = name;
			_description = description;
			_mediaElementCreatorFunc = mediaElementCreatorFunc;
		}
		
		/**
		 * A human-readable name for the example.
		 **/
		public function get name():String
		{
			return _name;
		}

		/**
		 * A description explaining what the example demonstrates.
		 **/
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * The MediaElement that this example demonstrates.
		 **/
		public function get mediaElement():MediaElement
		{
			return _mediaElementCreatorFunc.apply(this) as MediaElement;
		}
		
		private var _name:String;
		private var _description:String;
		private var _mediaElementCreatorFunc:Function;
	}
}