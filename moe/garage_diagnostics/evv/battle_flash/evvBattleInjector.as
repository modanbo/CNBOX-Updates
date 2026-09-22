package
{
   import de.champi.wot.evv.views.battle.ExpectedVehicleValueBattle;
   import mods.shared.AbstractComponentInjector;
   
   [SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="30")]
   public dynamic class evvBattleInjector extends AbstractComponentInjector
   {
      
      public static const ResourceHackerInfo:String = "Dear Resourcehacker! Welcome to AS3. If you need any help to read the decompiled flash source feel free to send me a message and i\'ll try to help you. :)";
      
      public function evvBattleInjector()
      {
         super();
      }
      
      override protected function onPopulate() : void
      {
         autoDestroy = false;
         componentName = "ExpectedVehicleValueBattleView";
         componentUI = ExpectedVehicleValueBattle;
         super.onPopulate();
      }
   }
}

