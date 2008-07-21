package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.SelectableView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.ShapeDragMediator;
    import com.joeberkovitz.simpleworld.model.ShapeModel;

    public class ShapeView extends SelectableView
    {
        public function ShapeView(context:ViewContext, model:MoccasinModel)
        {
            super(context, model);
        }
        
        public function get shape():ShapeModel
        {
            return model.value as ShapeModel;
        }
        
        override protected function initialize():void
        {
            super.initialize();
            new ShapeDragMediator(context).handleViewEvents(this);
        }
        
        override protected function updateView():void
        {
            super.updateView();
            
            x = shape.x;
            y = shape.y;
        }
    }
}