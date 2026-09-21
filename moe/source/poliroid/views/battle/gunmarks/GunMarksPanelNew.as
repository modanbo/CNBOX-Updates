package poliroid.views.battle.gunmarks
{
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   /**
    * CNBOX compact MoE presentation for ProTanki's stock "new" panel.
    *
    * Runtime-safety rule for 1.0.5:
    * - original ProGunMarks host is untouched;
    * - original timeline TextFields are reused (no new font-dependent TextFields);
    * - calculation/backend remains untouched;
    * - only panel labels/layout/background/arrows are presentation changes.
    */
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

      private var _built:Boolean = false;
      private var _back:Shape;
      private var _percentArrow:Sprite;
      private var _averageArrow:Sprite;

      private static const PANEL_W:Number = 192;
      private static const PANEL_H:Number = 120;
      private static const PAD_X:Number = 20;
      private static const WHITE:uint = 0xF2F0E8;
      private static const MUTED:uint = 0xE0DED4;
      private static const GREEN:uint = 0x2FDAA1;
      private static const RED:uint = 0xCB4E52;

      public function GunMarksPanelNew()
      {
         super();
      }

      public function setSettings(param1:Object) : void
      {
         this._ensureUi();
         mouseChildren = false;
         mouseEnabled = false;
      }

      public function get panelHeight() : int
      {
         this._ensureUi();
         return int(PANEL_H);
      }

      public function get panelWidth() : int
      {
         this._ensureUi();
         return int(PANEL_W);
      }

      public function setData(param1:Object) : void
      {
         this._ensureUi();

         if(!param1 || !param1.accountValidated || !param1.networkValidated && !param1.historyValidated)
         {
            this._setUnavailable(param1 ? this._s(param1.accountValidatedLabel) : "");
            return;
         }

         this._showNormalFields();

         this.drPredicted.text = this._s(param1.predictedRating);
         this.nextMarkValue.text = this._cleanDamage(this._s(param1.battleMovingDamage));
         this.predictedMovingDamage.text = this._cleanDamage(this._s(param1.predictedMovingDamage));

         this._setDelta(this.drPredictedDelta,this._percentArrow,this._s(param1.deltaRating),true);
         this._setDelta(this.currentMovingDamage,this._averageArrow,this._s(param1.deltaDamage),false);

         this._layoutTopRow();
         this._layoutAverageRow();
      }

      private function _ensureUi() : void
      {
         if(this._built) return;
         this._built = true;

         if(this.background) this.background.visible = false;
         if(this.progressBar) this.progressBar.visible = false;

         this._back = new Shape();
         this._back.graphics.lineStyle(1,0xD8D6CC,0.28);
         this._back.graphics.beginFill(0x10130F,0.43);
         this._back.graphics.drawRect(0,0,PANEL_W,PANEL_H);
         this._back.graphics.endFill();
         this._back.mouseEnabled = false;
         addChildAt(this._back,0);

         if(this.hitAreaA)
         {
            this.hitAreaA.width = PANEL_W;
            this.hitAreaA.height = PANEL_H;
            this.hitAreaA.alpha = 0;
            this.hitAreaA.visible = true;
         }

         // Reuse the SWF's already-created text fields and their embedded font linkage.
         this._styleField(this.drPredicted,20,true,WHITE,PAD_X,14,82,29,TextFormatAlign.LEFT);
         this._styleField(this.drPredictedDelta,15,true,WHITE,112,17,70,23,TextFormatAlign.LEFT);

         this._styleField(this.damageCurrentLabel,16,true,MUTED,PAD_X,50,80,24,TextFormatAlign.LEFT);
         this.damageCurrentLabel.text = "\u672c\u573a\u6807\u4f24";

         this._styleField(this.nextMarkValue,16,true,WHITE,103,50,71,24,TextFormatAlign.LEFT);

         this._styleField(this.nextMarkLabel,16,true,MUTED,PAD_X,82,80,24,TextFormatAlign.LEFT);
         this.nextMarkLabel.text = "\u5e73\u5747\u6807\u4f24";

         this._styleField(this.predictedMovingDamage,16,true,WHITE,103,82,51,24,TextFormatAlign.LEFT);
         this._styleField(this.currentMovingDamage,15,true,WHITE,163,84,26,22,TextFormatAlign.LEFT);

         this._styleField(this.accountInfoLabel,14,false,MUTED,10,43,PANEL_W - 20,28,TextFormatAlign.CENTER);
         this.accountInfoLabel.visible = false;

         this._percentArrow = new Sprite();
         this._percentArrow.mouseEnabled = false;
         this._percentArrow.mouseChildren = false;
         addChild(this._percentArrow);

         this._averageArrow = new Sprite();
         this._averageArrow.mouseEnabled = false;
         this._averageArrow.mouseChildren = false;
         addChild(this._averageArrow);

         this._showNormalFields();
      }

      private function _styleField(field:TextField, size:Number, bold:Boolean, color:uint,
                                   xPos:Number, yPos:Number, widthValue:Number, heightValue:Number,
                                   alignValue:String) : void
      {
         if(!field) return;

         var format:TextFormat = field.defaultTextFormat;
         format.size = size;
         format.bold = bold;
         format.color = color;
         format.align = alignValue;

         field.defaultTextFormat = format;
         field.setTextFormat(format);
         field.x = xPos;
         field.y = yPos;
         field.width = widthValue;
         field.height = heightValue;
         field.selectable = false;
         field.mouseEnabled = false;
         field.multiline = false;
         field.wordWrap = false;
         field.antiAliasType = AntiAliasType.ADVANCED;
         field.filters = [new DropShadowFilter(1,90,0x000000,0.86,2,2,1.5,1)];
         field.visible = true;
      }

      private function _showNormalFields() : void
      {
         if(this.drPredicted) this.drPredicted.visible = true;
         if(this.drPredictedDelta) this.drPredictedDelta.visible = true;
         if(this.damageCurrentLabel) this.damageCurrentLabel.visible = true;
         if(this.nextMarkValue) this.nextMarkValue.visible = true;
         if(this.nextMarkLabel) this.nextMarkLabel.visible = true;
         if(this.predictedMovingDamage) this.predictedMovingDamage.visible = true;
         if(this.currentMovingDamage) this.currentMovingDamage.visible = true;
         if(this.accountInfoLabel) this.accountInfoLabel.visible = false;
      }

      private function _setUnavailable(value:String) : void
      {
         if(this.drPredicted) this.drPredicted.visible = false;
         if(this.drPredictedDelta) this.drPredictedDelta.visible = false;
         if(this.damageCurrentLabel) this.damageCurrentLabel.visible = false;
         if(this.nextMarkValue) this.nextMarkValue.visible = false;
         if(this.nextMarkLabel) this.nextMarkLabel.visible = false;
         if(this.predictedMovingDamage) this.predictedMovingDamage.visible = false;
         if(this.currentMovingDamage) this.currentMovingDamage.visible = false;
         if(this._percentArrow) this._percentArrow.visible = false;
         if(this._averageArrow) this._averageArrow.visible = false;

         if(this.accountInfoLabel)
         {
            this.accountInfoLabel.visible = true;
            this.accountInfoLabel.text = value.length > 0 ? value : "MoE";
         }
      }

      private function _setDelta(field:TextField, arrow:Sprite, raw:String, percent:Boolean) : void
      {
         var n:Number = this._number(raw);
         var color:uint = WHITE;
         var sign:int = 0;
         var value:String = this._stripSign(raw);

         if(!isNaN(n))
         {
            if(n > 0)
            {
               sign = 1;
               color = GREEN;
            }
            else if(n < 0)
            {
               sign = -1;
               color = RED;
            }
         }

         if(percent && value.length > 0 && value.indexOf("%") < 0) value += "%";

         if(field)
         {
            field.textColor = color;
            field.text = value;
         }
         this._drawArrow(arrow,sign,color);
      }

      private function _drawArrow(arrow:Sprite, sign:int, color:uint) : void
      {
         if(!arrow) return;
         arrow.graphics.clear();
         arrow.visible = sign != 0;
         if(sign == 0) return;

         arrow.graphics.beginFill(color,1);
         if(sign > 0)
         {
            arrow.graphics.drawRect(3,4,2,7);
            arrow.graphics.moveTo(0,5);
            arrow.graphics.lineTo(4,0);
            arrow.graphics.lineTo(8,5);
            arrow.graphics.lineTo(0,5);
         }
         else
         {
            arrow.graphics.drawRect(3,0,2,7);
            arrow.graphics.moveTo(0,6);
            arrow.graphics.lineTo(8,6);
            arrow.graphics.lineTo(4,11);
            arrow.graphics.lineTo(0,6);
         }
         arrow.graphics.endFill();
      }

      private function _layoutTopRow() : void
      {
         if(!this.drPredicted || !this.drPredictedDelta) return;

         var right:Number = this.drPredicted.x + Math.min(this.drPredicted.textWidth + 4,78);
         this._percentArrow.x = Math.min(103,right + 4);
         this._percentArrow.y = 22;
         this.drPredictedDelta.x = this._percentArrow.visible ? this._percentArrow.x + 11 : this._percentArrow.x + 1;
         this.drPredictedDelta.y = 17;
      }

      private function _layoutAverageRow() : void
      {
         if(!this.predictedMovingDamage || !this.currentMovingDamage) return;

         var right:Number = this.predictedMovingDamage.x + Math.min(this.predictedMovingDamage.textWidth + 4,49);
         this._averageArrow.x = Math.min(152,right + 4);
         this._averageArrow.y = 89;
         this.currentMovingDamage.x = this._averageArrow.visible ? this._averageArrow.x + 11 : this._averageArrow.x + 1;
         this.currentMovingDamage.y = 84;
      }

      private function _cleanDamage(value:String) : String
      {
         return value.replace(/^\s*\/\s*/,"");
      }

      private function _number(value:String) : Number
      {
         var s:String = value == null ? "" : value;
         s = s.replace(/%/g,"");
         s = s.replace(/\s/g,"");
         s = s.replace(/,/g,"");
         return Number(s);
      }

      private function _stripSign(value:String) : String
      {
         var s:String = value == null ? "" : value;
         return s.replace(/^\s*[+-]\s*/,"");
      }

      private function _s(value:*) : String
      {
         if(value === null || value === undefined) return "";
         return String(value);
      }
   }
}
