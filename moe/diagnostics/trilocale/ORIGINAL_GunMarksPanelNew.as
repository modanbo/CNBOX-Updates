package poliroid.views.battle.gunmarks
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class GunMarksPanelNew extends MovieClip implements IGunMarksPanel
   {
      
      public var hitAreaA:MovieClip;
      
      public var progressBar:MovieClip = null;
      
      public var drPredicted:TextField = null;
      
      public var drPredictedDelta:TextField = null;
      
      public var nextMarkLabel:TextField = null;
      
      public var nextMarkValue:TextField = null;
      
      public var currentMovingDamage:TextField;
      
      public var predictedMovingDamage:TextField;
      
      public var damageCurrentLabel:TextField;
      
      public var accountInfoLabel:TextField;
      
      public var background:MovieClip;
      
      public function GunMarksPanelNew()
      {
         super();
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
      
      public function setData(param1:Object) : void
      {
         this._updateElements(param1);
         this._updateLabels(param1);
         this._updateLayout(param1);
      }
      
      private function _updateElements(param1:Object) : void
      {
         var _loc2_:* = "";
         if(Boolean(param1.accountValidated) && (Boolean(param1.historyValidated) || Boolean(param1.networkValidated)))
         {
            if(param1.deltaRating < 0)
            {
               _loc2_ += "down";
            }
            else if(param1.deltaRating > 0)
            {
               _loc2_ += "up";
            }
            else
            {
               _loc2_ += "same";
            }
            if(_loc2_ == "down" && Boolean(param1.colorBlind))
            {
               _loc2_ += "-blind";
            }
            if(Boolean(param1.isAlternateMode) && Boolean(param1.networkValidated))
            {
               _loc2_ += "-alt";
            }
         }
         else
         {
            _loc2_ = "unavailable";
         }
         gotoAndStop(_loc2_);
         if(this.background)
         {
            this.background.mouseEnabled = false;
         }
         if(this.progressBar)
         {
            this.progressBar.gotoAndStop(param1.damagePercent);
         }
         if(param1.displayGunMark)
         {
            this.background.gotoAndStop("mark_" + param1.currentGunMark);
         }
         else
         {
            this.background.gotoAndStop("default");
         }
      }
      
      private function _updateLayout(param1:Object) : void
      {
         if(this.currentMovingDamage)
         {
            this.currentMovingDamage.x = int(this.predictedMovingDamage.x + this.predictedMovingDamage.width - this.predictedMovingDamage.textWidth - this.currentMovingDamage.textWidth) - 4;
         }
         if(!this.drPredicted || !this.drPredictedDelta)
         {
            return;
         }
         var _loc2_:* = int(this.drPredicted.textWidth) + int(this.drPredictedDelta.textWidth) + 20;
         var _loc3_:* = int((190 - _loc2_) / 2) + 5;
         this.drPredicted.x = _loc3_;
         _loc3_ += int(this.drPredicted.textWidth);
         _loc3_ += 10;
         this.drPredictedDelta.x = _loc3_;
      }
      
      private function _updateLabels(param1:Object) : void
      {
         this._updateLabel(this.drPredicted,param1.predictedRatingLabel);
         this._updateLabel(this.drPredictedDelta,param1.deltaRatingLabel);
         this._updateLabel(this.predictedMovingDamage,param1.predictedMovingDamage);
         this._updateLabel(this.currentMovingDamage,param1.currentMovingDamage);
         this._updateLabel(this.damageCurrentLabel,param1.damageCurrentLabel);
         this._updateLabel(this.nextMarkLabel,param1.nextMarkLabel);
         this._updateLabel(this.nextMarkValue,param1.nextMarkValue);
         this._updateLabel(this.accountInfoLabel,param1.accountValidatedLabel);
      }
      
      private function _updateLabel(param1:TextField, param2:String) : void
      {
         if(Boolean(param1) && param1.text != param2)
         {
            param1.text = param2;
         }
      }
   }
}

