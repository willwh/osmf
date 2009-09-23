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
package org.openvideoplayer.gateways
{
	import flash.errors.IllegalOperationError;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.html.HTMLElement;
	import org.openvideoplayer.media.IContainerGateway;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.proxies.ProxyElement;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	/**
	 * HTMLGateway is an IContainerGateway implementing class that uses the ExternalConnection
	 * to expose the gateway's child media elements to JavaScript.
	 */	
	public class HTMLGateway implements IContainerGateway
	{
		// IContainerGateway
		//

		/**
		 * @inheritDoc
		 */
		public function addChildElement(child:MediaElement):MediaElement
		{
			requireExternalInterface;
			
			if (child == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var result:MediaElement;
			
			for each (var element:HTMLGatewayElementProxy in elements)
			{
				if (element.wrappedElement == child)
				{
					throw new IllegalOperationError("Element already listed");
				}
			}
			
			var elementId:String = "element_" + elementIdCounter++;
			var elementScriptPath:String = gatewayScriptPath + "elements." + elementId + "."; 
			elements[elementId] 
				= new HTMLGatewayElementProxy
					( child
					, elementScriptPath
					);
			
			// Find out if the element at hand is an HTML element or not:
			var htmlElement:HTMLElement = elementAsHTMLElement(child);
			
			// If the element is an htmlElement, then set its dom-path:
			if (htmlElement)
			{
				htmlElement.scriptPath = elementScriptPath; 
			}
			
			ExternalInterface.call(gatewayScriptPath + "__addElement__", elementId);
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeChildElement(child:MediaElement):MediaElement
		{
			requireExternalInterface;
			
			if (child == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
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
		 */
		public function containsElement(child:MediaElement):Boolean
		{
			for each (var element:HTMLGatewayElementProxy in elements)
			{
				if (element.wrappedElement == child)
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
			ExternalInterface.addCallback("getProperty", getPropertyCallback);
			ExternalInterface.addCallback("setProperty", setPropertyCallback);
			ExternalInterface.addCallback("invoke", invokeCallback);
			
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
				if (HTMLGatewayElementProxy(elements[index]).wrappedElement == element)
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
			
			var element:MediaElement = elements[elementId];
			if (element)
			{
				switch (property)
				{
					// MediaElement core:
					case "resource":
						if (element.resource is IURLResource)
						{
							result = IURLResource(element.resource).url;
						}
						break;
					// ILoadable:
					case "loadState":
						if (element.hasTrait(MediaTraitType.LOADABLE))
						{
							result = ILoadable(element.getTrait(MediaTraitType.LOADABLE)).loadState.toString();
						}
						break;
					// IPlayable:
					case "playable":
						result = element.hasTrait(MediaTraitType.PLAYABLE);
						break;
					case "playing":
						if (element.hasTrait(MediaTraitType.PLAYABLE))
						{
							result = IPlayable(element.getTrait(MediaTraitType.PLAYABLE)).playing;
						}
						break;
					// IPausable:
					case "pausable":
						result = element.hasTrait(MediaTraitType.PAUSABLE);
						break;	
					case "paused":
						if (element.hasTrait(MediaTraitType.PAUSABLE))
						{
							result = IPausable(element.getTrait(MediaTraitType.PAUSABLE)).paused;
						}
						break;
					// ITemporal:
					case "temporal":
						result = element.hasTrait(MediaTraitType.TEMPORAL);
						break;
					case "duration":
						if (element.hasTrait(MediaTraitType.TEMPORAL))
						{
							result = ITemporal(element.getTrait(MediaTraitType.TEMPORAL)).duration;
						}
						break;
					case "position":
						if (element.hasTrait(MediaTraitType.TEMPORAL))
						{
							result = ITemporal(element.getTrait(MediaTraitType.TEMPORAL)).position;
						}
					// IAudible:
					case "volume":
						if (element.hasTrait(MediaTraitType.AUDIBLE))
						{
							result = IAudible(element.getTrait(MediaTraitType.AUDIBLE)).volume;
						}
						break;
					case "muted":
						if (element.hasTrait(MediaTraitType.AUDIBLE))
						{
							result = IAudible(element.getTrait(MediaTraitType.AUDIBLE)).muted;
						}
						break;
					case "pan":
						if (element.hasTrait(MediaTraitType.AUDIBLE))
						{
							result = IAudible(element.getTrait(MediaTraitType.AUDIBLE)).pan;
						}
						break;
				}
				
			}
			
			return result;
		}
		
		private function setPropertyCallback(elementId:String, property:String, value:*):Boolean
		{
			var element:MediaElement = elements[elementId];
			if (element)
			{
				var htmlElement:HTMLElement = elementAsHTMLElement(element);
				if (htmlElement)
				{
					var playable:PlayableTrait = htmlElement.getSwitchableTrait(MediaTraitType.PLAYABLE) as PlayableTrait;
					var pausable:PausableTrait = htmlElement.getSwitchableTrait(MediaTraitType.PAUSABLE) as PausableTrait;
					var temporal:TemporalTrait = htmlElement.getSwitchableTrait(MediaTraitType.TEMPORAL) as TemporalTrait;
					var audible:AudibleTrait = htmlElement.getTrait(MediaTraitType.AUDIBLE) as AudibleTrait;
				}
				
				switch (property)
				{
					// ILoadable
					case "loadState":
						var newState:LoadState = loadStateFromString(value);
						if (htmlElement)
						{
							htmlElement.loadState = newState;
						}
						break;
					// IPlayable:
					case "playable":
						if (htmlElement)
						{
							htmlElement.setTraitEnabled(MediaTraitType.PLAYABLE, value as Boolean);
						}
						break;
					case "playing":
						if (playable)
						{
							if (value == true)
							{
								playable.play();
							}
							else
							{
								playable.resetPlaying();
							}
						}
						break;
					// IPausable:
					case "pausable":
						if (htmlElement)
						{
							htmlElement.setTraitEnabled(MediaTraitType.PAUSABLE, value as Boolean);
						}
						break;
					case "paused":
						if (pausable)
						{
							if (value == true)
							{
								pausable.pause();
							}
							else
							{
								pausable.resetPaused();
							}
						}
						break;
					// ITemporal:
					case "temporal":
						if (htmlElement)
						{
							htmlElement.setTraitEnabled(MediaTraitType.TEMPORAL, value as Boolean);
						}
						break;
					case "duration":
						if (temporal)
						{
							temporal.duration = value as Number;
						}
						break;
					case "position":
						if (temporal)
						{
							temporal.position = value as Number;
						}
						break;
					// IAudible
					case "audible":
						if (htmlElement)
						{
							htmlElement.setTraitEnabled(MediaTraitType.AUDIBLE, value as Boolean);
						}
						break;
					case "volume":
						if (audible)
						{
							audible.volume = value as Number;
						}
						break;
					case "muted":
						if (audible)
						{
							audible.muted = value as Boolean;
						}
						break;
					case "pan":
						if (audible)
						{
							audible.pan = value as Number;
						}
						break;
					// If the property is unknow, throw an exception:
					default:
						throw new IllegalOperationError
							( "Property '"
							+ property
							+ "' assigned from JavaScript is not supported on a MediaElement."
							);
						break;
				}
			}
			
			return false;
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
		
		private static function loadStateFromString(value:String):LoadState
		{
			var result:LoadState;
			
			if (value)
			{
				for each (var state:LoadState in LoadState.ALL_STATES)
				{
					if (state.toString().toLowerCase() == value)
					{
						result = state;
						break;
					} 
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
        		element.__defineGetter__
        			( property
        			, function()
        				{ 
        					return element
	        					.__gateway__
	        					.__flashObject__
	        					.getProperty(element.elementId, property);
        				}
        			);
        	}
        	
        	function addSetter(element, property)
        	{
        		element.__defineSetter__
        			( property
        			, function(value)
        				{ 
        					return element
	        					.__gateway__
	        					.__flashObject__
	        					.setProperty(element.elementId, property, value);
        				}
        			);
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
        			element.gateway.__flashObject__.invoke
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
        			{ CONSTRUCTED: "constructed"
        			, LOADING: "loading"
        			, LOADED: "loaded"
        			, UNLOADING: "unloading"
        			, LOAD_FAILED: "loadFailed"
        			}
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
        			
        			if	(	this.hasOwnProperty("onElementAdd")
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
        			
        			if	(	this.hasOwnProperty("onElementRemove")
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
        		
        		// ILoadable bridge: (all HTML elements are loadable)
        		
        		addSetter	(this, 	"loadState");
        		addCallback	(this, 	"load", 1);					// urlResource
        		addCallback	(this, 	"unload", 0); 
        		
				// IPlayable bridge:
				
				addGetSet	(this,	"playable");
				addGetSet	(this, 	"playing");
        		addCallback	(this, 	"onPlayingChange", 1);		// playing;
        		
        		// IPausable bridge:
        		
        		addGetSet	(this,	"pausable");
        		addGetSet	(this,	"paused");
        		addCallback	(this,	"onPausedChange", 1);		// paused;
        		
        		// ITemporal bridge:
        		
        		addGetSet	(this,	"temporal");
        		addGetSet	(this,	"duration");
        		addCallback (this,	"onDurationChange", 1);		// duration;
        		addGetSet	(this,	"position");
        		addCallback	(this,	"onDurationReached");
        		
        		// IAudible bridge:
        		
        		addGetSet	(this,	"audible");			
        		addGetSet	(this,	"volume");
        		addCallback	(this,	"onVolumeChange", 1);		// volume;
        		addGetSet	(this,	"muted");
        		addCallback	(this,	"onMutedChange", 1);		// muted;
        		addGetSet	(this,	"pan");
        		addCallback	(this,	"onPanChange", 1);			// pan;
        	}
        	]]>;
        	
        // Defines the logic that sets up the document.osmf object, adding a gateway:
        private static const registrationLogic_js:XML =
        	<![CDATA[
        	
        	// Get a reference to, or otherwise construct, the document.osmf.gateways path:
            	
        	var osmf 
        		= document.osmf
        		= document.osmf || new Object();
        		
        	osmf.constants
        		= osmf.constants || new Constants();
        		
        	var gateways
        		= osmf.gateways
        		= osmf.gateways || new Object();
        	
        	// For debugging, provide a 'trace' function on: it will
        	// forward the message to Flash:
        	
        	if (osmf.trace == null)
        	{
        		osmf.trace = function(message)
        		{
        			document.getElementById(objectId).invoke(null, "trace", [message]);
        		}
        	}	
        	
        	// See if the gateway with the specified name has been registered:
        	
        	var identifier = objectId + "_" + gatewayId; 
        	
        	if (gateways.identifier != null)
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
        	
        	if 	(	hasOwnProperty("onOSMFGatewayRegistered")
        		&&	onOSMFGatewayRegistered.length == 1
        		)
        	{
        		onOSMFGatewayRegistered(gateway);
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