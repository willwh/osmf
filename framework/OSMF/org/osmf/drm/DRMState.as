package org.osmf.drm
{
	/**
	 * DRMState specifies the differet states a media's DRMTRait
	 * can be in.
	 */ 
	public class DRMState
	{		
		/**
		 * The DRMTrait is preparing to use the DRM
		 * for media playback.
		 */ 
		public static const INITIALIZING:String 			= "initializing"; 
		
		/**
		 * The DRMTrait will dispatch this when a piece of media
		 * has credential based authentication.  Call authenticate()
		 * on the DRMTrait to provide authentication.
		 */ 
		public static const AUTHENTICATION_NEEDED:String	= "authenticationNeeded"; 
		
		/**
		 * The DRMTrait is authenting when the authentication 
		 * information has been recieved and the DRM subsystem
		 * is in the process of validating the credentials.  If
		 * the media is anonymously authenticated, the DRM subsystem
		 * is validating the content is still valid to play.
		 */ 
		public static const AUTHENTICATING:String	 		= "authenticating";
		
		/**
		 * The authenticated state is entered when right to
		 * play back the media have been recieved.
		 */ 
		public static const AUTHENTICATED:String			= "authenticated"; 
		
		/**
		 * 
		 */ 
		public static const AUTHENTICATE_FAILED:String		= "authenticateFailed";

	}
}