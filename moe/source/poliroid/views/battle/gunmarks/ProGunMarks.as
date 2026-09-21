package poliroid.views.battle.gunmarks
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mods.common.BattleDisplayable;
   import net.wg.data.constants.Cursors;
   import scaleform.clik.events.ButtonEvent;

   /**
    * CNBOX presentation host.
    *
    * The calculation backend remains the original ProTanki Gun Marks Calculator.
    * This host fixes only the visible panel to the compact CNBOX skin while preserving
    * the original dragArea, offsetBattle restore and updatePosition callback.
    */
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

         if(this.panel_old) this.panel_old.visible = false;
         if(this.panel_new) this.panel_new.visible = false;
         if(this.panel_new_simple) this.panel_new_simple.visible = false;

         this.dragArea.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         this.dragArea.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.dragArea.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         this.dragArea.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.dragArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.minimizer.addEventListener(ButtonEvent.CLICK,this.handleMinimizerClick);
      }

      public function as_setSettings(param1:Object) : void
      {
         this.panel = this.panel_new_simple;

         if(this.panel_old) this.panel_old.visible = false;
         if(this.panel_new) this.panel_new.visible = false;

         if(this.panel_new_simple)
         {
            this.panel_new_simple.setSettings(param1);
            this.panel_new_simple.visible = true;
         }

         if(this.minimizer)
         {
            this.minimizer.setSettings(param1);
            this.minimizer.visible = false;
         }

         this.dragArea.mouseChildren = true;
         this.dragArea.mouseEnabled = true;

         if(this.panel)
         {
            this.dragArea.width = this.panel.panelWidth;
            this.dragArea.height = this.panel.panelHeight;
         }

         this._offset = param1.offsetBattle;
         if(!this._offset || this._offset.length < 2) this._offset = [0,0];

         this.anchorPointType = param1.anchorPoint;
         this.updateAnchorPoint();
         this.updateFrame();
      }

      public function as_setData(param1:Object) : void
      {
         if(this.minimizer) this.minimizer.setData(param1);
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
         var base:int = 100;
         var ax:int = base;
         var ay:int = base;

         switch(this.anchorPointType)
         {
            case "center":
               ax = int(App.appWidth / 2);
               ay = int(App.appHeight / 2);
               break;
            case "top-left":
               break;
            case "top-right":
               ax = int(App.appWidth - base * 3);
               break;
            case "bottom-left":
               ay = int(App.appHeight - base * 2);
               break;
            case "bottom-right":
               ax = int(App.appWidth - base * 3);
               ay = int(App.appHeight - base * 2);
         }

         this.anchorPoint = new Point(ax,ay);
      }

      private function updateFrame() : void
      {
         if(this._dragging) return;

         this.dragArea.x = this.anchorPoint.x + Number(this._offset[0]);
         this.dragArea.y = this.anchorPoint.y + Number(this._offset[1]);
         this._syncPositions();
      }

      private function handleMouseDown() : void
      {
         if(this._dragging) return;

         this._dragging = true;
         App.cursor.forceSetCursor(Cursors.MOVE);
         this.dragArea.startDrag();
      }

      private function handleMouseMove() : void
      {
         if(!this._dragging) return;
         this._syncPositions();
      }

      private function handleMouseUp() : void
      {
         var origin:Point = null;
         if(!this._dragging) return;

         origin = this.getAncor();
         this._dragging = false;
         this.dragArea.stopDrag();

         this._offset = [
            int(this.dragArea.x - origin.x),
            int(this.dragArea.y - origin.y)
         ];

         this.updateFrame();

         if(this.updatePosition != null)
         {
            // Original ProTanki persistence hand-off. The backend stores offsetBattle and
            // provides it back to as_setSettings in the next battle/client session.
            this.updatePosition(this._offset);
         }

         App.cursor.forceSetCursor(Cursors.DRAG_OPEN);
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
         // The compact CNBOX skin intentionally hides the stock minimizer.
      }

      private function _syncPositions() : void
      {
         var px:int = int(Math.max(0,Math.min(App.appWidth - this.dragArea.width,this.dragArea.x)));
         var py:int = int(Math.max(0,Math.min(App.appHeight - this.dragArea.height,this.dragArea.y)));

         this.dragArea.x = px;
         this.dragArea.y = py;

         if(this.minimizer)
         {
            this.minimizer.x = px + this.dragArea.width + 10;
            this.minimizer.y = py + 5;
         }

         if(this.panel)
         {
            this.panel.x = px;
            this.panel.y = py;
         }
      }

      private function getAncor() : Point
      {
         return this.anchorPoint;
      }
   }
}
