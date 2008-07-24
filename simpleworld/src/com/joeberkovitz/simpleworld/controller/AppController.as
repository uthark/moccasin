package com.joeberkovitz.simpleworld.controller
{
    import com.joeberkovitz.moccasin.controller.MoccasinController;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.simpleworld.model.Square;
    import com.joeberkovitz.simpleworld.model.World;

    /**
     * Application specific subclass of MoccasinController.  This class is responsible
     * for applying all modifications to the application model. 
     */
    public class AppController extends MoccasinController
    {
        public function AppController(document:MoccasinDocument)
        {
            super(document);
        }
        
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
    }
}