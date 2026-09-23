package poliroid.views.battle.gunmarks
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   /**
    * NAJXBox MoE 1.0.9 - official CN SWF BATTLE presentation adapter.
    *
    * Authority:
    *   wotassist.markongun.swf SHA256
    *   06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851
    *
    * Frozen ownership:
    * - ProTanki backend/calculation/event/data code: untouched.
    * - ProGunMarks host/drag/offset persistence: untouched.
    * - This class owns presentation only.
    *
    * Official BATTLE geometry:
    * - background 147 x 93
    * - DR (14,14)
    * - DR arrow = previous textWidth + 7, y=17
    * - DR delta = previous bitmapWidth + 3, y=18
    * - 本场标伤 (14,42), value = previous textWidth + 6, y=41
    * - 平均标伤 (15,66), value = previous textWidth + 6, y=65
    * - AVG arrow = previous textWidth + 7, y=66
    * - AVG delta = previous bitmapWidth + 3, y=66
    *
    * Exact official background/arrow PNG pixels are embedded below as ARGB RLE.
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

      private static const PANEL_W:Number = 147;
      private static const PANEL_H:Number = 93;

      private static const MAIN:uint = 0xFFFCF6;
      private static const WHITE:uint = 0xFFFFFF;
      private static const UP:uint = 0x3EFF99;
      private static const DOWN:uint = 0xFF553E;

      private static const BG_RLE:String =
            "33FFFFFF:148,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2," +
            "66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145," +
            "33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2," +
            "66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145," +
            "33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,70272727:1,67000000:1," +
            "66000000:143,33FFFFFF:2,87282828:1,7D4E4E4E:1,6C181818:1,66000000:142,33FFFFFF:2,94000000:1,8D161616:1," +
            "7F464646:1,71292929:1,66000000:141,33FFFFFF:2,94000000:2,91050505:1,823B3B3B:1,73313131:1,66000000:140," +
            "33FFFFFF:2,94000000:3,94020202:1,7C4A4A4A:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140," +
            "33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2," +
            "94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4," +
            "7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1," +
            "66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140," +
            "33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2," +
            "94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4," +
            "7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1," +
            "66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140," +
            "33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2," +
            "94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4," +
            "7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1," +
            "66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140," +
            "33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2," +
            "94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4," +
            "7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1," +
            "66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140," +
            "33FFFFFF:2,94000000:4,7D4E4E4E:1,66000000:140,33FFFFFF:2,94000000:3,8B1A1A1A:1,74353535:1,66000000:140," +
            "33FFFFFF:2,94000000:1,93030303:1,862E2E2E:1,74353535:1,6B111111:1,66000000:140,33FFFFFF:2,910B0B0B:1," +
            "80404040:1,732F2F2F:1,66000000:142,33FFFFFF:2,7E4B4B4B:1,70222222:1,66000000:143,33FFFFFF:2,67000000:1," +
            "66000000:144,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145," +
            "33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2," +
            "66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145," +
            "33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2," +
            "66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145,33FFFFFF:2,66000000:145," +
            "33FFFFFF:148";
      private static const UP_RLE:String =
            "00000000:2,5E00FF8A:1,5F00FF89:1,00000000:3,2900F983:1,FF00FF8E:2,2A00FF86:1,00000000:1,0A00FF66:1,D500FF8C:1," +
            "FF00FF8E:2,D500FF8C:1,0A00FF66:1,9F00FF8C:1,FF00FF8E:4,A000FF8C:1,00000000:2,FF00FF8E:2,00000000:4,FF00FF8E:2," +
            "00000000:4,FF00FF8E:2,00000000:4,FF00FF8E:2,00000000:4,FF00FF8E:2,00000000:4,FF00FF8E:2,00000000:4,FF00FF8E:2," +
            "00000000:2";
      private static const DOWN_RLE:String =
            "00000000:2,FFFF422D:2,00000000:4,FFFF422D:2,00000000:4,FFFF422D:2,00000000:4,FFFF422D:2,00000000:4,FFFF422D:2," +
            "00000000:4,FFFF422D:2,00000000:4,FFFF422D:2,00000000:2,A0FF412D:1,FFFF422D:4,A1FF412C:1,0AFF331A:1,D5FF422C:1," +
            "FFFF422D:2,D6FF422C:1,0AFF331A:1,00000000:1,2AFF3D2A:1,FFFF422D:2,2AFF3D2A:1,00000000:3,5FFF402B:1,60FF402A:1," +
            "00000000:2";

      private var _built:Boolean = false;
      private var _officialBackground:Bitmap;
      private var _ratingArrow:Bitmap;
      private var _averageArrow:Bitmap;
      private var _arrowUpData:BitmapData;
      private var _arrowDownData:BitmapData;

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

         // Mature ProTanki semantic mapping is unchanged.
         this.drPredicted.text = this._ensurePercent(this._s(param1.predictedRating));
         this.nextMarkValue.text = this._cleanDamage(this._s(param1.battleMovingDamage));
         this.predictedMovingDamage.text = this._cleanDamage(this._s(param1.predictedMovingDamage));

         this._setDelta(this.drPredictedDelta,this._ratingArrow,this._s(param1.deltaRating),true);
         this._setDelta(this.currentMovingDamage,this._averageArrow,this._s(param1.deltaDamage),false);

         this._layoutOfficial();
      }

      private function _ensureUi() : void
      {
         if(this._built) return;
         this._built = true;

         if(this.background) this.background.visible = false;
         if(this.progressBar) this.progressBar.visible = false;

         this._officialBackground = new Bitmap(this._decodeRLE(int(PANEL_W),int(PANEL_H),BG_RLE));
         this._officialBackground.smoothing = false;
         addChildAt(this._officialBackground,0);

         this._arrowUpData = this._decodeRLE(6,11,UP_RLE);
         this._arrowDownData = this._decodeRLE(6,11,DOWN_RLE);

         this._ratingArrow = new Bitmap(this._arrowDownData);
         this._ratingArrow.smoothing = false;
         addChild(this._ratingArrow);

         this._averageArrow = new Bitmap(this._arrowDownData);
         this._averageArrow.smoothing = false;
         addChild(this._averageArrow);

         if(this.hitAreaA)
         {
            this.hitAreaA.width = PANEL_W;
            this.hitAreaA.height = PANEL_H;
            this.hitAreaA.alpha = 0;
            this.hitAreaA.visible = true;
         }

         // Reuse ProTanki timeline TextFields so its embedded-font linkage remains intact.
         // Geometry, sizes, colors and alpha follow the official CN SWF.
         this._style(this.drPredicted,18,MAIN,1.0,14,14,61,18);
         this._style(this.drPredictedDelta,14,DOWN,1.0,0,18,42,16);

         this._style(this.damageCurrentLabel,14,WHITE,0.7,14,42,60,16);
         this.damageCurrentLabel.text = "\u672c\u573a\u6807\u4f24";

         this._style(this.nextMarkValue,14,WHITE,1.0,0,41,46,16);

         this._style(this.nextMarkLabel,14,WHITE,0.7,15,66,60,16);
         this.nextMarkLabel.text = "\u5e73\u5747\u6807\u4f24";

         this._style(this.predictedMovingDamage,14,WHITE,1.0,0,65,52,16);
         this._style(this.currentMovingDamage,14,DOWN,1.0,0,66,38,16);

         this._style(this.accountInfoLabel,13,WHITE,0.7,7,35,PANEL_W - 14,22);
         if(this.accountInfoLabel)
         {
            var accountFormat:TextFormat = this.accountInfoLabel.defaultTextFormat;
            accountFormat.align = TextFormatAlign.CENTER;
            this.accountInfoLabel.defaultTextFormat = accountFormat;
            this.accountInfoLabel.setTextFormat(accountFormat);
            this.accountInfoLabel.autoSize = TextFieldAutoSize.NONE;
            this.accountInfoLabel.visible = false;
         }

         this._showNormalFields();
      }

      private function _style(field:TextField, size:Number, color:uint, alphaValue:Number,
                              xPos:Number, yPos:Number, widthValue:Number, heightValue:Number) : void
      {
         if(!field) return;

         var format:TextFormat = field.defaultTextFormat;
         format.size = size;
         format.bold = false;
         format.color = color;
         format.align = TextFormatAlign.LEFT;

         field.defaultTextFormat = format;
         field.setTextFormat(format);
         field.x = xPos;
         field.y = yPos;
         field.width = widthValue;
         field.height = heightValue;
         field.alpha = alphaValue;
         field.selectable = false;
         field.mouseEnabled = false;
         field.multiline = true;
         field.wordWrap = false;
         field.autoSize = TextFieldAutoSize.LEFT;
         field.antiAliasType = AntiAliasType.ADVANCED;
         field.visible = true;
      }

      private function _layoutOfficial() : void
      {
         // Official SWF uses Utils.adjustComponentList: +N means
         // previous component's real text/bitmap width + sibling offset.
         if(this.drPredicted)
         {
            this._ratingArrow.x = this.drPredicted.x + this._textWidth(this.drPredicted) + 7;
            this._ratingArrow.y = 17;
            if(this.drPredictedDelta)
            {
               this.drPredictedDelta.x = this._ratingArrow.x + 6 + 3;
               this.drPredictedDelta.y = 18;
            }
         }

         if(this.damageCurrentLabel && this.nextMarkValue)
         {
            this.nextMarkValue.x = this.damageCurrentLabel.x + this._textWidth(this.damageCurrentLabel) + 6;
            this.nextMarkValue.y = 41;
         }

         if(this.nextMarkLabel && this.predictedMovingDamage)
         {
            this.predictedMovingDamage.x = this.nextMarkLabel.x + this._textWidth(this.nextMarkLabel) + 6;
            this.predictedMovingDamage.y = 65;

            this._averageArrow.x = this.predictedMovingDamage.x + this._textWidth(this.predictedMovingDamage) + 7;
            this._averageArrow.y = 66;

            if(this.currentMovingDamage)
            {
               this.currentMovingDamage.x = this._averageArrow.x + 6 + 3;
               this.currentMovingDamage.y = 66;
            }
         }
      }

      private function _setDelta(field:TextField, arrow:Bitmap, raw:String, percent:Boolean) : void
      {
         var n:Number = this._number(raw);
         var value:String = this._stripSign(raw);
         var sign:int = 0;
         var color:uint = MAIN;

         if(!isNaN(n))
         {
            if(n > 0)
            {
               sign = 1;
               color = UP;
            }
            else if(n < 0)
            {
               sign = -1;
               color = DOWN;
            }
         }

         if(percent && value.length > 0 && value.indexOf("%") < 0) value += "%";

         if(field)
         {
            field.textColor = color;
            field.alpha = 1.0;
            field.text = value;
         }

         if(arrow)
         {
            arrow.visible = sign != 0;
            if(sign > 0) arrow.bitmapData = this._arrowUpData;
            else if(sign < 0) arrow.bitmapData = this._arrowDownData;
         }
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
         if(this._ratingArrow) this._ratingArrow.visible = false;
         if(this._averageArrow) this._averageArrow.visible = false;

         if(this.accountInfoLabel)
         {
            this.accountInfoLabel.visible = true;
            this.accountInfoLabel.text = value.length > 0 ? value : "MoE";
         }
      }

      private function _textWidth(field:TextField) : Number
      {
         if(!field) return 0;
         return Math.ceil(field.textWidth);
      }

      private function _cleanDamage(value:String) : String
      {
         return value.replace(/^\s*\/\s*/,"");
      }

      private function _ensurePercent(value:String) : String
      {
         if(value.length > 0 && value.indexOf("%") < 0) return value + "%";
         return value;
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

      private function _decodeRLE(widthValue:int, heightValue:int, data:String) : BitmapData
      {
         var bitmap:BitmapData = new BitmapData(widthValue,heightValue,true,0x00000000);
         var runs:Array = data.split(",");
         var pos:int = 0;
         var token:String;
         var pair:Array;
         var color:uint;
         var count:int;
         var i:int;

         bitmap.lock();
         for each(token in runs)
         {
            pair = token.split(":");
            color = uint(parseInt(String(pair[0]),16));
            count = int(pair[1]);
            for(i = 0; i < count; i++)
            {
               bitmap.setPixel32(pos % widthValue,int(pos / widthValue),color);
               pos++;
            }
         }
         bitmap.unlock();
         return bitmap;
      }
   }
}
