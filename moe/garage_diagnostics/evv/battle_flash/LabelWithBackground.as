package de.champi.wot.evv.utils
{
   import flash.display.CapsStyle;
   import flash.display.GradientType;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   
   public class LabelWithBackground extends Sprite
   {
      
      public static const POSITION_CHANGED:String = "LabelWithBackgroundPositionChanged";
      
      private const TEXT_GUTTER:int = 4;
      
      private const VERTICAL_BOUNDARY_GAP:Number = 0;
      
      private const HORIZONTAL_BOUNDARY_GAP:Number = 0;
      
      private var bg:Shape = new Shape();
      
      private var tf:TextField = new TextField();
      
      private var textHolder:Sprite = new Sprite();
      
      private var _ctrlActive:Boolean = false;
      
      private var _dragging:Boolean = false;
      
      private var _dragEnabled:Boolean = false;
      
      private var _dragRequested:Boolean = false;
      
      private var _dragPointerOffsetX:Number = 0;
      
      private var _dragPointerOffsetY:Number = 0;
      
      public var requireCtrlForDrag:Boolean = true;
      
      private var _lastAlignX:String = "LEFT";
      
      private var _lastAlignY:String = "TOP";
      
      private var _layoutW:Number = 0;
      
      private var _layoutH:Number = 0;
      
      private var _lastLayoutSettings:Object = null;
      
      private var _lastLayoutStageW:Number = 0;
      
      private var _lastLayoutStageH:Number = 0;
      
      private var _userOffsetPxX:Number = 0;
      
      private var _userOffsetPxY:Number = 0;
      
      private var _hasUserOffset:Boolean = false;
      
      private var _backgroundEnabled:Boolean = true;
      
      private var _fillEnabled:Boolean = true;
      
      private var _panelAlpha:Number = 1;
      
      public var strokeMode:String = "inside";
      
      public var padding:Number = 6;
      
      public var cornerRadius:Number = 8;
      
      public var bgColor:uint = 1179688;
      
      public var bgAlpha:Number = 0.6;
      
      public var borderThickness:Number = 1;
      
      public var borderColor:uint = 16711680;
      
      public var borderAlpha:Number = 0.6;
      
      public var minPanelWidth:Number = 0;
      
      public var minPanelHeight:Number = 0;
      
      private var _gradientEnabled:Boolean = false;
      
      private var _gradientType:String = "linear";
      
      private var _gradientAngleDeg:Number = 90;
      
      private var _gradientColors:Array = null;
      
      private var _gradientAlphas:Array = null;
      
      private var _gradientRatios:Array = null;
      
      private var _format:TextFormat;
      
      private var _text:String = "";
      
      private var _initialGlow:Object = null;
      
      private var _textVAlign:String = "top";
      
      private var _invalidateFramesLeft:int = 0;
      
      private var _invalidating:Boolean = false;
      
      public function LabelWithBackground(param1:TextFormat, param2:String = "left", param3:Boolean = true, param4:Boolean = false, param5:Object = null)
      {
         super();
         addChild(this.bg);
         addChild(this.textHolder);
         this.textHolder.addChild(this.tf);
         this._format = param1;
         this.tf.defaultTextFormat = this._format;
         this.tf.antiAliasType = AntiAliasType.ADVANCED;
         this.tf.selectable = false;
         this.tf.multiline = param3;
         this.tf.wordWrap = param4;
         this.tf.autoSize = TextFieldAutoSize.LEFT;
         this.tf.width = 1;
         if(param5)
         {
            this._initialGlow = param5;
         }
         this.invalidateLayout();
      }
      
      public function set text(param1:String) : void
      {
         if(param1 == this._text)
         {
            return;
         }
         this._text = param1;
         if(this._format)
         {
            this.tf.defaultTextFormat = this._format;
         }
         this.tf.text = this._text;
         if(this._format)
         {
            this.tf.setTextFormat(this._format);
         }
         this.invalidateLayout();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set htmlText(param1:String) : void
      {
         if(param1 == this._text)
         {
            return;
         }
         this._text = param1;
         if(this._format)
         {
            this.tf.defaultTextFormat = this._format;
         }
         this.tf.htmlText = param1;
         this.redraw();
         this.invalidateLayout();
      }
      
      public function get htmlText() : String
      {
         return this.tf.htmlText;
      }
      
      public function get offsetX() : Number
      {
         return this._userOffsetPxX;
      }
      
      public function get offsetY() : Number
      {
         return this._userOffsetPxY;
      }
      
      public function get alignX() : String
      {
         return this._lastAlignX;
      }
      
      public function get alignY() : String
      {
         return this._lastAlignY;
      }
      
      public function dispose() : void
      {
         this.disableDragInternal();
         removeEventListener(Event.ENTER_FRAME,this.onInvalidateFrame);
         this._invalidating = false;
         this._invalidateFramesLeft = 0;
      }
      
      public function applySettings(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc2_:TextFormat = this._format ? this._format : new TextFormat();
         var _loc3_:Object = null;
         if(param1.text)
         {
            if(param1.text.font != null)
            {
               _loc2_.font = param1.text.font;
            }
            if(param1.text.size != null)
            {
               _loc2_.size = param1.text.size;
            }
            if(param1.text.color != null)
            {
               _loc2_.color = uint(param1.text.color);
            }
            if(param1.text.bold != null)
            {
               _loc2_.bold = param1.text.bold;
            }
            if(param1.text.italic != null)
            {
               _loc2_.italic = param1.text.italic;
            }
            if(param1.text.leading != null)
            {
               _loc2_.leading = param1.text.leading;
            }
            if(param1.text.align != null)
            {
               this.setTextAlign(String(param1.text.align));
               _loc2_.align = String(param1.text.align).toLowerCase();
            }
            if(param1.text.valign != null)
            {
               this._textVAlign = String(param1.text.valign).toLowerCase();
               if(this._textVAlign != "top" && this._textVAlign != "middle" && this._textVAlign != "bottom" && this._textVAlign != "center")
               {
                  this._textVAlign = "top";
               }
               if(this._textVAlign == "center")
               {
                  this._textVAlign = "middle";
               }
            }
            if(param1.text.alpha != null)
            {
               this.tf.alpha = Number(param1.text.alpha);
            }
         }
         this.setTextFormat(_loc2_);
         if(Boolean(param1.text) && Boolean(param1.text.shadow) && param1.text.shadow.enable === true)
         {
            _loc3_ = param1.text.shadow;
         }
         else if(this._initialGlow != null)
         {
            _loc3_ = this._initialGlow;
         }
         if(_loc3_)
         {
            this.textHolder.filters = [new GlowFilter(uint(_loc3_.color != null ? _loc3_.color : 0),_loc3_.alpha != null ? Number(_loc3_.alpha) : 1,_loc3_.blurX != null ? Number(_loc3_.blurX) : 4,_loc3_.blurY != null ? Number(_loc3_.blurY) : 4,_loc3_.strength != null ? Number(_loc3_.strength) : 2,_loc3_.quality != null ? int(_loc3_.quality) : BitmapFilterQuality.LOW,_loc3_.inner === true,_loc3_.knockout === true)];
         }
         else
         {
            this.textHolder.filters = [];
         }
         if(param1.panel)
         {
            if(param1.panel.alignX != null)
            {
               this._lastAlignX = String(param1.panel.alignX).toUpperCase();
            }
            if(param1.panel.alignY != null)
            {
               this._lastAlignY = String(param1.panel.alignY).toUpperCase();
            }
            if(param1.panel.width != null)
            {
               this.minPanelWidth = Number(param1.panel.width);
            }
            if(param1.panel.height != null)
            {
               this.minPanelHeight = Number(param1.panel.height);
            }
            this._panelAlpha = param1.panel.alpha != null ? Number(param1.panel.alpha) : 1;
            if(param1.panel.background)
            {
               _loc4_ = param1.panel.background;
               this._backgroundEnabled = _loc4_.enable !== false;
               this._fillEnabled = true;
               if(_loc4_.fill != null)
               {
                  this._fillEnabled = Boolean(_loc4_.fill);
               }
               if(_loc4_.margin != null)
               {
                  this.padding = Number(_loc4_.margin);
               }
               if(_loc4_.thickness != null)
               {
                  this.borderThickness = Number(_loc4_.thickness);
               }
               if(_loc4_.borderColor != null)
               {
                  this.borderColor = uint(_loc4_.borderColor);
               }
               if(_loc4_.color != null)
               {
                  this.bgColor = uint(_loc4_.color);
               }
               if(_loc4_.alpha != null)
               {
                  this.bgAlpha = Number(_loc4_.alpha);
               }
               this.borderAlpha = _loc4_.borderAlpha != null ? Number(_loc4_.borderAlpha) : this.bgAlpha;
               if(_loc4_.ellipseWidth != null)
               {
                  this.cornerRadius = Number(_loc4_.ellipseWidth);
               }
               if(_loc4_.strokeMode != null)
               {
                  _loc5_ = String(_loc4_.strokeMode).toLowerCase();
                  if(_loc5_ == "inside" || _loc5_ == "center" || _loc5_ == "outside")
                  {
                     this.strokeMode = _loc5_;
                  }
               }
               this._gradientEnabled = false;
               this._gradientColors = null;
               this._gradientAlphas = null;
               this._gradientRatios = null;
               this._gradientAngleDeg = 90;
               this._gradientType = GradientType.LINEAR;
               if(_loc4_.gradient)
               {
                  _loc6_ = _loc4_.gradient;
                  this._gradientEnabled = _loc6_.enable === true;
                  if(this._gradientEnabled)
                  {
                     if(Boolean(_loc6_.colors) && Boolean(_loc6_.colors is Array) && _loc6_.colors.length >= 2)
                     {
                        this._gradientColors = _loc6_.colors.concat();
                     }
                     else
                     {
                        this._gradientEnabled = false;
                     }
                     if(this._gradientEnabled && _loc6_.angle != null)
                     {
                        this._gradientAngleDeg = Number(_loc6_.angle);
                     }
                     if(this._gradientEnabled && _loc6_.type != null)
                     {
                        _loc7_ = String(_loc6_.type).toLowerCase();
                        this._gradientType = _loc7_ == "radial" ? GradientType.RADIAL : GradientType.LINEAR;
                     }
                     if(this._gradientEnabled)
                     {
                        this._gradientAlphas = [];
                        if(Boolean(_loc6_.alphas) && Boolean(_loc6_.alphas is Array) && _loc6_.alphas.length == this._gradientColors.length)
                        {
                           _loc8_ = 0;
                           while(_loc8_ < _loc6_.alphas.length)
                           {
                              this._gradientAlphas.push(Number(_loc6_.alphas[_loc8_]));
                              _loc8_++;
                           }
                        }
                        else
                        {
                           _loc8_ = 0;
                           while(_loc8_ < this._gradientColors.length)
                           {
                              this._gradientAlphas.push(this.bgAlpha);
                              _loc8_++;
                           }
                        }
                     }
                     if(this._gradientEnabled)
                     {
                        this._gradientRatios = [];
                        if(Boolean(_loc6_.ratios) && Boolean(_loc6_.ratios is Array) && _loc6_.ratios.length == this._gradientColors.length)
                        {
                           _loc9_ = 0;
                           while(_loc9_ < _loc6_.ratios.length)
                           {
                              this._gradientRatios.push(int(_loc6_.ratios[_loc9_]));
                              _loc9_++;
                           }
                        }
                        else
                        {
                           _loc10_ = int(this._gradientColors.length);
                           _loc9_ = 0;
                           while(_loc9_ < _loc10_)
                           {
                              this._gradientRatios.push(int(255 * _loc9_ / (_loc10_ - 1)));
                              _loc9_++;
                           }
                        }
                     }
                  }
               }
            }
            if(param1.panel.x != null && param1.panel.y != null)
            {
               this._userOffsetPxX = Number(param1.panel.x);
               this._userOffsetPxY = Number(param1.panel.y);
               this._hasUserOffset = true;
            }
            if(param1.panel.draggable != null)
            {
               this._dragRequested = param1.panel.draggable === true;
               if(this._dragRequested)
               {
                  this.enableDragInternal();
               }
               else
               {
                  this.disableDragInternal();
               }
            }
         }
         this.invalidateLayout();
      }
      
      public function layoutFromSettings(param1:Object, param2:Number, param3:Number) : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(!param1 || !param1.panel)
         {
            return;
         }
         this._lastLayoutSettings = param1;
         this._lastLayoutStageW = param2;
         this._lastLayoutStageH = param3;
         if(param1.panel.alignX != null)
         {
            this._lastAlignX = String(param1.panel.alignX).toUpperCase();
         }
         if(param1.panel.alignY != null)
         {
            this._lastAlignY = String(param1.panel.alignY).toUpperCase();
         }
         var _loc4_:Number = this.getAppScale();
         var _loc5_:Number = param2;
         var _loc6_:Number = param3;
         try
         {
            if(Boolean(App) && Boolean(App.appWidth) && Boolean(App.appHeight))
            {
               _loc5_ = Number(App.appWidth) / _loc4_;
               _loc6_ = Number(App.appHeight) / _loc4_;
            }
         }
         catch(e:Error)
         {
         }
         if((_loc5_ <= 0 || _loc6_ <= 0) && Boolean(stage))
         {
            _loc5_ = stage.stageWidth;
            _loc6_ = stage.stageHeight;
         }
         var _loc7_:Number = this._lastAlignX == "CENTER" ? _loc5_ * 0.5 : (this._lastAlignX == "RIGHT" ? _loc5_ : 0);
         var _loc8_:String = this._lastAlignY;
         if(_loc8_ == "MIDDLE")
         {
            _loc8_ = "CENTER";
         }
         var _loc9_:Number = _loc8_ == "CENTER" ? _loc6_ * 0.5 : (_loc8_ == "BOTTOM" ? _loc6_ : 0);
         if(this._hasUserOffset)
         {
            _loc10_ = this._userOffsetPxX;
            _loc11_ = this._userOffsetPxY;
         }
         else
         {
            _loc10_ = param1.panel.x != null ? Number(param1.panel.x) : 0;
            _loc11_ = param1.panel.y != null ? Number(param1.panel.y) : 0;
         }
         var _loc12_:Number = _loc7_ + _loc10_ / _loc4_;
         var _loc13_:Number = _loc9_ + _loc11_ / _loc4_;
         this.setClampedAnchorPosition(_loc12_,_loc13_,this._lastAlignX,this._lastAlignY,_loc5_,_loc6_);
      }
      
      public function migrateAnchorPosition(param1:Object, param2:Number, param3:Number) : Boolean
      {
         if(!param1 || !param1.panel || !this._lastLayoutSettings || !this._lastLayoutSettings.panel)
         {
            return false;
         }
         var _loc4_:String = this._lastAlignX;
         var _loc5_:String = this._lastAlignY;
         var _loc6_:String = param1.panel.alignX != null ? String(param1.panel.alignX).toUpperCase() : _loc4_;
         var _loc7_:String = param1.panel.alignY != null ? String(param1.panel.alignY).toUpperCase() : _loc5_;
         if(_loc4_ == _loc6_ && _loc5_ == _loc7_)
         {
            return false;
         }
         var _loc8_:Number = this.getAppScale();
         var _loc9_:Number = param2;
         var _loc10_:Number = param3;
         try
         {
            if(Boolean(App) && Boolean(App.appWidth) && Boolean(App.appHeight))
            {
               _loc9_ = Number(App.appWidth) / _loc8_;
               _loc10_ = Number(App.appHeight) / _loc8_;
            }
         }
         catch(e:Error)
         {
         }
         if((_loc9_ <= 0 || _loc10_ <= 0) && Boolean(stage))
         {
            _loc9_ = stage.stageWidth;
            _loc10_ = stage.stageHeight;
         }
         var _loc11_:Number = _loc4_ == "CENTER" ? _loc9_ * 0.5 : (_loc4_ == "RIGHT" ? _loc9_ : 0);
         var _loc12_:String = _loc5_ == "MIDDLE" ? "CENTER" : _loc5_;
         var _loc13_:Number = _loc12_ == "CENTER" ? _loc10_ * 0.5 : (_loc12_ == "BOTTOM" ? _loc10_ : 0);
         var _loc14_:Number = _loc6_ == "CENTER" ? _loc9_ * 0.5 : (_loc6_ == "RIGHT" ? _loc9_ : 0);
         var _loc15_:String = _loc7_ == "MIDDLE" ? "CENTER" : _loc7_;
         var _loc16_:Number = _loc15_ == "CENTER" ? _loc10_ * 0.5 : (_loc15_ == "BOTTOM" ? _loc10_ : 0);
         var _loc17_:Number = this._hasUserOffset ? this._userOffsetPxX : Number(this._lastLayoutSettings.panel.x);
         var _loc18_:Number = this._hasUserOffset ? this._userOffsetPxY : Number(this._lastLayoutSettings.panel.y);
         var _loc19_:Number = _loc11_ + _loc17_ / _loc8_ - this._layoutW * this.anchorFromString(_loc4_,true);
         var _loc20_:Number = _loc13_ + _loc18_ / _loc8_ - this._layoutH * this.anchorFromString(_loc5_,false);
         var _loc21_:Number = (_loc19_ + this._layoutW * this.anchorFromString(_loc6_,true) - _loc14_) * _loc8_;
         var _loc22_:Number = (_loc20_ + this._layoutH * this.anchorFromString(_loc7_,false) - _loc16_) * _loc8_;
         this._userOffsetPxX = Math.round(_loc21_);
         this._userOffsetPxY = Math.round(_loc22_);
         this._hasUserOffset = true;
         param1.panel.x = this._userOffsetPxX;
         param1.panel.y = this._userOffsetPxY;
         return true;
      }
      
      public function migrateAnchorPositionFrom(param1:String, param2:String, param3:Number, param4:Number, param5:Object, param6:Number, param7:Number) : Boolean
      {
         if(!param5 || !param5.panel || this._layoutW <= 0 || this._layoutH <= 0)
         {
            return false;
         }
         param1 = param1 ? param1.toUpperCase() : "LEFT";
         param2 = param2 ? param2.toUpperCase() : "TOP";
         var _loc8_:String = param5.panel.alignX != null ? String(param5.panel.alignX).toUpperCase() : param1;
         var _loc9_:String = param5.panel.alignY != null ? String(param5.panel.alignY).toUpperCase() : param2;
         if(param1 == _loc8_ && param2 == _loc9_)
         {
            return false;
         }
         var _loc10_:Number = this.getAppScale();
         var _loc11_:Number = param6;
         var _loc12_:Number = param7;
         try
         {
            if(Boolean(App) && Boolean(App.appWidth) && Boolean(App.appHeight))
            {
               _loc11_ = Number(App.appWidth) / _loc10_;
               _loc12_ = Number(App.appHeight) / _loc10_;
            }
         }
         catch(e:Error)
         {
         }
         if((_loc11_ <= 0 || _loc12_ <= 0) && Boolean(stage))
         {
            _loc11_ = stage.stageWidth;
            _loc12_ = stage.stageHeight;
         }
         var _loc13_:Number = param1 == "CENTER" ? _loc11_ * 0.5 : (param1 == "RIGHT" ? _loc11_ : 0);
         var _loc14_:String = param2 == "MIDDLE" ? "CENTER" : param2;
         var _loc15_:Number = _loc14_ == "CENTER" ? _loc12_ * 0.5 : (_loc14_ == "BOTTOM" ? _loc12_ : 0);
         var _loc16_:Number = _loc8_ == "CENTER" ? _loc11_ * 0.5 : (_loc8_ == "RIGHT" ? _loc11_ : 0);
         var _loc17_:String = _loc9_ == "MIDDLE" ? "CENTER" : _loc9_;
         var _loc18_:Number = _loc17_ == "CENTER" ? _loc12_ * 0.5 : (_loc17_ == "BOTTOM" ? _loc12_ : 0);
         var _loc19_:Number = _loc13_ + param3 / _loc10_ - this._layoutW * this.anchorFromString(param1,true);
         var _loc20_:Number = _loc15_ + param4 / _loc10_ - this._layoutH * this.anchorFromString(param2,false);
         var _loc21_:Number = (_loc19_ + this._layoutW * this.anchorFromString(_loc8_,true) - _loc16_) * _loc10_;
         var _loc22_:Number = (_loc20_ + this._layoutH * this.anchorFromString(_loc9_,false) - _loc18_) * _loc10_;
         this._userOffsetPxX = Math.round(_loc21_);
         this._userOffsetPxY = Math.round(_loc22_);
         this._hasUserOffset = true;
         param5.panel.x = this._userOffsetPxX;
         param5.panel.y = this._userOffsetPxY;
         return true;
      }
      
      private function normalizeAutoSizeAlign(param1:String) : String
      {
         if(!param1)
         {
            return TextFieldAutoSize.LEFT;
         }
         var _loc2_:String = param1.toUpperCase();
         if(_loc2_ == "LEFT")
         {
            return TextFieldAutoSize.LEFT;
         }
         if(_loc2_ == "CENTER")
         {
            return TextFieldAutoSize.CENTER;
         }
         if(_loc2_ == "RIGHT")
         {
            return TextFieldAutoSize.RIGHT;
         }
         _loc2_ = param1.toLowerCase();
         if(_loc2_ == TextFieldAutoSize.LEFT || _loc2_ == TextFieldAutoSize.CENTER || _loc2_ == TextFieldAutoSize.RIGHT)
         {
            return _loc2_;
         }
         return TextFieldAutoSize.LEFT;
      }
      
      private function setTextAlign(param1:String) : void
      {
         this.tf.autoSize = TextFieldAutoSize.LEFT;
         var _loc2_:String = param1 ? String(param1).toLowerCase() : "left";
         if(this._format)
         {
            this._format.align = _loc2_;
            this.tf.defaultTextFormat = this._format;
            if(this.tf.htmlText == null || this.tf.htmlText == "" || this.tf.htmlText == this.tf.text)
            {
               this.tf.setTextFormat(this._format);
            }
         }
      }
      
      private function setTextFormat(param1:TextFormat) : void
      {
         this._format = param1;
         this.tf.defaultTextFormat = this._format;
         if(this.tf.htmlText == null || this.tf.htmlText == "" || this.tf.htmlText == this.tf.text)
         {
            this.tf.setTextFormat(this._format);
         }
      }
      
      private function anchorFromString(param1:String, param2:Boolean) : Number
      {
         if(!param1)
         {
            return 0;
         }
         switch(param1.toUpperCase())
         {
            case "CENTER":
            case "MIDDLE":
               return 0.5;
            case "RIGHT":
            case "BOTTOM":
               return 1;
            case "LEFT":
            case "TOP":
         }
         return 0;
      }
      
      private function getAppScale() : Number
      {
         var _loc1_:Number = NaN;
         try
         {
            if(Boolean(App) && Boolean(App.appScale))
            {
               _loc1_ = Number(App.appScale);
               if(_loc1_ > 0)
               {
                  return _loc1_;
               }
            }
         }
         catch(e:Error)
         {
         }
         return 1;
      }
      
      private function getScreenWidthInFlashUnits() : Number
      {
         var _loc1_:Number = this._lastLayoutStageW;
         var _loc2_:Number = this.getAppScale();
         try
         {
            if(Boolean(App) && Boolean(App.appWidth))
            {
               _loc1_ = Number(App.appWidth) / _loc2_;
            }
         }
         catch(e:Error)
         {
         }
         if(_loc1_ <= 0 && Boolean(stage))
         {
            _loc1_ = stage.stageWidth;
         }
         return _loc1_;
      }
      
      private function getScreenHeightInFlashUnits() : Number
      {
         var _loc1_:Number = this._lastLayoutStageH;
         var _loc2_:Number = this.getAppScale();
         try
         {
            if(Boolean(App) && Boolean(App.appHeight))
            {
               _loc1_ = Number(App.appHeight) / _loc2_;
            }
         }
         catch(e:Error)
         {
         }
         if(_loc1_ <= 0 && Boolean(stage))
         {
            _loc1_ = stage.stageHeight;
         }
         return _loc1_;
      }
      
      private function getPointerPositionInParent() : Point
      {
         var _loc1_:Point = null;
         if(stage)
         {
            _loc1_ = new Point(stage.mouseX,stage.mouseY);
            if(parent)
            {
               return parent.globalToLocal(stage.localToGlobal(_loc1_));
            }
            return _loc1_;
         }
         _loc1_ = new Point(mouseX,mouseY);
         return parent ? parent.globalToLocal(localToGlobal(_loc1_)) : _loc1_;
      }
      
      private function setAnchorPosition(param1:Number, param2:Number, param3:String = "LEFT", param4:String = "TOP") : void
      {
         var _loc5_:Number = this.anchorFromString(param3,true);
         var _loc6_:Number = this.anchorFromString(param4,false);
         this.x = Math.round(param1 - this._layoutW * _loc5_);
         this.y = Math.round(param2 - this._layoutH * _loc6_);
      }
      
      private function setClampedAnchorPosition(param1:Number, param2:Number, param3:String, param4:String, param5:Number, param6:Number) : void
      {
         var _loc7_:Number = this.anchorFromString(param3,true);
         var _loc8_:Number = this.anchorFromString(param4,false);
         var _loc9_:Number = Math.round(param1 - this._layoutW * _loc7_);
         var _loc10_:Number = Math.round(param2 - this._layoutH * _loc8_);
         _loc9_ = this.clampHorizontalPosition(_loc9_,param5);
         _loc10_ = this.clampVerticalPosition(_loc10_,param6);
         this.x = _loc9_;
         this.y = _loc10_;
      }
      
      private function clampVerticalPosition(param1:Number, param2:Number) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this._layoutH <= 0 || param2 <= 0)
         {
            return param1;
         }
         var _loc3_:Number = param2 - this.VERTICAL_BOUNDARY_GAP * 2;
         if(this._layoutH <= _loc3_)
         {
            _loc4_ = this.VERTICAL_BOUNDARY_GAP;
            _loc5_ = param2 - this.VERTICAL_BOUNDARY_GAP - this._layoutH;
         }
         else
         {
            if(this._layoutH > param2)
            {
               return param1;
            }
            _loc4_ = 0;
            _loc5_ = param2 - this._layoutH;
         }
         return Math.round(Math.max(_loc4_,Math.min(_loc5_,param1)));
      }
      
      private function clampHorizontalPosition(param1:Number, param2:Number) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this._layoutW <= 0 || param2 <= 0)
         {
            return param1;
         }
         var _loc3_:Number = param2 - this.HORIZONTAL_BOUNDARY_GAP * 2;
         if(this._layoutW <= _loc3_)
         {
            _loc4_ = this.HORIZONTAL_BOUNDARY_GAP;
            _loc5_ = param2 - this.HORIZONTAL_BOUNDARY_GAP - this._layoutW;
         }
         else
         {
            if(this._layoutW > param2)
            {
               return param1;
            }
            _loc4_ = 0;
            _loc5_ = param2 - this._layoutW;
         }
         return Math.round(Math.max(_loc4_,Math.min(_loc5_,param1)));
      }
      
      private function invalidateLayout() : void
      {
         if(!hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,this.onInvalidateFrame,false,0,true);
         }
         this._invalidateFramesLeft = 2;
         this._invalidating = true;
      }
      
      private function onInvalidateFrame(param1:Event) : void
      {
         this.redraw();
         --this._invalidateFramesLeft;
         if(this._invalidateFramesLeft <= 0)
         {
            this._invalidating = false;
            removeEventListener(Event.ENTER_FRAME,this.onInvalidateFrame);
         }
      }
      
      private function redraw() : void
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Matrix = null;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         this.tf.autoSize = TextFieldAutoSize.LEFT;
         this.tf.x = 0;
         this.tf.y = 0;
         var _loc1_:Rectangle = this.tf.getBounds(this.textHolder);
         var _loc2_:Number = Math.max(0,_loc1_.width);
         var _loc3_:Number = Math.max(0,this.tf.textWidth) + this.TEXT_GUTTER;
         if(_loc3_ > _loc2_)
         {
            _loc2_ = _loc3_;
         }
         var _loc4_:Number = Math.max(0,_loc1_.height);
         var _loc5_:Number = Math.max(0,this.tf.textHeight);
         if(_loc5_ > _loc4_)
         {
            _loc4_ = _loc5_;
         }
         var _loc6_:Number = 0;
         var _loc7_:String = this.strokeMode != null ? this.strokeMode.toLowerCase() : "inside";
         if(this.borderThickness > 0)
         {
            if(_loc7_ == "inside")
            {
               _loc6_ = this.borderThickness;
            }
            else if(_loc7_ == "center")
            {
               _loc6_ = this.borderThickness * 0.5;
            }
            else
            {
               _loc6_ = 0;
            }
         }
         var _loc8_:Number = this.padding + _loc6_;
         var _loc9_:Number = _loc2_ + 2 * _loc8_;
         var _loc10_:Number = _loc4_ + 2 * _loc8_;
         if(this.minPanelWidth > 0)
         {
            _loc9_ = Math.max(_loc9_,this.minPanelWidth);
         }
         if(this.minPanelHeight > 0)
         {
            _loc10_ = Math.max(_loc10_,this.minPanelHeight);
         }
         this._layoutW = _loc9_;
         this._layoutH = _loc10_;
         var _loc11_:Number = _loc9_ - 2 * _loc8_;
         var _loc12_:Number = _loc10_ - 2 * _loc8_;
         var _loc13_:String = "left";
         if(Boolean(this.tf.defaultTextFormat) && Boolean(this.tf.defaultTextFormat.align))
         {
            _loc13_ = String(this.tf.defaultTextFormat.align).toLowerCase();
         }
         var _loc14_:Number = 0;
         if(_loc13_ == "right")
         {
            _loc14_ = 1;
         }
         else if(_loc13_ == "center")
         {
            _loc14_ = 0.5;
         }
         var _loc15_:Number = 0;
         var _loc16_:String = this._textVAlign != null ? this._textVAlign : "top";
         if(_loc16_ == "bottom")
         {
            _loc15_ = 1;
         }
         else if(_loc16_ == "middle")
         {
            _loc15_ = 0.5;
         }
         this.tf.x = _loc8_ + (_loc11_ - _loc2_) * _loc14_ - _loc1_.x;
         this.tf.y = _loc8_ + (_loc12_ - _loc4_) * _loc15_ - _loc1_.y;
         this.bg.graphics.clear();
         if(!this._backgroundEnabled)
         {
            this.bg.graphics.beginFill(0,0);
            if(this.cornerRadius > 0)
            {
               this.bg.graphics.drawRoundRect(0,0,_loc9_,_loc10_,this.cornerRadius,this.cornerRadius);
            }
            else
            {
               this.bg.graphics.drawRect(0,0,_loc9_,_loc10_);
            }
            this.bg.graphics.endFill();
         }
         else
         {
            _loc17_ = 0;
            if(this.borderThickness > 0)
            {
               if(_loc7_ == "inside")
               {
                  _loc17_ = this.borderThickness * 0.5;
               }
               else if(_loc7_ == "outside")
               {
                  _loc17_ = -this.borderThickness * 0.5;
               }
               else
               {
                  _loc17_ = 0;
               }
            }
            _loc18_ = _loc17_;
            _loc19_ = _loc17_;
            _loc20_ = _loc9_ - _loc17_ * 2;
            _loc21_ = _loc10_ - _loc17_ * 2;
            _loc22_ = this.borderAlpha * this._panelAlpha;
            if(this.borderThickness > 0)
            {
               this.bg.graphics.lineStyle(this.borderThickness,this.borderColor,_loc22_,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
            }
            else
            {
               this.bg.graphics.lineStyle();
            }
            if(!this._fillEnabled)
            {
               this.bg.graphics.beginFill(0,0);
            }
            else if(Boolean(this._gradientEnabled && this._gradientColors) && Boolean(this._gradientAlphas) && Boolean(this._gradientRatios))
            {
               _loc23_ = new Matrix();
               _loc24_ = this._gradientAngleDeg * (Math.PI / 180);
               _loc23_.createGradientBox(_loc20_,_loc21_,_loc24_,_loc18_,_loc19_);
               this.bg.graphics.beginGradientFill(this._gradientType,this._gradientColors,this._gradientAlphas,this._gradientRatios,_loc23_);
            }
            else
            {
               _loc25_ = this.bgAlpha * this._panelAlpha;
               this.bg.graphics.beginFill(this.bgColor,_loc25_);
            }
            if(this.cornerRadius > 0)
            {
               this.bg.graphics.drawRoundRect(_loc18_,_loc19_,_loc20_,_loc21_,this.cornerRadius,this.cornerRadius);
            }
            else
            {
               this.bg.graphics.drawRect(_loc18_,_loc19_,_loc20_,_loc21_);
            }
            this.bg.graphics.endFill();
         }
         if(!this._dragging && this._lastLayoutSettings != null)
         {
            this.layoutFromSettings(this._lastLayoutSettings,this._lastLayoutStageW,this._lastLayoutStageH);
         }
      }
      
      private function enableDragInternal() : void
      {
         if(!this._dragRequested)
         {
            return;
         }
         mouseEnabled = true;
         mouseChildren = true;
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false,0,true);
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageForDrag);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageForDrag,false,0,true);
         if(stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,0,true);
            this._dragEnabled = true;
         }
         else
         {
            this._dragEnabled = false;
         }
      }
      
      private function disableDragInternal() : void
      {
         this._dragRequested = false;
         this._dragEnabled = false;
         if(this._dragging)
         {
            this._dragging = false;
            stopDrag();
         }
         this._ctrlActive = false;
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageForDrag);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         if(stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMouseMove,true);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
      }
      
      private function onAddedToStageForDrag(param1:Event) : void
      {
         if(this._dragRequested)
         {
            this.enableDragInternal();
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         if(this._dragging)
         {
            this._dragging = false;
            stopDrag();
         }
         this._ctrlActive = false;
         this._dragEnabled = false;
         if(stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMouseMove,true);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.CONTROL)
         {
            this._ctrlActive = true;
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.CONTROL)
         {
            this._ctrlActive = false;
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(this._dragging)
         {
            return;
         }
         if(this.requireCtrlForDrag && !this._ctrlActive)
         {
            return;
         }
         this._dragging = true;
         if(this._invalidating)
         {
            this._invalidating = false;
            this._invalidateFramesLeft = 0;
            removeEventListener(Event.ENTER_FRAME,this.onInvalidateFrame);
         }
         var _loc2_:Point = this.getPointerPositionInParent();
         this._dragPointerOffsetX = this.x - _loc2_.x;
         this._dragPointerOffsetY = this.y - _loc2_.y;
         if(stage)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMouseMove,true,0,true);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
         }
      }
      
      private function onDragMouseMove(param1:MouseEvent) : void
      {
         if(!this._dragging)
         {
            return;
         }
         var _loc2_:Point = this.getPointerPositionInParent();
         this.x = this.clampHorizontalPosition(_loc2_.x + this._dragPointerOffsetX,this.getScreenWidthInFlashUnits());
         this.y = this.clampVerticalPosition(_loc2_.y + this._dragPointerOffsetY,this.getScreenHeightInFlashUnits());
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(!this._dragging)
         {
            return;
         }
         this._dragging = false;
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMouseMove,true);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         var _loc2_:Number = this._lastLayoutStageW > 0 ? this._lastLayoutStageW : (stage ? stage.stageWidth : 0);
         var _loc3_:Number = this._lastLayoutStageH > 0 ? this._lastLayoutStageH : (stage ? stage.stageHeight : 0);
         this.computeOffsetsFromCurrentPosition(_loc2_,_loc3_);
         if(this._lastLayoutSettings != null)
         {
            this.layoutFromSettings(this._lastLayoutSettings,this._lastLayoutStageW,this._lastLayoutStageH);
         }
         dispatchEvent(new Event(POSITION_CHANGED));
      }
      
      private function computeOffsetsFromCurrentPosition(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = this.getAppScale();
         var _loc4_:Number = param1;
         var _loc5_:Number = param2;
         try
         {
            if(Boolean(App) && Boolean(App.appWidth) && Boolean(App.appHeight))
            {
               _loc4_ = Number(App.appWidth) / _loc3_;
               _loc5_ = Number(App.appHeight) / _loc3_;
            }
         }
         catch(e:Error)
         {
         }
         if((_loc4_ <= 0 || _loc5_ <= 0) && Boolean(stage))
         {
            _loc4_ = stage.stageWidth;
            _loc5_ = stage.stageHeight;
         }
         var _loc6_:Number = this._lastAlignX == "CENTER" ? _loc4_ * 0.5 : (this._lastAlignX == "RIGHT" ? _loc4_ : 0);
         var _loc7_:String = this._lastAlignY;
         if(_loc7_ == "MIDDLE")
         {
            _loc7_ = "CENTER";
         }
         var _loc8_:Number = _loc7_ == "CENTER" ? _loc5_ * 0.5 : (_loc7_ == "BOTTOM" ? _loc5_ : 0);
         var _loc9_:Number = this.anchorFromString(this._lastAlignX,true);
         var _loc10_:Number = this.anchorFromString(this._lastAlignY,false);
         var _loc11_:Number = this.x + this._layoutW * _loc9_;
         var _loc12_:Number = this.y + this._layoutH * _loc10_;
         this._userOffsetPxX = (_loc11_ - _loc6_) * _loc3_;
         this._userOffsetPxY = (_loc12_ - _loc8_) * _loc3_;
         this._userOffsetPxX = Math.round(this._userOffsetPxX);
         this._userOffsetPxY = Math.round(this._userOffsetPxY);
         this._hasUserOffset = true;
      }
   }
}

