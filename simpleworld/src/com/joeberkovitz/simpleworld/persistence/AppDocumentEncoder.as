package com.joeberkovitz.simpleworld.persistence
{
    import com.joeberkovitz.moccasin.model.ModelRoot;
    import com.joeberkovitz.moccasin.persistence.IDocumentEncoder;
    import com.joeberkovitz.simpleworld.model.ShapeModel;
    import com.joeberkovitz.simpleworld.model.SquareModel;
    import com.joeberkovitz.simpleworld.model.WorldModel;

    public class AppDocumentEncoder implements IDocumentEncoder
    {
        public function AppDocumentEncoder()
        {
        }

        public function encodeDocument(root:ModelRoot):*
        {
            var world:WorldModel = root.value as WorldModel;
            var xml:XML = <world/>;
            
            for each (var shape:ShapeModel in world.shapes)
            {
                if (shape is SquareModel)
                {
                    var square:SquareModel = shape as SquareModel;
                    xml.appendChild(<square x={square.x} y={square.y} size={square.size}/>);
                }
            }
            
            return xml;
        }
     }
}