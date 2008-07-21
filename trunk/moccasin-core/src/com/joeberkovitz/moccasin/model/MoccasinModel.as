package com.joeberkovitz.moccasin.model
{
    import com.joeberkovitz.moccasin.event.ModelEvent;
    import com.joeberkovitz.moccasin.event.ModelUpdateEvent;
    
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    import mx.events.PropertyChangeEvent;
    import mx.events.PropertyChangeEventKind;
    import mx.utils.ObjectUtil;
    
    [Event(type="mx.events.PropertyChangeEvent",name="propertyChange")]
    [Event(type="com.joeberkovitz.moccasin.event.ModelEvent",name="modelChange")]
    [Event(type="com.joeberkovitz.moccasin.event.ModelUpdateEvent",name="modelUpdate")]
    
    /**
     * <p>A MoccasinModel represents an element of a hierarchical model with child nodes and a parent node.
     * It is a wrapper around a pure value object in the underlying application model that need not expose
     * any methods, only properties.   There is a single, distinguished MoccasinModel for each single value
     * object in the underlying application model.</p>
     *   
     * <p>Any property of a value object that can trigger a view change is required to be Bindable.
     * Also, there is a special property of a value object that is presumed to be its child value objects
     * in the application model, and which must implement the mx.collections.IList interface.
     * By default, this property's name is "children", but may be overridden
     * by defining a static constant MOCCASIN_CHILDREN_PROPERTY to reference some other property name.</p>
     */
    public class MoccasinModel extends EventDispatcher
    {
        /** The parent of this model object. */
        private var _parent:MoccasinModel;
        
        /** The set of children of this model object. */
        private var _children:ArrayCollection;
        
        /** The underlying value object */
        private var _value:Object;
        
        /** A reverse-lookup weak dictionary from models to their wrappers. */
        private static var _valueMap:Dictionary = new Dictionary(true);
        
        /**
         * Either retrieve or create the distinguished MoccasinModel for the given value object.
         */
        public static function forValue(value:Object):MoccasinModel
        {
            var proxy:MoccasinModel = _valueMap[value];
            if (proxy == null)
            {
                proxy = new MoccasinModel(value);
                _valueMap[value] = proxy;
            }
            return proxy;
        }

        /**
         * Create a MoccasinModel that wraps an underlying value object in the application domain.
         * In practice, callers should almost always call MoccasinModel.forValue() rather than
         * invoking this constructor.
         */
        public function MoccasinModel(value:Object)
        {
            super();
            _children = new ArrayCollection();
            _value = value;
            
            if (_value in _valueMap)
            {
                throw new Error("Attempt to create duplicate wrapper for " + value);
            }
            _valueMap[_value] = this;
            
            if (_value is IEventDispatcher)
            {
                IEventDispatcher(_value).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, handlePropertyChange);
                if (valueChildrenProperty in _value)
                {
                    var children:IList = valueChildren;
                    if (valueChildren != null)
                    {
                        valueChildren.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChange);
                    }
                }
            }
        }
        
        public function get value():Object
        {
            return _value;
        }
        
        private function get valueChildrenProperty():String
        {
            var cls:Object = getDefinitionByName(getQualifiedClassName(_value));
            if ("MOCCASIN_CHILDREN_PROPERTY" in cls)
            {
                return cls["MOCCASIN_CHILDREN_PROPERTY"];
            }
            return "children";
        }
        
        public function get valueChildren():IList
        {
            return value[valueChildrenProperty] as IList;
        }
        
        private function addChild(child:MoccasinModel):void
        {
            addChildAt(child, _children.length);
        }
        
        private function addChildAt(child:MoccasinModel, index:uint):void
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
        
        private function removeChild(child:MoccasinModel):void
        {
            var index:int = _children.getItemIndex(child);
            if (index >= 0)
            {
                removeChildAt(index);
            }
        }
        
        private function removeChildAt(index:uint):void
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
        
        public function removeValueChild(valueChild:Object):void
        {
            var index:int = valueChildren.getItemIndex(valueChild);
            if (index >= 0)
            {
                valueChildren.removeItemAt(index);
            }
        }

        private function removeAllChildren():void
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
        
        private function pathToChild(m:MoccasinModel):String
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
        
        private function resolvePathComponent(childSpec:String):MoccasinModel
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
        
        private function handlePropertyChange(e:PropertyChangeEvent):void
        {
            if (e.kind == PropertyChangeEventKind.UPDATE)
            {
                var e2:ModelUpdateEvent =
                    new ModelUpdateEvent(ModelUpdateEvent.MODEL_UPDATE,
                                         e.property, e.oldValue, e.newValue, this);
                 dispatchModelUpdateEvent(e2);
            }
        }
        
        private function handleCollectionChange(e:CollectionEvent):void
        {
            var i:int;

            switch (e.kind)
            {
            case CollectionEventKind.ADD:
                for (i = 0; i < e.items.length; i++)
                {
                    addChildAt(MoccasinModel.forValue(e.items[i]), e.location + i);
                }
                break;

            case CollectionEventKind.REMOVE:
                for (i = e.items.length - 1; i >= 0; i--)
                {
                    removeChildAt(e.location + i);
                }
                break;

            case CollectionEventKind.REPLACE:
                removeChildAt(e.location);
                addChildAt(MoccasinModel.forValue(valueChildren.getItemAt(e.location)), e.location);
                break;
                
            case CollectionEventKind.UPDATE:
                // we don't care
                break;
                
            default:
                throw new Error("Unexpected CollectionEventKind: " + e.kind);
            }
            
            return;
        }
        
        private function handleChildModelChange(e:ModelEvent):void
        {
            // do event bubbling to our parent model
            dispatchModelEvent(e);
        }
        
        private function handleChildModelUpdate(e:ModelUpdateEvent):void
        {
            // do event bubbling to our parent model
            dispatchModelUpdateEvent(e);
        }
        
        private function dispatchModelEvent(e:ModelEvent):void
        { 
            dispatchEvent(e);
        }

        private function dispatchModelUpdateEvent(e:ModelUpdateEvent):void
        {
            dispatchEvent(e);
        }

        public function clone():MoccasinModel
        {
            return new MoccasinModel(ObjectUtil.copy(value));
        }
    }
}
