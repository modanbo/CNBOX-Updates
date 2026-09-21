package poliroid.views.battle.gunmarks
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class GunMarksPanelNewSimple extends MovieClip implements IGunMarksPanel
   {
      
      public var hitAreaA:MovieClip;
      
      public var progress:MovieClip;
      
      public var mainLabel:TextField;
      
      public var helpLabel:TextField;
      
      public var externalLabel:TextField;
      
      public function GunMarksPanelNewSimple()
      {
         super();
      }
      
      public function setData(param1:Object) : void
      {
         if(!param1.networkValidated && !param1.historyValidated || !param1.accountValidated)
         {
            this.helpLabel.text = "";
            this.mainLabel.text = "";
            this.progress.gotoAndStop(0);
            this.externalLabel.text = param1.accountValidatedLabel;
            return;
         }
         this.externalLabel.text = "";
         if(this.progress)
         {
            this.progress.gotoAndStop(param1.damagePercent);
         }
         if(Boolean(param1.isAlternateMode) && (Boolean(param1.networkValidated) || Boolean(param1.historyValidated)))
         {
            this.mainLabel.text = param1.predictedRating;
            this.helpLabel.text = param1.showExternal ? param1.deltaRating : "";
         }
         else
         {
            this.mainLabel.text = param1.battleMovingDamage;
            this.helpLabel.text = param1.showExternal ? param1.deltaDamage : "";
         }
      }
      
      public function setSettings(param1:Object) : void
      {
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      public function get panelHeight() : int
      {
         return this.hitAreaA.height;
      }
      
      public function get panelWidth() : int
      {
         return this.hitAreaA.width;
      }
   }
}

