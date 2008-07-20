package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.moccasin.editor.EditorKeyMediator;
    import com.joeberkovitz.moccasin.editor.MoccasinEditor;
    import com.joeberkovitz.moccasin.model.ModelRoot;
    import com.joeberkovitz.moccasin.view.MoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.SimpleController;
    import com.joeberkovitz.simpleworld.model.WorldModel;
    import com.joeberkovitz.simpleworld.view.WorldView;
    
    import flash.events.Event;
    import flash.filesystem.File;
    

    public class SimpleWorldEditor extends MoccasinEditor
    {
        override public function initializeEditor():void
        {
            super.initializeEditor();
            
            controller.document = new MoccasinDocument(new ModelRoot(new WorldModel()));
            updateLayout();
        }
        
        /**
         * Override base class to create an ActionRecorder instead of a regular controller. 
         */
        override protected function createController():IMoccasinController
        {
            return new SimpleController(null);
        }
        
        override protected function createKeyMediator(controller:IMoccasinController):EditorKeyMediator
        {
            return new AirEditorKeyMediator(controller, this);
        }
        
        override protected function createDocumentView(context:ViewContext):MoccasinView
        {
            return new WorldView(context, controller.document.root);
        } 
        
        /**
         * Open a particular score -- this has nothing to do with training. 
         */
        public function openFile():void
        {
            var file:File = new File();
            file.browseForOpen("Open Document");
            file.addEventListener(Event.SELECT, handleSelectOpen);            
        }
        
        private function handleSelectOpen(e:Event):void
        {
            var file:File = e.target as File;
            loadDocument(file.url);
        }
        
        public function saveAsFile():void
        {
            var file:File = new File();
            file.browseForSave("Save Document As...");
            file.addEventListener(Event.SELECT, handleSelectSaveAs);            
        }
        
        private function handleSelectSaveAs(e:Event):void
        {
            var file:File = e.target as File;
            documentData.documentId = file.url;
            saveDocument();
        }
    }
}