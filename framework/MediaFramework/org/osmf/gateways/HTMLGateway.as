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
	
	import org.osmf.html.HTMLElement;
	import org.osmf.media.IContainerGateway;
	import org.osmf.media.IURLResource;
	import org.osmf.media.MediaElement;
	import org.osmf.proxies.ProxyElement;
	import org.osmf.traits.*;
	import org.osmf.utils.OSMFStrings;

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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function addElement(child:MediaElement):MediaElement
		{
			requireExternalInterface;
			
			if (child == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function removeElement(child:MediaElement):MediaElement
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
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
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
				// All property names start with a capital, for they translate
				// to 'getXxxx' in JavaScript.
				switch (property)
				{
					// MediaElement core:
					case "Resource":
						if (element.resource is IURLResource)
						{
							result = IURLResource(element.resource).url;
						}
						break;
					// LoadTrait:
					case "LoadState":
						if (element.hasTrait(MediaTraitType.LOAD))
						{
							result = LoadTrait(element.getTrait(MediaTraitType.LOAD)).loadState;
						}
						break;
					// PlayTrait:
					case "Playable":
						result = element.hasTrait(MediaTraitType.PLAY);
						break;
					case "Playing":
						if (element.hasTrait(MediaTraitType.PLAY))
						{
							result = PlayTrait(element.getTrait(MediaTraitType.PLAY)).playState == PlayState.PLAYING;
						}
						break;
					case "Pausable":
						if (element.hasTrait(MediaTraitType.PLAY))
						{
							result = PlayTrait(element.getTrait(MediaTraitType.PLAY)).canPause;
						}
						break;	
					case "Paused":
						if (element.hasTrait(MediaTraitType.PLAY))
						{
							result = PlayTrait(element.getTrait(MediaTraitType.PLAY)).playState == PlayState.PAUSED;
						}
						break;
					// TimeTrait:
					case "Temporal":
						result = element.hasTrait(MediaTraitType.TIME);
						break;
					case "Duration":
						if (element.hasTrait(MediaTraitType.TIME))
						{
							result = TimeTrait(element.getTrait(MediaTraitType.TIME)).duration;
						}
						break;
					case "CurrentTime":
						if (element.hasTrait(MediaTraitType.TIME))
						{
							result = TimeTrait(element.getTrait(MediaTraitType.TIME)).currentTime;
						}
					// AudioTrait:
					case "Volume":
						if (element.hasTrait(MediaTraitType.AUDIO))
						{
							result = AudioTrait(element.getTrait(MediaTraitType.AUDIO)).volume;
						}
						break;
					case "Muted":
						if (element.hasTrait(MediaTraitType.AUDIO))
						{
							result = AudioTrait(element.getTrait(MediaTraitType.AUDIO)).muted;
						}
						break;
					case "Pan":
						if (element.hasTrait(MediaTraitType.AUDIO))
						{
							result = AudioTrait(element.getTrait(MediaTraitType.AUDIO)).pan;
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
					var playable:PlayTrait = htmlElement.getSwitchableTrait(MediaTraitType.PLAY) as PlayTrait;
					var temporal:TimeTrait = htmlElement.getSwitchableTrait(MediaTraitType.TIME) as TimeTrait;
					var audible:AudioTrait = htmlElement.getTrait(MediaTraitType.AUDIO) as AudioTrait;
				}
				
				// All property names start with a capital, for they translate
				// to 'setXxxx' in JavaScript.
				switch (property)
				{
					// LoadTrait
					case "LoadState":
						var newLoadState:String = value;
						if (htmlElement)
						{
							htmlElement.loadState = newLoadState;
						}
						break;
					// PlayTrait:
					case "Playable":
						if (htmlElement)
						{
							htmlElement.setTraitEnabled(MediaTraitType.PLAY, value as Boolean);
						}
						break;
					case "Playing":
						if (playable)
						{
							if (value == true)
							{
								playable.play();
							}
							else
							{
								playable.stop();
							}
						}
						break;
					case "Pausable":
						if (htmlElement)
						{
							// TODO: How do we handle this?
							//htmlElement.setTraitEnabled(MediaTraitType.PAUSABLE, value as Boolean);
						}
						break;
					case "Paused":
						if (playable)
						{
							if (value == true)
							{
								playable.pause();
							}
							else
							{
								playable.stop();
							}
						}
						break;
					// Timerait:
					case "Temporal":
						if (htmlElement)
						{
							htmlElement.setTraitEnabled(MediaTraitType.TIME, value as Boolean);
						}
						break;
					case "Duration":
						if (temporal)
						{
							// TODO: Fix here and below.  It seems inappropriate for HTMLGateway
							// to set properties on a trait.  Would it be possible for HTMLGateway
							// to expose these property callbacks in such a way that an HTMLTemporalTrait
							// could listen for the change and set the duration on itself?
							//temporal.duration = value as Number;
						}
						break;
					case "CurrentTime":
						if (temporal)
						{
							// TODO: Fix (see previous comment).
							//temporal.currentTime = value as Number;
						}
						break;
					// AudioTrait
					case "Audible":
						if (htmlElement)
						{
							htmlElement.setTraitEnabled(MediaTraitType.AUDIO, value as Boolean);
						}
						break;
					case "Volume":
						if (audible)
						{
							audible.volume = value as Number;
						}
						break;
					case "Muted":
						if (audible)
						{
							audible.muted = value as Boolean;
						}
						break;
					case "Pan":
						if (audible)
						{
							audible.pan = value as Number;
						}
						break;
					// If the property is unknown, throw an exception:
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
				addGetSet	(this, 	"Playing");
        		addCallback	(this, 	"onPlayingChange", 1);		// playing;
        		
        		// IPausable (???) bridge:
        		
        		addGetSet	(this,	"Pausable");
        		addGetSet	(this,	"Paused");
        		addCallback	(this,	"onPausedChange", 1);		// paused;
        		
        		// TimeTrait bridge:
        		
        		addGetSet	(this,	"Temporal");
        		addGetSet	(this,	"Duration");
        		addCallback (this,	"onDurationChange", 1);		// duration;
        		addGetSet	(this,	"CurrentTime");
        		addCallback	(this,	"onDurationReached");
        		
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