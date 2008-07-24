package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.SelectableView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.ShapeDragMediator;
    import com.joeberkovitz.simpleworld.model.WorldShape;

    /**
     * View of a WorldShape value object in this application.  ShapeViews may be dragged around if
     * appropriate, and they move to track the object's position when that changes. 
     */
    public class ShapeView extends SelectableView
    {
        private var _allowDrag:Boolean;
        
        public function ShapeView(context:ViewContext, model:MoccasinModel, allowDrag:Boolean = true)
        {
            super(context, model);
            _allowDrag = allowDrag;
        }
        
        public function get shape():WorldShape
        {
            return model.value as WorldShape;
        }
        
        override protected function initialize():void
        {
            super.initialize();
            if (_allowDrag)
            {
                new ShapeDragMediator(context).handleViewEvents(this);
            }
        }
        
        override protected function updateView():void
        {
            super.updateView();
            
            x = shape.x;
            y = shape.y;
        }
    }
}