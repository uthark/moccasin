package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.Square;
    
    import flash.display.DisplayObject;

    /**
     * View of a Square value object in the world. 
     */
    public class SquareView extends ShapeView
    {
        public function SquareView(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model);
            initialize();
        }
        
        /**
         * The Square object associated with this view's MoccasinModel.
         */
        public function get square():Square
        {
            return model.value as Square;
        }
        
        /**
         * Update this view by drawing the appropriate graphics.
         */
        override protected function updateView():void
        {
            super.updateView();
            
            // draw the square itself.
            graphics.beginFill(square.color);
            graphics.drawRect(0, 0, square.size, square.size);
            graphics.endFill();
        }
        
        /**
         * Create a feedback view that will be superimposed on this view in a transparent layer.
         */        
        override protected function createFeedbackView():DisplayObject
        {
            return new SquareFeedback(context, model);
        }
    }
}
