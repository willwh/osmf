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
package org.openvideoplayer.view.panels
{
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.ITreeDataDescriptor;
	
	import org.openvideoplayer.composition.CompositeElement;
	import org.openvideoplayer.media.MediaElement;
	
	public class CompositeElementTreeDataDescriptor implements ITreeDataDescriptor
	{
		public function addChildAt(parent:Object, newChild:Object, index:int, model:Object=null):Boolean
		{
			var compositeElement:CompositeElement = parent as CompositeElement;
			if (compositeElement != null)
			{
				compositeElement.addChildAt(newChild as MediaElement, index);
				
				return true;
			}
			
			return false;
		}
		
		public function getChildren(node:Object, model:Object=null):ICollectionView
		{
			var compositeElement:CompositeElement = node as CompositeElement;
			
			var children:ArrayCollection = new ArrayCollection();
			if (compositeElement != null)
			{
				for (var i:int = 0; i < compositeElement.numChildren; i++)
				{
					children.addItem(compositeElement.getChildAt(i));
				}
			}
			
			return children;
		}
		
		public function getData(node:Object, model:Object=null):Object
		{
			return node;
		}
		
		public function hasChildren(node:Object, model:Object=null):Boolean
		{
			var compositeElement:CompositeElement = node as CompositeElement;
			
			return compositeElement != null && compositeElement.numChildren > 0;
		}
		
		public function isBranch(node:Object, model:Object=null):Boolean
		{
			return node is CompositeElement;
		}
		
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean
		{
			var compositeElement:CompositeElement = parent as CompositeElement;
			if (compositeElement != null &&
				compositeElement.getChildIndex(child as MediaElement) != index)
			{
				compositeElement.removeChild(child as MediaElement);
				
				return true;
			}
			
			return false;
		}
	}
}