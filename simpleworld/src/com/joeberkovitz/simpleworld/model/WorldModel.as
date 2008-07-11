package com.joeberkovitz.simpleworld.model
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    
    public class WorldModel extends ModelRoot
    {
        [Bindable]
        public var width:Number = 2000;

        [Bindable]
        public var height:Number = 2000;
        
        public function WorldModel()
        {
        }
    }
}