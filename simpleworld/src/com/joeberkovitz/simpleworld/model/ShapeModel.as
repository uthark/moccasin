package com.joeberkovitz.simpleworld.model
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    
    public class ShapeModel extends MoccasinModel
    {
        [Bindable]
        public var x:Number;

        [Bindable]
        public var y:Number;
        
        override public function clone():MoccasinModel
        {
            var shape:ShapeModel = super.clone() as ShapeModel;
            shape.x = x;
            shape.y = y;
            return shape;
        }
    }
}