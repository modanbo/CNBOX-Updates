package poliroid.views.battle.gunmarks
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mods.common.BattleDisplayable;
   import net.wg.data.constants.Cursors;
   import scaleform.clik.events.ButtonEvent;
   
   public class ProGunMarks extends BattleDisplayable
   {
      
      public var dragArea:MovieClip;
      
      public var minimizer:GunMarksMinimizer = null;
      
      public var panel_old:IGunMarksPanel = null;
      
      public var panel_new:IGunMarksPanel = null;
      
      public var panel_new_simple:IGunMarksPanel = null;
      
      private var panel:IGunMarksPanel = null;
      
      public var updatePosition:Function = null;
      
      public var updateMinimized:Function = null;
      
      private var _dragging:Boolean = false;
      
      private var _offset:Array = [0,0];
      
      private var anchorPoint:Point = null;
      
      private var anchorPointType:String = null;
      
      public function ProGunMarks()
      {
         super();
      }
      
      override protected function onPopulate() : void
      {
         mouseEnabled = false;
         this.anchorPoint = new Point(0,0);
         super.onPopulate();
         if(this.panel_old)
         {
            this.panel_old.visible = false;
         }
         if(this.panel_new)
         {
            this.panel_new.visible = false;
         }
         if(this.panel_new_simple)
         {
            this.panel_new_simple.visible = false;
         }
         this.dragArea.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         this.dragArea.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.dragArea.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         this.dragArea.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.dragArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.minimizer.addEventListener(ButtonEvent.CLICK,this.handleMinimizerClick);
      }
      
      public function as_setSettings(param1:Object) : void
      {
         // NAJXBox 1.1.2 presentation routing:
         // use the official 147x93 panel for all upstream skin variants.
         // Drag/events/offset persistence below remain original ProTanki code.
         if(param1.skinVariant == "old" || param1.skinVariant == "new" || param1.skinVariant == "new-simple")
         {
            this.panel = this.panel_new;
         }
         if(this.panel)
         {
            this.panel.setSettings(param1);
            this.panel.visible = !param1.battleMinimized;
         }
         this.minimizer.setSettings(param1);
         this.dragArea.mouseChildren = !param1.battleMinimized;
         this.dragArea.mouseEnabled = !param1.battleMinimized;
         if(this.panel)
         {
            this.dragArea.width = this.panel.panelWidth;
            this.dragArea.height = this.panel.panelHeight;
         }
         this._offset = param1.offsetBattle;
         this.anchorPointType = param1.anchorPoint;
         this.updateAnchorPoint();
         this.updateFrame();
      }
      
      public function as_setData(param1:Object) : void
      {
         if(this.minimizer)
         {
            this.minimizer.setData(param1);
         }
         if(this.panel)
         {
            this.panel.setData(param1);
            this.dragArea.width = this.panel.panelWidth;
            this.dragArea.height = this.panel.panelHeight;
         }
      }
      
      public function as_setVisible(param1:Boolean) : void
      {
         visible = param1;
      }
      
      override protected function onResized() : void
      {
         this.updateAnchorPoint();
         this.updateFrame();
      }
      
      private function updateAnchorPoint() : void
      {
         var _loc1_:int = 100;
         var _loc2_:int = _loc1_;
         var _loc3_:int = _loc1_;
         switch(this.anchorPointType)
         {
            case "center":
               _loc2_ = int(App.appWidth / 2);
               _loc3_ = int(App.appHeight / 2);
               break;
            case "top-left":
               break;
            case "top-right":
               _loc2_ = int(App.appWidth - _loc1_ * 3);
               break;
            case "bottom-left":
               _loc3_ = int(App.appHeight - _loc1_ * 2);
               break;
            case "bottom-right":
               _loc2_ = int(App.appWidth - _loc1_ * 3);
               _loc3_ = int(App.appHeight - _loc1_ * 2);
         }
         this.anchorPoint = new Point(_loc2_,_loc3_);
      }
      
      private function updateFrame() : void
      {
         if(this._dragging)
         {
            return;
         }
         this.dragArea.x = this.anchorPoint.x + this._offset[0];
         this.dragArea.y = this.anchorPoint.y + this._offset[1];
         this._syncPositions();
      }
      
      private function handleMouseDown() : void
      {
         if(this._dragging)
         {
            return;
         }
         this._dragging = true;
         App.cursor.forceSetCursor(Cursors.MOVE);
         this.dragArea.startDrag();
      }
      
      private function handleMouseMove() : void
      {
         if(!this._dragging)
         {
            return;
         }
         this._syncPositions();
      }
      
      private function handleMouseUp() : void
      {
         var _loc1_:Point = null;
         if(this._dragging)
         {
            _loc1_ = this.getAncor();
            this._dragging = false;
            this.dragArea.stopDrag();
            this._offset = [int(this.dragArea.x - _loc1_.x),int(this.dragArea.y - _loc1_.y)];
            this.updateFrame();
            this.updatePosition(this._offset);
            App.cursor.forceSetCursor(Cursors.DRAG_OPEN);
         }
         else
         {
            this.updateMinimized();
         }
      }
      
      private function handleMouseOver() : void
      {
         App.cursor.forceSetCursor(Cursors.DRAG_OPEN);
      }
      
      private function handleMouseOut() : void
      {
         App.cursor.forceSetCursor(Cursors.ARROW);
      }
      
      private function handleMinimizerClick() : void
      {
         this.updateMinimized();
      }
      
      private function _syncPositions() : void
      {
         var _loc1_:int = int(Math.max(0,Math.min(App.appWidth - this.dragArea.width,this.dragArea.x)));
         var _loc2_:int = int(Math.max(0,Math.min(App.appHeight - this.dragArea.height,this.dragArea.y)));
         this.dragArea.x = _loc1_;
         this.dragArea.y = _loc2_;
         if(this.minimizer)
         {
            this.minimizer.x = _loc1_ + this.dragArea.width + 10;
            this.minimizer.y = _loc2_ + 5;
         }
         if(this.panel)
         {
            this.panel.x = _loc1_;
            this.panel.y = _loc2_;
         }
      }
      
      private function getAncor() : Point
      {
         return this.anchorPoint;
      }
   }
}

