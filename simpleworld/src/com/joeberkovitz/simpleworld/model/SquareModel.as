package com.joeberkovitz.simpleworld.model
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    
    public class SquareModel extends ShapeModel
    {
        [Bindable]
        public var size:Number;
 
        override public function clone():MoccasinModel
        {
            var square:SquareModel = super.clone() as SquareModel;
            square.size = size;
            return square;
        }
    }
}