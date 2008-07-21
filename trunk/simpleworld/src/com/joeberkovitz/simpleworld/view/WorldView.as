package com.joeberkovitz.simpleworld.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.moccasin.view.MoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.WorldMediator;
    import com.joeberkovitz.simpleworld.model.SquareModel;
    import com.joeberkovitz.simpleworld.model.WorldModel;
    
    import flash.utils.getQualifiedClassName;

    public class WorldView extends MoccasinView
    {
        public function WorldView(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model);
            initialize();
        }
        
        public function get world():WorldModel
        {
            return model.value as WorldModel;
        }
        
        override protected function initialize():void
        {
            super.initialize();
            new WorldMediator(context).handleViewEvents(this);
        }
        
        override protected function updateView():void
        {
            super.updateView();
            
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(0, 0, world.width, world.height);
            graphics.endFill();
        }

        override public function createChildView(child:MoccasinModel):MoccasinView
        {
            if (child.value is SquareModel)
            {
                return new SquareView(context, child);
            }
            else
            {
                throw new Error("Unrecognized model type: " + getQualifiedClassName(child));
            }
        }
    }
}