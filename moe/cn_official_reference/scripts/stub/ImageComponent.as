package stub
{
   public class ImageComponent extends Component
   {
      
      public var clazz:Class = null;
      
      public function ImageComponent(x:String, y:String, width:int, height:int, visible:Boolean, clazz:Class)
      {
         type = "Image";
         super(type,x,y,width,height,visible);
         this.clazz = clazz;
         this.visible = visible;
      }
      
      override public function toString() : String
      {
         var ret:String = "{ImageComponent:" + type + ":" + x + "," + y + "," + width + "," + height + "," + this.clazz + "," + visible + "," + dispobj + "," + sibling_offset + "}";
         if(dispobj != null)
         {
            ret += "[" + dispobj.name + "]@(" + dispobj.x + "," + dispobj.y + ")";
         }
         return ret;
      }
   }
}

