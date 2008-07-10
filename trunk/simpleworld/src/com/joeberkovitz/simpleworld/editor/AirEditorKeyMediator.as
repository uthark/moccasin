package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    import com.joeberkovitz.moccasin.editor.EditorKeyMediator;
    
    import flash.events.KeyboardEvent;
    
    public class AirEditorKeyMediator extends EditorKeyMediator
    {
        private var _airEditor:SimpleWorldEditor;
        
        public function AirEditorKeyMediator(controller:IMoccasinController, editor:SimpleWorldEditor)
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