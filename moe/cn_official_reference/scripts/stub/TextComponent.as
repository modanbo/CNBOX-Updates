package stub
{
   public class TextComponent extends Component
   {
      
      public var text:String = "";
      
      public var color:int = 16711422;
      
      public var fontsize:int = 10;
      
      public var align:String = "center";
      
      public var alpha:Number = 1;
      
      public function TextComponent(x:String, y:String, width:int, height:int, visible:Boolean, text:String, color:int, fontsize:int, alpha:Number = 1, align:String = "left")
      {
         type = "TextField";
         super(type,x,y,width,height,visible);
         this.text = text;
         this.color = color;
         this.fontsize = fontsize;
         this.align = align;
         this.alpha = alpha;
      }
      
      override public function toString() : String
      {
         var ret:String = "{TextComponent:" + x + "," + y + "," + this.text + "," + width + "," + height + "," + this.fontsize + "," + this.align + "," + dispobj + "," + sibling_offset + "}";
         if(dispobj != null)
         {
            ret += "[" + dispobj.name + "]@(" + dispobj.x + "," + dispobj.y + ")";
         }
         return ret;
      }
   }
}

