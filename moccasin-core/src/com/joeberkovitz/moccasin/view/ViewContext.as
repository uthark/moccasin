package com.joeberkovitz.moccasin.view
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.moccasin.editor.MoccasinEditor;
    
    import flash.display.Stage;
    import flash.events.EventDispatcher;
    
    public class ViewContext extends EventDispatcher
    {
        public var info:ViewInfo;
        public var controller:IMoccasinController;
        public var editor:MoccasinEditor;
        public var stage:Stage;

        public static const SELECT_TOOL:String = "select";
        public var pointerTool:String = SELECT_TOOL; 
        
        public function ViewContext(info:ViewInfo,
                                    controller:IMoccasinController,
                                    editor:MoccasinEditor,
                                    stage:Stage)
        {
            this.info = info;
            this.controller = controller;
            this.editor = editor;
            this.stage = stage;
        }
        
        public function get document():MoccasinDocument
        {
            return (controller != null) ? controller.document : null;
        }
        
        public function registerView(view:MoccasinView):void
        {
/*             if (controller != null)
            {
                var mediator:BeamMediator = new BeamMediator();
                mediator.handleViewEvents(view);
            } 
 */
        }
    }
}
