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
package org.osmf.gateways
{
	import flash.errors.IllegalOperationError;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import org.osmf.external.HTMLElement;
	import org.osmf.media.IMediaContainer;
	import org.osmf.media.MediaElement;
	import org.osmf.proxies.ProxyElement;
	import org.osmf.traits.*;
	import org.osmf.utils.OSMFStrings;

	/**
	 * HTMLGateway is an IMediaContainer implementing class that uses the ExternalConnection
	 * to expose the gateway's child media elements to JavaScript.
	 */	
	public class HTMLGateway implements IMediaContainer
	{
		// IContainerGateway
		//

		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function addMediaElement(child:MediaElement):MediaElement
		{
			requireExternalInterface;
			
			if (child == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			// Find out if the element at hand is an HTML element or not:
			var htmlElement:HTMLElement = elementAsHTMLElement(child);
			
			if (htmlElement == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.UNSUPPORTED_MEDIA_ELEMENT_TYPE))
			}
			
			var result:MediaElement;
			
			var elementId:String = "element_" + elementIdCounter++;
			var elementScriptPath:String = gatewayScriptPath + "elements." + elementId + "."; 
			
			elements[elementId] = child;
			
			htmlElement.scriptPath = elementScriptPath; 
			
			ExternalInterface.call(gatewayScriptPath + "__addElement__", elementId);
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function removeMediaElement(child:MediaElement):MediaElement
		{
			requireExternalInterface;
			
			if (child == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			var elementId:String = getElementId(child);
			if (elementId == null)
			{
				throw new IllegalOperationError("Element is not a child element");
			}
			
			delete elements[elementId];
			
			ExternalInterface.call
				( gatewayScriptPath + "__removeElement__"
				, elementId
				);
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function containsMediaElement(child:MediaElement):Boolean
		{
			for each (var element:HTMLElement in elements)
			{
				if (element == child)
				{
					return true;
				}
			}
			return false;
		}
		
		// Public API
		//
		
		/**
		 * Initializes the HTMLGateway. Injects the components JavaScript API into the
		 * hosting page.
		 * 
		 * @param gatewayIdentifier The identifier that will be used for this gateway
		 * in JavaScript. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function initialize(gatewayIdentifier:String):void
		{
			requireExternalInterface;
			
			this.gatewayIdentifier = gatewayIdentifier;
			gatewayScriptPath 
				= "document.osmf.gateways."
				+ ExternalInterface.objectID
				+ "_"
				+ gatewayIdentifier + ".";
			
			ExternalInterface.marshallExceptions = true;
			ExternalInterface.addCallback("osmf_getProperty", getPropertyCallback);
			ExternalInterface.addCallback("osmf_setProperty", setPropertyCallback);
			ExternalInterface.addCallback("osmf_invoke", invokeCallback);
			
			ExternalInterface.call
				( registerGateway_js
				, ExternalInterface.objectID, gatewayIdentifier
				);
		}
		
		// Internals
		//
		
		private var elements:Dictionary = new Dictionary();
		private var elementIdCounter:int = 0;
		
		private var gatewayIdentifier:String;
		private var gatewayScriptPath:String;
		
		private function get requireExternalInterface():*
		{
			if (ExternalInterface.available == false)
			{
				throw new IllegalOperationError("No ExternalInterface available");
			}
			
			return undefined;
		}
		
		private function getElementId(element:MediaElement):String
		{
			var result:String;
			
			for (var index:String in elements)
			{
				if (elements[index] == element)
				{
					result = index;
					break;
				} 
			}
			
			return result;
		}
		
		private function getPropertyCallback(elementId:String, property:String):*
		{
			var result:*;
			
			var element:HTMLElement = elements[elementId];
			if (element)
			{
				result = element.getPropertyCallback(property);
			}
			
			return result;
		}
		
		private function setPropertyCallback(elementId:String, property:String, value:*):void
		{
			var element:HTMLElement = elements[elementId] as HTMLElement;
			if (element)
			{
				element.setPropertyCallback(property, value);
			}
		}
		
		private function invokeCallback(elementId:String, method:String, args:Array):*
		{
			var result:*;
			
			if (elementId == null)
			{
				switch (method)
				{
					// Gateway
					case "trace":
						if (args.length)
						{
							trace("JavaScript says:", args[0]);
						}
						break;
					default:
						throw new IllegalOperationError
							( "Method '"
							+ method
							+ "' invoked from JavaScript is not supported on a Gateway."
							);
						break;
				}
			}
			else
			{
				var element:MediaElement = elements[elementId];
				if (element)
				{
					switch (method)
					{
						// Currently no methods...
						default:
							throw new IllegalOperationError
								( "Method '"
								+ method 
								+ "' invoked from JavaScript is not supported on a MediaElement."
								);
							break;
					}
				}
				else
				{
					throw new IllegalOperationError
						( "Unable to resolve the element with identifier '"
						+ elementId
						+ "' on invoking the '"
						+ method
						+ "' method from JavaScript."
						);
				}
			}
			
			return result;
		}
		
		// Utils
		//
		
		private static function elementAsHTMLElement(element:MediaElement):HTMLElement
		{
			var result:HTMLElement;
			
			if (element != null)
			{
				if (element is ProxyElement)
				{
					return arguments.callee(ProxyElement(element).wrappedElement)
				}
				else
				{
					result = element as HTMLElement;	
				}
			}
			
			return result;
		}
				
        // JavaScript API
        //
        
        private static const utils_js:XML =
        	<![CDATA[
        	function addGetter(element, property)
        	{
        		element["get" + property]
        			= function()
        				{ 
        					return element
	        					.__gateway__
	        					.__flashObject__
	        					.osmf_getProperty(element.elementId, property);
        				}
        	}
        	
        	function addSetter(element, property)
        	{
        		element["set" + property]
        			= function(value)
        				{ 
        					return element
	        					.__gateway__
	        					.__flashObject__
	        					.osmf_setProperty(element.elementId, property, value);
        				}
        	}
        	
        	function addGetSet(element, property)
        	{
        		addGetter(element, property);
        		addSetter(element, property);
        	}
        	
        	// Adds an in between function that the Flash side can invoke
        	// on signaling an event:
        	function addCallback(element, method, numArguments)
        	{
        		element["__"+method+"__"] = function()
        		{
        			var result;
        			var callback = element[method];
        			if (callback && callback.length == numArguments)
        			{
        				result = callback.apply(element, arguments) || true;
        			}
        			return result;
        		}
        	}
        	
        	// Adds a method that the JavaScript side can invoke on the 
        	// Flash side:
        	function addMethod(element, method)
        	{
        		element[method] = function()
        		{
        			element.gateway.__flashObject__.osmf_invoke
    					( element.elementId
    					, method
    					, arguments.length ? arguments : []
    					);
        		}
        	}
        	
        	]]>;
        	
        private static const constants_js:XML =
        	<![CDATA[
        	function Constants()
        	{
        		this.loadState =
        			{ UNINITIALIZED: "uninitialized"
        			, LOADING: "loading"
        			, READY: "ready"
        			, UNLOADING: "unloading"
        			, LOAD_ERROR: "loadError"
        			};
        			
        		this.playState =
        			{ PLAYING: "playing"
        			, PAUSED: "paused"
        			, STOPPED: "stopped"
        			};
        	}
        	]]>;
        
        // Defines the JS Gateway class:
		private static const gateway_js:XML =
			<![CDATA[
			function Gateway(objectId, gatewayId)
        	{
        		this.gatewayId = gatewayId;
        		
        		this.__flashObject__ = document.getElementById(objectId);
        		
        		this.__addElement__ = function(elementId)
        		{
        			this.elements = this.elements || new Object();
        			
        			var element = new MediaElement(this, elementId);
        			this.elements[elementId] = element;
        			
        			if	(	this["onElementAdd"] != null
        				&&	this.onElementAdd.length == 1
        				)
        			{
        				this.onElementAdd(element);
        			}
        		}
        		
        		this.__removeElement__ = function(elementId)
        		{
        			var element = this.elements[elementId];
        			if (element == null)
        			{
        				throw "Gateway doesn not contain the specified element ("
        					+ elementId
        					+ ")";
        			}
        			
        			delete this.elements[elementId];
        			
        			if	(	this["onElementRemove"] != null
        				&&	this.onElementRemove.length == 1
        				)
        			{
        				this.onElementRemove(element);
        			}
        		}
        	}
        	]]>;
        
        // Defines the JS MediaElement class:
        private static const mediaElement_js:XML =
        	<![CDATA[
        	function MediaElement(gateway, elementId)
        	{
        		this.elementId = elementId;
        		this.__gateway__ = gateway;
        		
        		// MediaElement core properties:
        		
        		addGetter(this, "resource");
        		
        		// LoadTrait bridge: (all HTML elements are loadable)
        		
        		addSetter	(this, 	"LoadState");
        		addCallback	(this, 	"load", 1);					// urlResource
        		addCallback	(this, 	"unload", 0); 
        		
				// PlayTrait bridge:
				addGetSet	(this,	"Playable");
				addGetSet	(this, 	"CanPause");
				addGetSet	(this,	"PlayState");
				addCallback (this,	"onPlayStateChange", 1);	// newPlayState string
				
        		// TimeTrait bridge:
        		addGetSet	(this,	"Temporal");
        		addGetSet	(this,	"Duration");
        		addGetSet	(this,	"CurrentTime");
        		
        		// AudioTrait bridge:
        		
        		addGetSet	(this,	"Audible");			
        		addGetSet	(this,	"Volume");
        		addCallback	(this,	"onVolumeChange", 1);		// volume;
        		addGetSet	(this,	"Muted");
        		addCallback	(this,	"onMutedChange", 1);		// muted;
        		addGetSet	(this,	"Pan");
        		addCallback	(this,	"onPanChange", 1);			// pan;
        	}
        	]]>;
        	
        // Defines the logic that sets up the document.osmf object, adding a gateway:
        private static const registrationLogic_js:XML =
        	<![CDATA[
        	// Get a reference to, or otherwise construct, the document.osmf.gateways path:
            var osmf 
        		= document.osmf
        		= document.osmf || {};
        		
        	osmf.constants
        		= osmf.constants || new Constants();
        		
        	var gateways
        		= osmf.gateways
        		= osmf.gateways || {};
        
        	// For debugging, provide a 'trace' function on: it will
        	// forward the message to Flash:
        	
        	if (osmf.trace == null)
        	{
        		osmf.trace = function(message)
        		{
        			document
        				.getElementById(objectId)
        				.osmf_invoke(null, "trace", [message]);
        		}
        	}
	        	
        	// See if the gateway with the specified name has been registered:
        	
        	var identifier = objectId + "_" + gatewayId;
        	
        	if (gateways[identifier] != null)
        	{
        		throw "A gateway by the name of "+identifier+" has already been registered."
        	}
        	else
        	{
        		var gateway
        			= gateways[identifier]
        			= new Gateway(objectId, gatewayId);
        	}
        	
        	// Invoke "onOSMFGatewayRegistered"
        	if 	(	this["onOSMFGatewayRegistered"] != null
        		&&	this.onOSMFGatewayRegistered.length == 1
        		)
        	{
        		this.onOSMFGatewayRegistered(gateway);
        	}
	        
        	]]>;
		
		private static const registerGateway_js:XML = new XML
			( "<![CDATA["
			+ "function(objectId, gatewayId)"
			+ "{"
			+ utils_js.toString()
			+ constants_js.toString()
            + gateway_js.toString()
            + mediaElement_js.toString()
            + registrationLogic_js.toString()
            + "}"
            + "]]>"
            );
	}
}