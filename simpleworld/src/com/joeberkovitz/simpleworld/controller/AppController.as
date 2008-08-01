package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.MoccasinController;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.simpleworld.model.Square;
    import com.joeberkovitz.simpleworld.model.World;
    import com.joeberkovitz.simpleworld.model.WorldShape;

    /**
     * Application specific subclass of MoccasinController.  This class is responsible
     * for applying modifications to the application model on behalf of the presentation layer. 
     */
    public class AppController extends MoccasinController
    {
        public function AppController(document:MoccasinDocument)
        {
            super(document);
        }
        
        /**
         * The World that is the root value object of our document model.
         */
        public function get world():World
        {
            return document.root.value as World;
        }
        
        /**
         * Add a new square to the world. 
         */
        public function addObject():void
        {
            var square:Square = new Square();
            square.x = square.y = 100;
            square.size = 25;
            world.shapes.addItem(square);
        }

        /**
         * Transform pasted model objects appropriately, in this case offsetting them so that they
         * appear distinctly from the originals (if present).
         */
        override protected function transformPastedModel(model:MoccasinModel):MoccasinModel
        {
            if (model.value is WorldShape)
            {
                WorldShape(model.value).x += 10;
                WorldShape(model.value).y += 10;
            }
            return model;
        }
        
    }
}