/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.version
{
	/**
	 * Class that contains Strobe version information. There are three fields:
	 * major, minor and changelist. The version comparison rules are
	 * as follows, assume there are v1 and v2:
	 * <listing>
	 * v1 &#62; v2, if ((v1.major &#62; v2.major) || 
	 *              (v1.major == v2.major &#38;&#38; v1.minor &#62; v2.minor) || 
	 *              (v1.major == v2.major &#38;&#38; v1.minor == v2.minor &#38;&#38; 
	 *               v1.changelist &#62; v2.changelist)) 
	 * 
	 * v1 = v2, if (v1.major == v2.major &#38;&#38; 
	 *              v1.minor == v2.minor &#38;&#38; 
	 *              v1.changelist == v2.changelist) 
	 * 
	 * v1 &#60; v2 //otherwise
	 * </listing>
	 **/
	public class Version
	{
		/**
		 * returns the version string in the format of 
		 * 	[major][FIELD_SEPARATOR][minor][FIELD_SEPARATOR][changelist]
		 **/
		public static function version():String
		{
			return _major + FIELD_SEPARATOR + _minor + FIELD_SEPARATOR + _changelist;
		}
				
		/**
		 * The actual string values of major, minor and changelist will be
		 * dynamically generated at build time.
		 **/
		private static const _major:String = "-9999";
		private static const _minor:String = "-9998";
		private static const _changelist:String = "-9997";	
		
		private static const FIELD_SEPARATOR:String = ".";	
	}
}