package com.joeberkovitz.moccasin.view
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    
    [Bindable]
    public class ViewInfo
    {
        public var feedbackColor:uint = 0x666666;
        
        public var selectionColors:Array = [0x3333FF, 0x88CC88, 0xCCCC11, 0x11CCCC];
        
        // maximum delay between clicks to be considered a double click
        public var doubleClickMillis:uint = 300;
        
        // scale at which display is being rendered; guides sizes of cached bitmaps for TextGlyphs.
        public var displayScale:Number = 1.0;

        public var displayTop:Number = 0;
        
        public var printView:Boolean = false;
        public var testView:Boolean = false;
        
        public function ViewInfo()
        {
            super();
        }
        
        public function clone():ViewInfo
        {
            var info:ViewInfo = new ViewInfo();
            info.feedbackColor = feedbackColor;
            info.selectionColors = selectionColors.slice();
            info.displayScale = displayScale;
            return info;
        }

    }
}
