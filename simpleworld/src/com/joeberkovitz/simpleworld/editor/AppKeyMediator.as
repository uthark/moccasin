package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    import com.joeberkovitz.moccasin.editor.EditorKeyMediator;
    
    import flash.events.KeyboardEvent;
    
    /**
     * Application specific keystroke handler.
     */
    public class AppKeyMediator extends EditorKeyMediator
    {
        private var _airEditor:AppEditor;
        
        public function AppKeyMediator(controller:IMoccasinController, editor:AppEditor)
        {
            super(controller, editor);
            _airEditor = editor;
        }
        
        override public function handleKey(e:KeyboardEvent):void
        {
            var ch:String = String.fromCharCode(e.charCode);
            switch (ch)
            {
            default:
                super.handleKey(e);
                return;
            }
            
            e.stopImmediatePropagation();
            e.stopPropagation();
        }
    }
}