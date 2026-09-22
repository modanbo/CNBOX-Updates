package de.champi.wot.evv.views.battle
{
   import mods.shared.BattleDisplayable;

   /**
    * CNBOX garage-only EVV bridge.
    *
    * Keep CHAMPi EVV2's Python backend, garage GameFace model and settings intact,
    * but intentionally render no EVV battle panel because ProTanki owns the
    * user-facing battle MoE panel in the combined CNBOX component.
    *
    * Public callback names are preserved so the original protected backend may
    * continue calling the view without exceptions.
    */
   public class ExpectedVehicleValueBattle extends BattleDisplayable
   {
      public var py_getSettings:Function;
      public var py_savePosition:Function;

      public function ExpectedVehicleValueBattle()
      {
         super();
      }

      override protected function onPopulate() : void
      {
         super.onPopulate();
      }

      override protected function onBeforeDispose() : void
      {
         super.onBeforeDispose();
      }

      override protected function onResized() : void
      {
      }

      public function as_setScale(param1:Number) : void
      {
      }

      public function as_setText(param1:String) : void
      {
      }

      public function as_setText_WNX(param1:String) : void
      {
      }

      public function as_setPanelsVisible(param1:Boolean) : void
      {
      }

      public function as_settingsChanged() : void
      {
      }
   }
}
