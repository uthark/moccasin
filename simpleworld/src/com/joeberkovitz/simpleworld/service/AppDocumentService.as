package com.joeberkovitz.simpleworld.service
{
    import com.joeberkovitz.moccasin.service.FileDocumentService;
    import com.joeberkovitz.simpleworld.persistence.AppDocumentDecoder;
    import com.joeberkovitz.simpleworld.persistence.AppDocumentEncoder;
    
    /**
     * Application specific document service responsible for document persistence. 
     */
    public class AppDocumentService extends FileDocumentService
    {
        public function AppDocumentService()
        {
            super(new AppDocumentDecoder(), new AppDocumentEncoder());
        }
    }
}