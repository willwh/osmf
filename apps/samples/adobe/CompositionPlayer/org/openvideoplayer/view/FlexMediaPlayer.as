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
package org.openvideoplayer.view
{
	import org.openvideoplayer.media.MediaPlayer;
	
	public class FlexMediaPlayer extends FlexViewableSprite
	{
		// Public Interface
		//
		
		public function get mediaPlayer():MediaPlayer
		{
			return _mediaPlayerViewableSprite.mediaPlayer;
		}
		
		// Overrides
		//
		
		private var _mediaPlayerViewableSprite:MediaPlayerViewableSprite;
		
		override protected function constructViewableSprite():ViewableSprite
		{
			var mediaPlayer:MediaPlayer = new MediaPlayer();
			_mediaPlayerViewableSprite = new MediaPlayerViewableSprite();
			_mediaPlayerViewableSprite.mediaPlayer = mediaPlayer;
			
			return _mediaPlayerViewableSprite;
		}
	}
}