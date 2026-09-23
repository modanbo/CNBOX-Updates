package poliroid.views.battle.gunmarks
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class GunMarksPanelOld extends MovieClip implements IGunMarksPanel
   {
      
      public var labelText1:TextField;
      
      public var labelText2:TextField;
      
      public var labelText3:TextField;
      
      public var hitAreaA:MovieClip;
      
      public function GunMarksPanelOld()
      {
         super();
      }
      
      public function setData(param1:Object) : void
      {
         mouseEnabled = false;
         if(!param1.accountValidated || !param1.networkValidated && !param1.historyValidated)
         {
            this.labelText1.htmlText = "";
            this.labelText2.htmlText = "";
            this.labelText3.htmlText = param1.accountValidatedLabel;
            return;
         }
         this.labelText1.htmlText = param1.labelText1.toString();
         this.labelText2.htmlText = param1.labelText2.toString();
         this.labelText3.htmlText = param1.labelText3.toString();
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

