package
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   import mx.core.BitmapAsset;
   import stub.Component;
   import stub.ImageComponent;
   import stub.TextComponent;
   
   public class Utils
   {
      
      private static var COLOR_INCARROW:int = 4128665;
      
      private static var COLOR_DESCARROW:int = 16733502;
      
      public function Utils()
      {
         super();
      }
      
      public static function changeDeltaDigit(container:DisplayObjectContainer, arrowStub:ImageComponent, deltaStub:TextComponent, delta:Number, isPercent:Boolean = false) : void
      {
         var delta_x:int = deltaStub.dispobj.x;
         var delta_y:int = deltaStub.dispobj.y;
         var arrow_x:int = arrowStub.dispobj.x;
         var arrow_y:int = arrowStub.dispobj.y;
         container.removeChild(arrowStub.dispobj);
         container.removeChild(deltaStub.dispobj);
         var deltaString:String = "";
         if(isPercent)
         {
            deltaString = Math.abs(delta).toFixed(2);
            deltaString += "%";
         }
         else
         {
            deltaString = Math.abs(delta).toFixed(0);
         }
         if(delta >= 0)
         {
            arrowStub.dispobj = new Const.ARROWINC_CLASS();
            (deltaStub.dispobj as TextField).textColor = Utils.COLOR_INCARROW;
         }
         else if(delta < 0)
         {
            arrowStub.dispobj = new Const.ARROWDESC_CLASS();
            (deltaStub.dispobj as TextField).textColor = Utils.COLOR_DESCARROW;
         }
         (deltaStub.dispobj as TextField).text = deltaString;
         arrowStub.dispobj.scaleX = arrowStub.dispobj.scaleY = Const.IMAGE_SCALE;
         deltaStub.dispobj.x = delta_x;
         deltaStub.dispobj.y = delta_y;
         arrowStub.dispobj.x = arrow_x;
         arrowStub.dispobj.y = arrow_y;
         container.addChild(arrowStub.dispobj);
         container.addChild(deltaStub.dispobj);
      }
      
      public static function adjustComponentList(cList:Array) : void
      {
         var this_dispobj:DisplayObject = null;
         var this_stub:Component = null;
         var prev_dispobj:DisplayObject = null;
         var span:int = 0;
         var prev_tf:TextField = null;
         for(var i:int = 1; i < cList.length; i++)
         {
            this_dispobj = cList[i].dispobj;
            this_stub = cList[i] as Component;
            prev_dispobj = cList[i - 1].dispobj;
            if(this_stub.sibling_offset != 0)
            {
               span = this_stub.sibling_offset;
               if(prev_dispobj is TextField)
               {
                  prev_tf = prev_dispobj as TextField;
                  this_dispobj.x = prev_tf.x + prev_tf.textWidth + span;
               }
               else if(prev_dispobj is BitmapAsset)
               {
                  if(this_dispobj is TextField)
                  {
                  }
                  this_dispobj.x = prev_dispobj.x + prev_dispobj.width + span;
               }
            }
         }
      }
      
      public static function createComponentList(stubs:Array) : Array
      {
         var i:int;
         var MouseOver:Function = null;
         var MouseOut:Function = null;
         var lastPos:int = 0;
         var thestub:Component = null;
         var gutter:int = 0;
         var tfstub:TextComponent = null;
         var tf:TextField = null;
         var rect:Rectangle = null;
         var tm:TextLineMetrics = null;
         var dispstub:ImageComponent = null;
         var asset:BitmapAsset = null;
         MouseOver = function(e:MouseEvent):void
         {
            var tf:TextField = null;
            var tm:TextLineMetrics = null;
            var rect:Rectangle = null;
            var disp:BitmapAsset = null;
            if(e.target is TextField)
            {
               tf = e.target as TextField;
               tm = tf.getLineMetrics(0);
               rect = tf.getCharBoundaries(0);
            }
            else if(e.target is BitmapAsset)
            {
               disp = e.target as BitmapAsset;
            }
         };
         MouseOut = function(e:MouseEvent):void
         {
            var tf:TextField = e.target as TextField;
            tf.background = false;
         };
         var comps:Array = [];
         for(i = 0; i < stubs.length; i++)
         {
            lastPos = 0;
            thestub = Component(stubs[i]);
            if(thestub.type == "TextField")
            {
               gutter = 2;
               tfstub = thestub as TextComponent;
               tf = App.textMgr.createTextField();
               tf.defaultTextFormat = new TextFormat("$FieldFont",tfstub.fontsize,tfstub.color,null,null,null,null,null,tfstub.align);
               tf.name = "TextField";
               tf.x = int(tfstub.x);
               tf.y = int(tfstub.y);
               tf.selectable = false;
               tf.mouseEnabled = false;
               if(tfstub.x.slice(0,1) == "+")
               {
                  thestub.sibling_offset = int(tfstub.x.slice(1));
               }
               tf.autoSize = TextFieldAutoSize.LEFT;
               tf.text = tfstub.text;
               rect = tf.getCharBoundaries(0);
               tm = tf.getLineMetrics(0);
               tf.x = int(tfstub.x);
               tf.y = int(tfstub.y) - tm.leading - gutter;
               tf.width = tfstub.width;
               tf.height = tfstub.height;
               tf.multiline = true;
               tf.selectable = false;
               tf.alpha = tfstub.alpha;
               thestub.dispobj = tf;
               comps.push(thestub);
            }
            else if(thestub.type == "Image")
            {
               dispstub = thestub as ImageComponent;
               asset = new dispstub.clazz();
               asset.name = "Image";
               if(dispstub.x.slice(0,1) == "+")
               {
                  thestub.sibling_offset = int(dispstub.x.slice(1));
               }
               asset.x = int(thestub.x);
               asset.y = int(thestub.y);
               asset.scaleX = asset.scaleY = Const.IMAGE_SCALE;
               asset.addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
               asset.addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
               dispstub.dispobj = asset;
               comps.push(dispstub);
            }
         }
         return comps;
      }
      
      public static function PrintStackTrace() : void
      {
         try
         {
            throw new Error("StackTrace");
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
      }
      
      public static function loadPanelPosition(pos:String) : PanelConfig
      {
         var lobby_x:int = int(pos.split(",")[0]);
         var lobby_y:int = int(pos.split(",")[1]);
         var battle_x:int = int(pos.split(",")[2]);
         var battle_y:int = int(pos.split(",")[3]);
         return new PanelConfig(lobby_x,lobby_y,battle_x,battle_y);
      }
   }
}

