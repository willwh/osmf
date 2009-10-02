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
package org.osmf.composition
{
	/**
	 * An IReusable interface is designed for the reuse of some composite traits, such
	 * as CompositeBufferableTrait and CompositeAudibleTrait. In serial composition, 
	 * the state of these traits need to be carried over from the current child to the
	 * next child. IReusable signals that the composite trait has such a usage. Its client,
	 * the SerialElement for now, needs to know a composite implements this interface and
	 * reuses the composite trait as deemed appropriate.
	 * */
	internal interface IReusable
	{
		function prepare():void;
	}
}