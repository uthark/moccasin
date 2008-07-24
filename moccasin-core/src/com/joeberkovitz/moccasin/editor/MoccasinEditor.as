package com.joeberkovitz.moccasin.editor
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.moccasin.event.OperationFaultEvent;
    import com.joeberkovitz.moccasin.event.ProgressSourceEvent;
    import com.joeberkovitz.moccasin.service.IConfigurationService;
    import com.joeberkovitz.moccasin.service.IMoccasinDocumentService;
    import com.joeberkovitz.moccasin.service.IOperation;
    import com.joeberkovitz.moccasin.service.MoccasinDocumentData;
    import com.joeberkovitz.moccasin.view.MoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.moccasin.view.ViewInfo;
    
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.printing.PrintJob;
    
    import mx.containers.Canvas;
    import mx.core.Application;
    import mx.core.UIComponent;
    import mx.managers.IFocusManagerComponent;
    import mx.managers.PopUpManager;

    public class MoccasinEditor extends Canvas implements IFocusManagerComponent
    {
        protected var _document:MoccasinDocument;
        
        private var _controller:IMoccasinController;
        private var _documentView:MoccasinView;
        private var _viewContext:ViewContext;

        // current pointer tool to be used by ViewContext         
        private var _pointerTool:String = ViewContext.SELECT_TOOL;
        
        [Bindable]
        public var complete:Boolean = false;
        
        [Bindable]
        public var viewInfo:ViewInfo = new ViewInfo();
        
        [Bindable]
        public var viewScale:Number = 1;

        [Bindable]
        public var configurationService:IConfigurationService = null;
        
        [Bindable]
        public var documentService:IMoccasinDocumentService = null;

        [Bindable]
        public var documentData:MoccasinDocumentData = null;
        
        [Bindable]
        public var statusText:String = "";
        
        public var documentLayer:UIComponent;
        public var feedbackLayer:UIComponent;  // scaled feedback aligned with document view

        private var viewLayer:Canvas;
        private var overlayLayer:UIComponent;    // unscaled feedback for global overlays
        private var loadingPopup:LoadingPopup = null;

        public function MoccasinEditor()
        {
            super();
        }
        
        /**
         * Global controller instance for this application (although multiple controllers are allowed).
         */
        public function get controller():IMoccasinController
        {
            return _controller;
        }

        /**
         * Top level view of document's root model.
         */
        public function get documentView():MoccasinView
        {
            return _documentView;
        }
        
        /**
         * Name of a cursor mode that affects how mouse gestures are interpreted. 
         */
        [Bindable]
        public function get pointerTool():String
        {
            return _pointerTool;
        } 
        
        public function set pointerTool(tool:String):void
        {
            _pointerTool = tool;
            if (_viewContext != null)
            {
                _viewContext.pointerTool = tool;
            }
        }
        
        /**
         * Initialize this editor. 
         * 
         */
        public function initializeEditor():void
        {
            _controller = createController();
            var keyMediator:EditorKeyMediator = createKeyMediator(_controller);
            documentService = createDocumentService();

            // aggressively funnel keystrokes into our key mediator
            Application.application.addEventListener(KeyboardEvent.KEY_DOWN, keyMediator.handleKey);
            addEventListener(KeyboardEvent.KEY_DOWN, keyMediator.handleKey);

            viewLayer.scaleX = viewLayer.scaleY = viewScale;
            
            setFocus();
        }
        
        /**
         * Initialize the child components of this editor.
         */
        override protected function createChildren():void
        {
            super.createChildren();
            
            viewLayer = new Canvas();
            addChild(viewLayer);
            
            documentLayer = new UIComponent();
            viewLayer.addChild(documentLayer);

            feedbackLayer = new UIComponent();
            viewLayer.addChild(feedbackLayer);
            
            overlayLayer = new UIComponent();
            addChild(overlayLayer);
        }
        
        /**
         * Abstract factory method to create this application's controller instance.
         */
        protected function createController():IMoccasinController
        {
            throw new Error("createController() must be overridden");
        }
        
        /**
         * Abstract factory method to create this application's top level view.
         */
        protected function createDocumentView(context:ViewContext):MoccasinView
        {
            throw new Error("createDocumentView() must be overridden");
        } 
        
        /**
         * Abstract factory method to create this application's document service
         */
        protected function createDocumentService():IMoccasinDocumentService
        {
            throw new Error("createDocumentService() must be overridden");
        } 
        
        /**
         * Abstract factory method to create this application's keystroke mediator.
         */
        protected function createKeyMediator(controller:IMoccasinController):EditorKeyMediator
        {
            return new EditorKeyMediator(controller, this);
        }
        
        /**
         * Override default key down handling in Container that would affect scroll bar position, etc.  
         */
        override protected function keyDownHandler(e:KeyboardEvent):void
        {
        }

        private function adjustCursor(ctrlKey:Boolean):void
        {
/*             var stagePt:Point = new Point(stage.mouseX, stage.mouseY);
            if (hitTestPoint(stagePt.x, stagePt.y)
                && (ctrlKey || _pointerTool == ViewContext.ENTRY_TOOL))
            {
                var p:Point = overlayLayer.globalToLocal(stagePt);
                entryToolCursor.x = p.x;
                entryToolCursor.y = p.y;
                entryToolCursor.visible = true;
                Mouse.hide();
            }
            else
            {
                entryToolCursor.visible = false;
                Mouse.show();
            }
 */        }
        
        /**
         * Load a document, given its ID. 
         */
        public function loadDocument(documentId:String):void
        {
            var operation:IOperation = documentService.loadDocument(documentId);
            operation.addEventListener(Event.COMPLETE, documentLoaded);
            operation.addEventListener(OperationFaultEvent.FAULT, documentFault);
            operation.addEventListener(ProgressSourceEvent.PROGRESS_START, handleProgressStart);
            operation.displayName = "Loading document..."
            operation.execute();
        }
        
        /**
         * Handler for the completion of a document's ;pad operation.
         */
        protected function documentLoaded(e:Event):void
        {
            documentData = MoccasinDocumentData(IOperation(e.target).result);
            
            _document = new MoccasinDocument(documentData.root);
            _controller.document = _document;
            updateLayout();
        }
        
        /**
         * Save this document, using the same ID with which it was loaded.
         */
        public function saveDocument():void
        {
            documentData.root = _document.root;
            
            var operation:IOperation = documentService.saveDocument(documentData);
            operation.addEventListener(Event.COMPLETE, documentSaved);
            operation.addEventListener(OperationFaultEvent.FAULT, documentFault);
            operation.addEventListener(ProgressSourceEvent.PROGRESS_START, handleProgressStart);
            operation.displayName = "Saving document..."
            operation.execute();
        }
    
        /**
         * Handler for the completion of a document's save operation.
         */
        protected function documentSaved(e:Event):void
        {
        }
        
        /**
         * Handler for faults occurring during the save or load of a document.
         */
        protected function documentFault(e:OperationFaultEvent):void
        {
        }
        
            
        /**
         * Adjust the document's current layout.
         */
        public function updateLayout():void
        {
            validateDocumentLayout();
        }
        
        /**
         * Print the current score document on the printer. 
         */
        public function printDocument():void
        {
        }
        
        /**
         * Obtain an array of PageView instances laid out correctly for printing with respect
         * to some particular PrintJob instance.  
         */
        private function getPageViews(printJob:PrintJob):Array
        {
            return [];
        }
        
        private function validateDocumentLayout():void
        {
            while (documentLayer.numChildren > 0)
                documentLayer.removeChildAt(0);
                
            viewInfo.displayScale = viewScale;
            _viewContext = new ViewContext(viewInfo, _controller, this, stage);
            _viewContext.pointerTool = _pointerTool;
            _documentView = createDocumentView(_viewContext);
            documentLayer.addChild(_documentView);
            updateScoreDimensions();
        }
        
        private function updateScoreDimensions():void
        {
            documentLayer.height = _documentView.height;
            documentLayer.width = _documentView.width;
        }

        private function handleProgressStart(e:ProgressSourceEvent):void
        {
            if (loadingPopup == null)
            {
                loadingPopup = PopUpManager.createPopUp(this, LoadingPopup, true) as LoadingPopup;
                PopUpManager.centerPopUp(loadingPopup);
            }
            loadingPopup.addEventListener(Event.REMOVED, handleLoadingPopupRemoved);
            loadingPopup.addProgressSource(e.source, e.sourceName);
        }
        
        private function handleLoadingPopupRemoved(e:Event):void
        {
            loadingPopup = null;
        }
        
        /**
         * Override to force the notation layer to a vertically centered position if it occupies
         * less than the full visible height of this component.  
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if (_document == null)
            {
                return;
            }
        }        
        
        /**
         * Set a view offset in scaled document coordinates. 
         */
        public function setViewOffset(x:Number, y:Number):void
        {
            documentLayer.x = feedbackLayer.x = x;
            documentLayer.y = feedbackLayer.y = y;
        }
        
        /**
         * Set the display scale and adjust the scrollbars as needed. 
         */
        public function setScale(s:Number):void
        {
            var oldScale:Number = viewScale;
            viewScale = s;
            var hScroll:Number = horizontalScrollPosition;
            var vScroll:Number = verticalScrollPosition;
            viewLayer.scaleX = viewLayer.scaleY = viewScale;
            
            viewInfo.displayScale = viewScale;

            var factor:Number = viewScale / oldScale;
            horizontalScrollPosition = (hScroll + width/2) * factor - width/2;
            verticalScrollPosition = (vScroll + height/2) * factor - height/2;
        }
    }
}
