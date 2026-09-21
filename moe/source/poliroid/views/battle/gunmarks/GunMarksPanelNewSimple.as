package poliroid.views.battle.gunmarks
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.AntiAliasType;

   /**
    * CNBOX compact MoE presentation.
    *
    * Calculation/backend data is left to the original ProTanki core. This class
    * only remaps existing battle fields into the compact three-row presentation:
    * predictedRating + deltaRating
    * battleMovingDamage
    * predictedMovingDamage + deltaDamage

    * Static field semantics are locked against the two CN reference screenshots:
    *   EWMA_new = EWMA_old + (2/101) * (battleDamage - EWMA_old)
    * A 3749 battle with a projected 3385 average and +7 delta implies a pre-battle
    * average ~3378; a 955 battle with projected 3348 and -48 implies ~3396.
    * This matches ProTanki's own field split: battleMovingDamage is the battle
    * contribution, predictedMovingDamage is the projected moving average, and
    * deltaDamage is the moving-average change.
    *
    * Dragging/persistence remains owned by ProGunMarks and the backend.
    */
   public class GunMarksPanelNewSimple extends MovieClip implements IGunMarksPanel
   {
      public var hitAreaA:MovieClip;
      public var progress:MovieClip;
      public var mainLabel:TextField;
      public var helpLabel:TextField;
      public var externalLabel:TextField;

      private var _built:Boolean = false;
      private var _back:Shape;
      private var _percent:TextField;
      private var _percentDelta:TextField;
      private var _battleCaption:TextField;
      private var _battleValue:TextField;
      private var _averageCaption:TextField;
      private var _averageValue:TextField;
      private var _averageDelta:TextField;
      private var _percentArrow:Sprite;
      private var _averageArrow:Sprite;
      private var _unavailable:TextField;

      // The two supplied CN captures are the same panel at ~1.0x and ~1.25x UI scale.
      // Their outer rectangles close at ~192x120 logical px (the second capture is
      // ~240x150), so keep the native aspect here instead of stretching a short banner.
      private static const PANEL_W:Number = 192;
      private static const PANEL_H:Number = 120;
      private static const PAD_X:Number = 20;

      // Visual pass sampled from the two reference states. Text is intentionally warm-white
      // rather than pure #fff; up is the cyan-green used by the CN helper, down is its
      // muted coral red. We can still make tiny final adjustments without touching data logic.
      private static const WHITE:uint = 0xF2F0E8;
      private static const MUTED:uint = 0xE0DED4;
      private static const GREEN:uint = 0x2FDAA1;
      private static const RED:uint = 0xCB4E52;

      public function GunMarksPanelNewSimple()
      {
         super();
      }

      public function setData(param1:Object) : void
      {
         this._ensureUi();

         if(!param1 || !param1.accountValidated || !param1.networkValidated && !param1.historyValidated)
         {
            this._setUnavailable(param1 ? this._s(param1.accountValidatedLabel) : "");
            return;
         }

         this._unavailable.visible = false;
         this._percent.visible = true;
         this._percentDelta.visible = true;
         this._battleCaption.visible = true;
         this._battleValue.visible = true;
         this._averageCaption.visible = true;
         this._averageValue.visible = true;
         this._averageDelta.visible = true;

         this._percent.text = this._s(param1.predictedRating);
         this._battleValue.text = this._cleanDamage(this._s(param1.battleMovingDamage));
         this._averageValue.text = this._cleanDamage(this._s(param1.predictedMovingDamage));

         this._setDelta(this._percentDelta,this._percentArrow,this._s(param1.deltaRating),true);
         this._setDelta(this._averageDelta,this._averageArrow,this._s(param1.deltaDamage),false);

         this._layoutTopRow();
         this._layoutAverageRow();
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

      private function _ensureUi() : void
      {
         var i:int = 0;
         var d:DisplayObject = null;
         if(this._built) return;
         this._built = true;

         for(i = 0; i < numChildren; i++)
         {
            d = getChildAt(i);
            d.visible = false;
         }

         if(this.hitAreaA)
         {
            this.hitAreaA.width = PANEL_W;
            this.hitAreaA.height = PANEL_H;
            this.hitAreaA.alpha = 0;
            this.hitAreaA.visible = true;
         }

         this._back = new Shape();
         this._back.graphics.lineStyle(1,0xD8D6CC,0.28);
         this._back.graphics.beginFill(0x10130F,0.43);
         this._back.graphics.drawRect(0,0,PANEL_W,PANEL_H);
         this._back.graphics.endFill();
         this._back.mouseEnabled = false;
         addChild(this._back);

         this._percent = this._makeText(20,true,WHITE,PAD_X,14,82,29,TextFormatAlign.LEFT);
         this._percentDelta = this._makeText(15,true,WHITE,112,17,70,23,TextFormatAlign.LEFT);

         this._battleCaption = this._makeText(16,true,MUTED,PAD_X,50,78,24,TextFormatAlign.LEFT);
         this._battleCaption.text = "\u672c\u573a\u6807\u4f24";
         this._battleValue = this._makeText(16,true,WHITE,100,50,74,24,TextFormatAlign.LEFT);

         this._averageCaption = this._makeText(16,true,MUTED,PAD_X,82,78,24,TextFormatAlign.LEFT);
         this._averageCaption.text = "\u5e73\u5747\u6807\u4f24";
         this._averageValue = this._makeText(16,true,WHITE,100,82,54,24,TextFormatAlign.LEFT);
         this._averageDelta = this._makeText(15,true,WHITE,158,84,31,22,TextFormatAlign.LEFT);

         this._percentArrow = new Sprite();
         this._percentArrow.mouseEnabled = false;
         this._percentArrow.mouseChildren = false;
         addChild(this._percentArrow);

         this._averageArrow = new Sprite();
         this._averageArrow.mouseEnabled = false;
         this._averageArrow.mouseChildren = false;
         addChild(this._averageArrow);

         this._unavailable = this._makeText(14,false,MUTED,10,26,PANEL_W - 20,28,TextFormatAlign.CENTER);
         this._unavailable.visible = false;
      }

      private function _makeText(size:Number, bold:Boolean, color:uint, xPos:Number, yPos:Number,
                                 widthValue:Number, heightValue:Number, alignValue:String) : TextField
      {
         var field:TextField = new TextField();
         var format:TextFormat = new TextFormat("$FieldFont",size,color,bold);
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
         field.embedFonts = true;
         field.antiAliasType = AntiAliasType.ADVANCED;
         field.filters = [new DropShadowFilter(1,90,0x000000,0.86,2,2,1.5,1)];
         addChild(field);
         return field;
      }

      private function _setUnavailable(value:String) : void
      {
         this._percent.visible = false;
         this._percentDelta.visible = false;
         this._battleCaption.visible = false;
         this._battleValue.visible = false;
         this._averageCaption.visible = false;
         this._averageValue.visible = false;
         this._averageDelta.visible = false;
         this._percentArrow.visible = false;
         this._averageArrow.visible = false;
         this._unavailable.visible = true;
         this._unavailable.text = value.length > 0 ? value : "MoE";
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
         field.textColor = color;
         field.text = value;
         this._drawArrow(arrow,sign,color);
      }

      private function _drawArrow(arrow:Sprite, sign:int, color:uint) : void
      {
         arrow.graphics.clear();
         arrow.visible = sign != 0;
         if(sign == 0) return;

         arrow.graphics.beginFill(color,1);
         if(sign > 0)
         {
            // Narrow stem + head, matching the CN reference rather than a solid triangle.
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
         var right:Number = 0;
         this._percent.x = PAD_X;
         this._percent.y = 14;
         this._percent.width = 82;

         right = this._percent.x + Math.min(this._percent.textWidth + 4,78);
         this._percentArrow.x = Math.min(103,right + 4);
         this._percentArrow.y = 22;
         this._percentDelta.x = this._percentArrow.visible ? this._percentArrow.x + 11 : this._percentArrow.x + 1;
         this._percentDelta.y = 17;
      }

      private function _layoutAverageRow() : void
      {
         var right:Number = this._averageValue.x + Math.min(this._averageValue.textWidth + 4,50);
         this._averageArrow.x = Math.min(148,right + 4);
         this._averageArrow.y = 89;
         this._averageDelta.x = this._averageArrow.visible ? this._averageArrow.x + 11 : this._averageArrow.x + 1;
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
