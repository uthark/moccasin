package com.joeberkovitz.moccasin.model
{
    import com.joeberkovitz.moccasin.event.ModelEvent;
    import com.joeberkovitz.moccasin.event.ModelUpdateEvent;
    
    import flash.events.EventDispatcher;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    
    import mx.collections.ArrayCollection;
    import mx.events.PropertyChangeEvent;
    import mx.events.PropertyChangeEventKind;
    
    [Event(type="mx.events.PropertyChangeEvent",name="propertyChange")]
    [Event(type="com.joeberkovitz.moccasin.event.ModelEvent",name="modelChange")]
    [Event(type="com.joeberkovitz.moccasin.event.ModelUpdateEvent",name="modelUpdate")]
    
    /**
     * A Model represents an element of the hierarchical score model with child nodes and a parent node. 
     */
    public class MoccasinModel extends EventDispatcher
    {
        /** The parent of this model object. */
        protected var _parent:MoccasinModel;
        
        /** The set of children of this model object. */
        protected var _children:ArrayCollection;
        
        public function MoccasinModel()
        {
            super();
            _children = new ArrayCollection();
            addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, handlePropertyChange);
        }

        public function addChild(child:MoccasinModel):void
        {
            addChildAt(child, _children.length);
        }
        
        public function addChildAt(child:MoccasinModel, index:uint):void
        {
            child._parent = this;
            child.addEventListener(ModelEvent.MODEL_CHANGE, handleChildModelChange);
            child.addEventListener(ModelUpdateEvent.MODEL_UPDATE, handleChildModelUpdate);
            _children.addItemAt(child, index);
            dispatchModelEvent(new ModelEvent(ModelEvent.MODEL_CHANGE, ModelEvent.ADD_CHILD_MODEL, this, child, index));
        }
        
        public function getChildAt(index:uint):MoccasinModel
        {
            if (index < _children.length)
            {
                return MoccasinModel(_children.getItemAt(index));
            }
            else
            {
                return null;
            }
        }
        
        public function removeChild(child:MoccasinModel):void
        {
            var index:int = _children.getItemIndex(child);
            if (index >= 0)
            {
                removeChildAt(index);
            }
        }
        
        public function removeChildAt(index:uint):void
        {
            var child:MoccasinModel = getChildAt(index);

            // dispatch preparatory event that can cause view/selection changes prior to actual removal
            dispatchModelEvent(new ModelEvent(ModelEvent.MODEL_CHANGE, ModelEvent.REMOVING_CHILD_MODEL, this, child, index));

            child._parent = null;
            child.removeEventListener(ModelEvent.MODEL_CHANGE, handleChildModelChange);
            child.removeEventListener(ModelUpdateEvent.MODEL_UPDATE, handleChildModelUpdate);
            _children.removeItemAt(index);
            
            dispatchModelEvent(new ModelEvent(ModelEvent.MODEL_CHANGE, ModelEvent.REMOVE_CHILD_MODEL, this, child, index));
        }
        
        public function removeAllChildren():void
        {
            while (numChildren > 0)
            {
                removeChildAt(numChildren - 1);
            }
        }

        public function get parent():MoccasinModel
        {
            return _parent;
        }
        
        public function set parent(m:MoccasinModel):void
        {
            _parent = m;
        }
        
        public function get numChildren():int
        {
            return _children.length;
        }
        
        public function get enabled():Boolean
        {
            return true;
        }
        
        /**
         * Obtain a String "path" to this model object from the score, as a way to serialize a reference to it.
         */        
        public function get path():String
        {
            if (parent is ModelRoot)
            {
                return parent.pathToChild(this);
            }
            return parent.path + "/" + parent.pathToChild(this);
        }
        
        protected function pathToChild(m:MoccasinModel):String
        {
            var className:String = getQualifiedClassName(m);
            className = className.substring(className.lastIndexOf(":") + 1);
            return className + "-" + _children.getItemIndex(m).toString();
        }
        
        /**
         * Resolve a path to some descendant model of this one. 
         */
        public function resolvePath(path:String):MoccasinModel
        {
            var slashIndex:int = path.indexOf("/");
            if (slashIndex < 0)
            {
                // no more delimiters left to strip off
                return resolvePathComponent(path);
            }
            
            var childSpec:String = path.substring(0, slashIndex);
            var descendantSpec:String = path.substring(slashIndex + 1);
            
            return resolvePathComponent(childSpec).resolvePath(descendantSpec);
        }
        
        protected function resolvePathComponent(childSpec:String):MoccasinModel
        {
            var dashIndex:int = childSpec.indexOf("-");
            var type:String = childSpec.substring(0, dashIndex);
            var i:uint = parseInt(childSpec.substring(dashIndex + 1));
            var m:MoccasinModel = _children.getItemAt(i) as MoccasinModel;
            var className:String = getQualifiedClassName(m);
            className = className.substring(className.lastIndexOf(":") + 1);
            if (className != type)
            {
                throw new Error("Resolution of " + childSpec + " gave unexpected type " + className); 
            }
            return m;
        }
        
        protected function handlePropertyChange(e:PropertyChangeEvent):void
        {
            if (e.kind == PropertyChangeEventKind.UPDATE)
            {
                var e2:ModelUpdateEvent =
                    new ModelUpdateEvent(ModelUpdateEvent.MODEL_UPDATE,
                                         e.property, e.oldValue, e.newValue, e.source);
                 dispatchModelUpdateEvent(e2);
            }
        }
        
        protected function handleChildModelChange(e:ModelEvent):void
        {
            // do event bubbling to our parent model
            dispatchModelEvent(e);
        }
        
        protected function handleChildModelUpdate(e:ModelUpdateEvent):void
        {
            // do event bubbling to our parent model
            dispatchModelUpdateEvent(e);
        }
        
        protected function dispatchModelEvent(e:ModelEvent):void
        { 
            dispatchEvent(e);
        }

        protected function dispatchModelUpdateEvent(e:ModelUpdateEvent):void
        {
            dispatchEvent(e);
        }

        public function clone():MoccasinModel
        {
            var m:MoccasinModel = new (getDefinitionByName(getQualifiedClassName(this)) as Class)();
            for each (var child:MoccasinModel in _children)
            {
                m.addChild(child.clone());
            }
            return m;
        }
        
        public static function cloneModel(m:MoccasinModel):MoccasinModel
        {
            return (m == null) ? null : m.clone();
        }
        
        public static function cloneArray(a:Array):Array
        {
            if (a == null)
            {
                return null;
            }
            var result:Array = [];
            for (var i:* in a)
            {
                result[i] = a[i];
            } 
            return result;
        }
   }
}
