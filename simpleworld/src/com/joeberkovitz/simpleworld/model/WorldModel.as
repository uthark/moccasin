package com.joeberkovitz.simpleworld.model
{
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    
    [RemoteClass]
    public class WorldModel
    {
        public static const MOCCASIN_CHILDREN_PROPERTY:String = "shapes";
        
        [Bindable]
        public var width:Number = 2000;

        [Bindable]
        public var height:Number = 2000;

        [Bindable]
        public var shapes:IList = new ArrayCollection();   
    }
}