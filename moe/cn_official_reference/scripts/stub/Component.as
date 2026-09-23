package stub
{
   import flash.display.DisplayObject;
   
   public class Component
   {
      
      public var type:String = "Component";
      
      public var x:String = "";
      
      public var y:String = "";
      
      public var width:int = 0;
      
      public var height:int = 0;
      
      public var visible:Boolean = false;
      
      public var dispobj:DisplayObject = null;
      
      public var sibling_offset:int = 0;
      
      public function Component(type:String, x:String, y:String, width:int, height:int, visible:Boolean)
      {
         super();
         this.type = type;
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         this.visible = visible;
      }
      
      public function toString() : String
      {
         return "{componentStub" + this.type + ":" + this.x + "," + this.y + "," + this.width + "," + this.height + "}";
      }
   }
}

