package com.joeberkovitz.moccasin.view
{
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    
    import flash.display.Sprite;
    import flash.geom.ColorTransform;

    public class MoccasinView extends Sprite
    {
        public var feedback:Boolean = false;
        
        private var _context:ViewContext;
        private var _model:MoccasinModel;
        
        public function MoccasinView(context:ViewContext, model:MoccasinModel = null)
        {
            _context = context;
            _model = model;
        }
        
        public function get context():ViewContext
        {
            return _context;
        }
        
        public function get model():MoccasinModel
        {
            return _model;
        }

        protected function initializeView():void
        {
            graphics.clear();
            updateView();
            updateStatus();
        }
        
        // Abstract methods
        
        /**
         * Called to initialize the view's contents, typically by consulting its layout and constructing its children. 
         */
        protected function updateView():void
        {
        }

        protected function createChildView(child:MoccasinModel):MoccasinView
        {
            return null;
        }
        
        /**
         * Update the geometry of this object by redrawing graphics, adjusting child positions, etc. 
         */
        public function updateGeometry():void
        {
        }

        /**
         * Update the status of this object with respect to selection status, etc. 
         */
        public function updateStatus():void
        {
            transform.colorTransform = getColorTransform();
        }
        
        protected function getColorTransform():ColorTransform
        {
            if (feedback)
            {
                return lightenTransform(context.info.feedbackColor); 
            }
            else if (selected)
            {
                return lightenTransform(context.info.selectionColors[0]);
            }
            else
            {
                return new ColorTransform();
            }
        }
        
        protected static function lightenTransform(color:uint):ColorTransform
        {
            return new ColorTransform(1, 1, 1, 1,
                                      color >> 16, (color >> 8) & 0xFF, color & 0xFF);
        }

        protected static function darkenTransform(color:uint):ColorTransform
        {
            return new ColorTransform((color >> 16) / 255.0, ((color >> 8) & 0xFF) / 255.0, (color & 0xFF) / 255.0);
        }

        /** Determine whether an element in the view appears selected or not. */
        public function get selected():Boolean
        {
            return false;
        }
    }
}
