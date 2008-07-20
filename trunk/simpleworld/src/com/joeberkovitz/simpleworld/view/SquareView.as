package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.model.SquareModel;

    public class SquareView extends ShapeView
    {
        public function SquareView(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model);
            initialize();
        }
        
        public function get square():SquareModel
        {
            return model.value as SquareModel;
        }
        
        override protected function updateView():void
        {
            super.updateView();
            
            graphics.beginFill(0);
            graphics.drawRect(0, 0, square.size, square.size);
            graphics.endFill();
        }
    }
}