package org.osmf.drm
{
	import flash.net.drm.AuthenticationMethod;
	
	/**
	 * This class is an enumeration of the 
	 * possible values of the DRMTrait and DRMServices
	 * authenticationMethod property. 
	 */ 
	public class DRMAuthenticationMethod
	{
		/**
		 * Indicates that no authentication is required.
		 */ 		
		public static const ANONYMOUS:String = "anonymous";
		
		/**
		 * Indicates that a valid user name and password are required.
		 */ 
		public static const USERNAME_AND_PASSWORD:String = "usernameAndPassword";
	}
}