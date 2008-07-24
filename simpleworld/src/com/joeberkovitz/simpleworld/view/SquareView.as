package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.Square;
    
    import flash.display.DisplayObject;

    public class SquareView extends ShapeView
    {
        public function SquareView(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model);
            initialize();
        }
        
        public function get square():Square
        {
            return model.value as Square;
        }
        
        override protected function updateView():void
        {
            super.updateView();
            
            graphics.beginFill(0);
            graphics.drawRect(0, 0, square.size, square.size);
            graphics.endFill();
        }
        
        override protected function createFeedbackView():DisplayObject
        {
            return new SquareFeedback(context, model);
        }
    }
}