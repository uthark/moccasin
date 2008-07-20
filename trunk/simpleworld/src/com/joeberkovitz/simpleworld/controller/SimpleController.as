package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.MoccasinController;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.simpleworld.model.SquareModel;
    import com.joeberkovitz.simpleworld.model.WorldModel;

    public class SimpleController extends MoccasinController
    {
        public function SimpleController(document:MoccasinDocument)
        {
            super(document);
        }
        
        public function get world():WorldModel
        {
            return document.root as WorldModel;
        }
        
        public function addObject():void
        {
            var square:SquareModel = new SquareModel();
            square.x = square.y = 100;
            square.size = 25;
            world.shapes.addItem(square);
        }
    }
}