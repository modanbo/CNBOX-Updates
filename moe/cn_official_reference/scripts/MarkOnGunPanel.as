package
{
   import com.adobe.serialization.json.JSONDecoder;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.utils.Timer;
   import net.wg.data.constants.Cursors;
   import stub.Component;
   
   public class MarkOnGunPanel extends MovieClip
   {
      
      private var sn:Number = 0;
      
      private var _backgroundId:int = -1;
      
      private var data:Array = null;
      
      private var bgCache:Object;
      
      private var componentList:Array;
      
      public var bgHolder:Sprite;
      
      private var isHover:Boolean = false;
      
      private var parentView:MarkOnGunUI = null;
      
      private var arcShape:Shape = null;
      
      public function MarkOnGunPanel()
      {
         var date:Date = null;
         this.bgCache = new Object();
         this.componentList = [];
         this.bgHolder = new Sprite();
         try
         {
            x = 1255;
            y = 665;
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            addChildAt(this.bgHolder,0);
            this.bgCache[Const.LOBBY_NORMAL_ID] = new Const.LOBBY_NORMAL_BG_CLASS();
            this.bgCache[Const.LOBBY_HOVER_ID] = new Const.LOBBY_HOVER_BG_CLASS();
            date = new Date();
            this.sn = date.time;
            this.drawPanel();
            trace("========================" + this + " created==========================");
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
         super();
      }
      
      override public function toString() : String
      {
         return "MarkOnGunPanel[sn=" + this.sn + "]";
      }
      
      public function setParentView(parent:MarkOnGunUI) : void
      {
         try
         {
            this.parentView = parent;
            if(this.parentView != null)
            {
               if(MarkOnGunUI.panelConfig == null)
               {
                  MarkOnGunUI.panelConfig = Utils.loadPanelPosition(this.parentView.getPanelPosition());
               }
               x = MarkOnGunUI.panelConfig.lobby_x;
               y = MarkOnGunUI.panelConfig.lobby_y;
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
         trace("parentView is now" + this.parentView);
      }
      
      private function getViewID() : int
      {
         var viewid:int = 0;
         viewid = Const.LOBBY_NORMAL_ID;
         if(this.isHover)
         {
            viewid++;
         }
         return viewid;
      }
      
      private function getViewType(viewid:int) : int
      {
         return Const.VIEW_LOBBY;
      }
      
      private function drawPanel() : void
      {
         var max_x:int = 0;
         var max_y:int = 0;
         var i:int = 0;
         var dispobj:DisplayObject = null;
         try
         {
            max_x = 0;
            max_y = 0;
            this.setBackground();
            if(this.componentList.length == 0)
            {
               trace("generating component for lobbypanel");
               this.componentList = Utils.createComponentList(Const.LOBBYCOMPONENTS);
               for(i = 0; i < this.componentList.length; i++)
               {
                  dispobj = (this.componentList[i] as Component).dispobj;
                  addChild(dispobj);
                  trace("will trigger=" + dispobj.willTrigger(MouseEvent.ROLL_OVER));
                  if(dispobj.x + dispobj.width > max_x)
                  {
                     max_x = dispobj.x + dispobj.width;
                  }
                  if(dispobj.y + dispobj.height > max_y)
                  {
                     max_y = dispobj.y + dispobj.height;
                  }
               }
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
      }
      
      public function updateData(sourcedata:Array, reason:String) : void
      {
         var i:int = 0;
         try
         {
            i = 0;
            if(this.data == null)
            {
               this.data = new Array();
               for(i = 0; i < sourcedata.length; i++)
               {
                  this.data.push(sourcedata[i]);
               }
            }
            else
            {
               for(i = 0; i < sourcedata.length; i++)
               {
                  this.data[i] = sourcedata[i];
               }
            }
            trace("2. lobbypanel got " + this.data + " due to " + reason);
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
      }
      
      private function timerhandler(event:TimerEvent) : void
      {
         var timer:Timer = event.target as Timer;
         this.updateDisplay("timer",timer);
      }
      
      public function clearPercentile() : void
      {
         this.componentList[Const.LOBBYCOMP_65].dispobj.text = "---";
         this.componentList[Const.LOBBYCOMP_85].dispobj.text = "---";
         this.componentList[Const.LOBBYCOMP_95].dispobj.text = "---";
         this.componentList[Const.LOBBYCOMP_100].dispobj.text = "---";
      }
      
      public function updateDisplay(reason:String = "update", timer:Timer = null) : void
      {
         var parentViewData:Array = null;
         var tank_id:String = null;
         var percentage:Number = NaN;
         var markOnGun:int = 0;
         var dest_deg:int = 0;
         var glowFilter:GlowFilter = null;
         var shadowFilter:DropShadowFilter = null;
         var filterArray:Array = null;
         var mx:Matrix = null;
         try
         {
            if(this.data == null)
            {
               if(this.parentView != null)
               {
                  parentViewData = this.parentView.data;
                  trace("in panel data retrieve , got data=" + parentViewData);
                  this.data = parentViewData.slice();
                  trace("data in lobbypanel is copied from parent");
                  this.visible = true;
               }
               else
               {
                  trace("in panel data retrieve ,parentView is null");
                  this.visible = false;
               }
            }
            trace("parentView=" + this.parentView);
            if(this.data != null)
            {
               this.visible = this.data[Const.DATA_VISIBLE];
               trace("in lobbypanel updateDisplay due to " + reason);
               tank_id = this.data[Const.DATA_TANK_ID];
               this.componentList[Const.LOBBYCOMP_DR].dispobj.text = Number(this.data[Const.DATA_DAMAGE_RATING]).toFixed(2) + "%";
               this.componentList[Const.LOBBYCOMP_MAD].dispobj.text = Number(this.data[Const.DATA_MOVING_AVG_DAMAGE]).toFixed(0);
               this.componentList[Const.LOBBYCOMP_DELTA].dispobj.text = Number(this.data[Const.DATA_LOBBY_DELTA]).toFixed(2) + "%";
               this.componentList[Const.LOBBYCOMP_65].dispobj.text = this.getPercentile(65);
               this.componentList[Const.LOBBYCOMP_85].dispobj.text = this.getPercentile(85);
               this.componentList[Const.LOBBYCOMP_95].dispobj.text = this.getPercentile(95);
               this.componentList[Const.LOBBYCOMP_100].dispobj.text = this.getPercentile(100);
               percentage = Number(this.data[Const.DATA_DAMAGE_RATING]);
               markOnGun = int(this.data[Const.DATA_MARKONGUN]);
               this.changeStars(markOnGun);
               Utils.changeDeltaDigit(this,this.componentList[Const.LOBBYCOMP_ARROW],this.componentList[Const.LOBBYCOMP_DELTA],this.data[Const.DATA_LOBBY_DELTA],true);
               dest_deg = percentage / 100 * 360;
               if(this.arcShape != null)
               {
                  removeChild(this.arcShape);
               }
               this.arcShape = new Shape();
               this.arcShape.graphics.beginFill(16772812);
               this.arcShape.graphics.moveTo(20,0);
               this.drawArc(this.arcShape.graphics,20,20,20,0,dest_deg,true);
               this.drawArc(this.arcShape.graphics,20,20,12,dest_deg,0,true);
               this.arcShape.graphics.lineTo(20,0);
               this.arcShape.graphics.endFill();
               glowFilter = new GlowFilter(7033401,128,128);
               shadowFilter = new DropShadowFilter(1);
               filterArray = new Array();
               filterArray[0] = glowFilter;
               this.arcShape.filters = filterArray;
               mx = new Matrix();
               mx.translate(20,24);
               this.arcShape.transform.matrix = mx;
               addChild(this.arcShape);
               Utils.adjustComponentList(this.componentList);
            }
         }
         catch(e:Error)
         {
            trace("caught error");
            trace(e.getStackTrace());
         }
      }
      
      private function getPercentile(percent:int) : String
      {
         var jsonString:String = null;
         var result:Object = null;
         var ret:String = "--";
         try
         {
            jsonString = this.data[Const.DATA_MDICT];
            result = new JSONDecoder(jsonString,false).getValue();
            if(result.tank_id == undefined)
            {
               ret = "--";
            }
            else
            {
               ret = Number(result[String(percent)]).toFixed(0);
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
         return ret;
      }
      
      private function changeStars(markOnGun:int) : void
      {
         if(markOnGun == 0)
         {
            this.refreshStar(Const.LOBBYCOMP_STAR1,false);
            this.refreshStar(Const.LOBBYCOMP_STAR2,false);
            this.refreshStar(Const.LOBBYCOMP_STAR3,false);
         }
         else if(markOnGun == 1)
         {
            this.refreshStar(Const.LOBBYCOMP_STAR1,true);
            this.refreshStar(Const.LOBBYCOMP_STAR2,false);
            this.refreshStar(Const.LOBBYCOMP_STAR3,false);
         }
         else if(markOnGun == 2)
         {
            this.refreshStar(Const.LOBBYCOMP_STAR1,true);
            this.refreshStar(Const.LOBBYCOMP_STAR2,true);
            this.refreshStar(Const.LOBBYCOMP_STAR3,false);
         }
         else if(markOnGun == 3)
         {
            this.refreshStar(Const.LOBBYCOMP_STAR1,true);
            this.refreshStar(Const.LOBBYCOMP_STAR2,true);
            this.refreshStar(Const.LOBBYCOMP_STAR3,true);
         }
      }
      
      private function refreshStar(index:int, litOrNot:Boolean) : void
      {
         var star_x:int = int(this.componentList[index].dispobj.x);
         var star_y:int = int(this.componentList[index].dispobj.y);
         removeChild(this.componentList[index].dispobj);
         if(litOrNot)
         {
            this.componentList[index].dispobj = new Const.LIGHTSTAR_CLASS();
         }
         else
         {
            this.componentList[index].dispobj = new Const.DARKSTAR_CLASS();
         }
         this.componentList[index].dispobj.scaleX = this.componentList[index].dispobj.scaleY = Const.IMAGE_SCALE;
         addChild(this.componentList[index].dispobj);
         this.componentList[index].dispobj.x = star_x;
         this.componentList[index].dispobj.y = star_y;
      }
      
      public function drawArc(graphics:Graphics, center_x:Number, center_y:Number, radius:Number, angle_from:Number, angle_to:Number, initialLine:Boolean, precision:Number = 1) : void
      {
         var radian:Number = NaN;
         var degreeToRadian:Number = 0.0174532925;
         var angle_diff:Number = angle_to - angle_from;
         var steps:Number = Math.abs(Math.round(angle_diff * precision));
         var angle:Number = angle_from;
         var px:Number = center_x + radius * Math.sin(angle * degreeToRadian);
         var py:Number = center_y - radius * Math.cos(angle * degreeToRadian);
         if(initialLine)
         {
            graphics.lineTo(px,py);
         }
         else
         {
            graphics.moveTo(px,py);
         }
         for(var i:int = 1; i <= steps; i++)
         {
            radian = (angle_from + angle_diff / steps * i) * degreeToRadian;
            graphics.lineTo(center_x + radius * Math.sin(radian),center_y - radius * Math.cos(radian));
         }
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         trace("onMouseDown");
         App.cursor.forceSetCursor(Cursors.MOVE);
         startDrag();
      }
      
      private function onRollOver(e:MouseEvent) : void
      {
         trace("onRollOver");
         this.isHover = true;
         App.cursor.forceSetCursor(Cursors.DRAG_OPEN);
         this.drawPanel();
      }
      
      private function onRollOut(e:MouseEvent) : void
      {
         trace("onRollOut");
         this.isHover = false;
         App.cursor.forceSetCursor(Cursors.ARROW);
         stopDrag();
         if(this.parentView != null)
         {
            this.parentView.savePosition(false,this.x,this.y);
         }
         this.drawPanel();
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         trace("onMouseUp");
         this.bgHolder.stopDrag();
         if(this.parentView != null)
         {
            this.parentView.savePosition(false,this.x,this.y);
         }
         App.cursor.forceSetCursor(Cursors.DRAG_OPEN);
      }
      
      public function setBackground(id:int = -1) : void
      {
         if(id == -1)
         {
            id = this.isHover ? 1 : 0;
         }
         var background:DisplayObject = this.bgCache[id];
         if(this._backgroundId != id)
         {
            this._backgroundId = id;
            this.updateBgHolder(background);
         }
      }
      
      protected function updateBgHolder(background:DisplayObject) : void
      {
         this.clearBackground();
         this.bgHolder.scaleX = this.bgHolder.scaleY = Const.IMAGE_SCALE;
         this.bgHolder.addChild(background);
      }
      
      private function clearBackground() : void
      {
         if(this.bgHolder.numChildren > 0)
         {
            trace("removing child (" + this.bgHolder.numChildren + ")");
            this.bgHolder.removeChildAt(0);
         }
      }
   }
}

