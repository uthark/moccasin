package com.joeberkovitz.simpleworld.persistence
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    import com.joeberkovitz.moccasin.persistence.IDocumentDecoder;
    import com.joeberkovitz.simpleworld.model.Square;
    import com.joeberkovitz.simpleworld.model.World;

    /**
     * Application specific XML decoder that creates a top-level model object from an XML document.
     */
    public class AppDocumentDecoder implements IDocumentDecoder
    {
        public function AppDocumentDecoder()
        {
        }

        public function decodeDocument(data:*):ModelRoot
        {
            var xml:XML = data as XML;
            var world:World = new World();
            
            for each (var shapeXml:XML in xml.children())
            {
                switch (shapeXml.name().toString())
                {
                    case "square":
                        var square:Square = new Square();
                        square.x = shapeXml.@x;
                        square.y = shapeXml.@y;
                        square.size = shapeXml.@size;
                        world.shapes.addItem(square);
                        break;
                } 
            }
            
            return new ModelRoot(world);
        }
    }
}