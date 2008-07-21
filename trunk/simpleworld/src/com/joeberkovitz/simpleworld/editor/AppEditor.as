package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.moccasin.editor.AirMoccasinEditor;
    import com.joeberkovitz.moccasin.editor.EditorKeyMediator;
    import com.joeberkovitz.moccasin.model.ModelRoot;
    import com.joeberkovitz.moccasin.service.IMoccasinDocumentService;
    import com.joeberkovitz.moccasin.service.MoccasinDocumentData;
    import com.joeberkovitz.moccasin.view.MoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.AppController;
    import com.joeberkovitz.simpleworld.model.WorldModel;
    import com.joeberkovitz.simpleworld.service.AppDocumentService;
    import com.joeberkovitz.simpleworld.view.WorldView;
    

    public class AppEditor extends AirMoccasinEditor
    {
        override public function initializeEditor():void
        {
            super.initializeEditor();
            
            _document = new MoccasinDocument(new ModelRoot(new WorldModel()));
            controller.document = _document;
            documentData = new MoccasinDocumentData(_document.root, null);
            updateLayout();
        }
        
        /**
         * Override base class to create an ActionRecorder instead of a regular controller. 
         */
        override protected function createController():IMoccasinController
        {
            return new AppController(null);
        }
        
        override protected function createKeyMediator(controller:IMoccasinController):EditorKeyMediator
        {
            return new AppKeyMediator(controller, this);
        }
        
        override protected function createDocumentView(context:ViewContext):MoccasinView
        {
            return new WorldView(context, controller.document.root);
        } 

        override protected function createDocumentService():IMoccasinDocumentService
        {
            return new AppDocumentService();
        } 
        
    }
}