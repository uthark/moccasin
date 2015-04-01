The way Moccasin treats Models and Views is somewhat unique. As usual, one goal here is to absolutely separate view objects from models: views can reference models, but never the other way around. This not only keeps the architecture clean, but it is absolutely essential to permit multiple views of the same model. A second primary goal is that any change to the model should cause the view to adjust itself accordingly without additional effort by the programmer. This involves more than just data bindings: creating a model should cause the view to be added to the display list, and removing a model from the document must cause the view to vanish.

A common approach to model objects in a graphical editor is to make them inherit from some big old AbstractModel superclass with a boatload of common code in it. This code consists of all the gears and wires to dispatch the right events when the model changes, or when its set of children changes, or when some descendant model changes, or to generate a stable ID for use in document persistence… a lot of junk.

By contrast, here is a SimpleWorld-style class (with comments removed for brevity):

```
    [RemoteClass]
    [Bindable]
    public class Square
    {
        public var x:Number;
        public var y:Number;
        public var size:Number;
    }
```

Hey, what’s up? This model class has no methods and extends... Object! (Actually, EventDispatcher, due to the Bindable tag, but we’re splitting hairs).

In Moccasin, there are actually two sets of model objects: the domain-specific model (that application programmers work with) and the framework model (that Moccasin deals with). The developer of a Moccasin app only writes code against the domain-specific model, and Moccasin automatically wraps that model object inside another object of type MoccasinModel. MoccasinModel is where the “framework junk” lives, but the application programmer doesn’t see it.

There is also going to be a corresponding View class to draw a Square on the screen — SquareView. Here’s a sense of what a view class looks like:

```
    public class SquareView extends ShapeView
    {
        public function SquareView(context:ViewContext, model:MoccasinModel=null)
        {
            super(context, model);
            initialize();
        }

        override protected function updateView():void
        {
            super.updateView();

            graphics.beginFill(0);
            var square:Square = model.value as Square;
            graphics.drawRect(0, 0, square.size, square.size);
            graphics.endFill();
        }

        override protected function createFeedbackView():DisplayObject
        {
            return new SquareFeedback(context, model);
        }
    }
```

Because of the strong decoupling between the view, the framework model and the domain-specific model, application programmers can wind up writing very pure code to manipulate the model that doesn’t have to have any dependencies on Moccasin. You can say something like mySquare.x += 100, and this will cause the framework to adjust the corresponding SquareView object to be redrawn in a different position. Changing an ‘x’ property doesn’t seem very exciting, but consider that it’s not SquareView’s ‘x’ property being changed: it’s the Square’s property. In fact, the relationship between model properties and view properties can be quite arbitrary. We could have some other view of our Squares besides a 2D rendering, perhaps a numerical SquareCoordinatesTable with an X column, and a Y column, and Moccasin would manage that model/view relationship in much the same way.