package de.champi.wot.evv.views.battle
{
   import de.champi.wot.evv.utils.*;
   import flash.events.Event;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import mods.shared.BattleDisplayable;
   
   public class ExpectedVehicleValueBattle extends BattleDisplayable
   {
      
      private var _panel:LabelWithBackground;
      
      private var _panel2:LabelWithBackground;
      
      private var settings:Object;
      
      private var _pendingMoeAnchorMigration:Object;
      
      private var _pendingWnxAnchorMigration:Object;
      
      private var _panelsVisible:Boolean = true;
      
      public var py_getSettings:Function;
      
      public var py_savePosition:Function;
      
      public function ExpectedVehicleValueBattle()
      {
         super();
      }
      
      override protected function onPopulate() : void
      {
         super.onPopulate();
         this.createPanel();
      }
      
      override protected function onBeforeDispose() : void
      {
         this.destroyPanel();
         App.utils.data.cleanupDynamicObject(this.settings);
         super.onBeforeDispose();
      }
      
      override protected function onResized() : void
      {
      }
      
      private function createPanel() : void
      {
         var _loc2_:Object = null;
         this.settings = this.py_getSettings();
         var _loc1_:TextFormat = new TextFormat(this.settings.text.font,this.settings.text.size,this.settings.text.color);
         if(Boolean(this.settings.panel) && Boolean(this.settings.panel.enable))
         {
            _loc1_.align = TextFormatAlign.LEFT;
            this._panel = new LabelWithBackground(_loc1_,TextFormatAlign.LEFT,true,false,null);
            addChild(this._panel);
            this._panel.applySettings(this.settings);
            this._panel.layoutFromSettings(this.settings,stage.stageWidth,stage.stageHeight);
            this._panel.addEventListener(LabelWithBackground.POSITION_CHANGED,this.onPanelPosChanged);
            this._pendingMoeAnchorMigration = this.settings.panel.pendingAnchorMigration;
            if(this._pendingMoeAnchorMigration)
            {
               this._panel.visible = false;
            }
         }
         if(this.settings.wnxpanel)
         {
            _loc2_ = {};
            _loc2_.panel = this.settings.wnxpanel;
            _loc2_.text = this.settings.text;
            this._panel2 = new LabelWithBackground(_loc1_,TextFormatAlign.LEFT,true,false,null);
            addChild(this._panel2);
            this._panel2.applySettings(_loc2_);
            this._panel2.layoutFromSettings(_loc2_,App.appWidth,App.appHeight);
            this._panel2.addEventListener(LabelWithBackground.POSITION_CHANGED,this.onPanelPosChanged);
            this._pendingWnxAnchorMigration = this.settings.wnxpanel.pendingAnchorMigration;
            if(this._pendingWnxAnchorMigration)
            {
               this._panel2.visible = false;
            }
         }
      }
      
      private function destroyPanel() : void
      {
         if(this._panel)
         {
            this._panel.removeChildren();
            this._panel = null;
         }
         if(this._panel2)
         {
            this._panel2.removeChildren();
            this._panel2 = null;
         }
         this._pendingMoeAnchorMigration = null;
         this._pendingWnxAnchorMigration = null;
      }
      
      private function onPanelPosChanged(param1:Event) : void
      {
         var _loc2_:LabelWithBackground = param1.currentTarget as LabelWithBackground;
         if(_loc2_ == this._panel)
         {
            this.settings.panel.x = _loc2_.offsetX;
            this.settings.panel.y = _loc2_.offsetY;
            this.py_savePosition(1,this._panel.offsetX,this._panel.offsetY);
         }
         else if(_loc2_ == this._panel2)
         {
            this.settings.wnxpanel.x = _loc2_.offsetX;
            this.settings.wnxpanel.y = _loc2_.offsetY;
            this.py_savePosition(2,_loc2_.offsetX,_loc2_.offsetY);
         }
      }
      
      public function as_setScale(param1:Number) : void
      {
      }
      
      public function as_setText(param1:String) : void
      {
         if(this._panel)
         {
            this._panel.htmlText = param1;
            this.applyPendingAnchorMigration(this._panel,this.settings,this._pendingMoeAnchorMigration,1);
         }
      }
      
      public function as_setText_WNX(param1:String) : void
      {
         var _loc2_:Object = null;
         if(this._panel2)
         {
            this._panel2.htmlText = param1;
            _loc2_ = {};
            _loc2_.panel = this.settings.wnxpanel;
            _loc2_.text = this.settings.text;
            this.applyPendingAnchorMigration(this._panel2,_loc2_,this._pendingWnxAnchorMigration,2);
         }
      }
      
      private function applyPendingAnchorMigration(param1:LabelWithBackground, param2:Object, param3:Object, param4:int) : void
      {
         if(!param1 || !param2 || !param2.panel || !param3 || param1.htmlText == null || param1.htmlText.length == 0)
         {
            return;
         }
         var _loc5_:Boolean = param1.migrateAnchorPositionFrom(String(param3.oldAlignX),String(param3.oldAlignY),Number(param3.oldX),Number(param3.oldY),param2,App.appWidth,App.appHeight);
         if(!_loc5_)
         {
            return;
         }
         param1.layoutFromSettings(param2,App.appWidth,App.appHeight);
         var _loc6_:Number = param1.offsetX;
         var _loc7_:Number = param1.offsetY;
         if(param4 == 1)
         {
            this._pendingMoeAnchorMigration = null;
            delete this.settings.panel.pendingAnchorMigration;
         }
         else
         {
            this._pendingWnxAnchorMigration = null;
            delete this.settings.wnxpanel.pendingAnchorMigration;
         }
         param1.visible = this._panelsVisible;
         if(this.py_savePosition != null)
         {
            this.py_savePosition(param4,_loc6_,_loc7_);
         }
      }
      
      public function as_setPanelsVisible(param1:Boolean) : void
      {
         this._panelsVisible = param1;
         if(this._panel)
         {
            this._panel.visible = param1 && this._pendingMoeAnchorMigration == null;
         }
         if(this._panel2)
         {
            this._panel2.visible = param1 && this._pendingWnxAnchorMigration == null;
         }
      }
      
      public function as_settingsChanged() : void
      {
         var newSettings:Object = null;
         var moePositionMigrated:Boolean = false;
         var wnxPositionMigrated:Boolean = false;
         var moeOffsetX:Number = NaN;
         var moeOffsetY:Number = NaN;
         var wnxOffsetX:Number = NaN;
         var wnxOffsetY:Number = NaN;
         var newWnxSettings:Object = null;
         try
         {
            newSettings = this.py_getSettings();
            moePositionMigrated = false;
            wnxPositionMigrated = false;
            if(this._panel)
            {
               if(newSettings.panel != null && Boolean(newSettings.panel.enable))
               {
                  moePositionMigrated = this._panel.migrateAnchorPosition(newSettings,App.appWidth,App.appHeight);
                  this._panel.applySettings(newSettings);
                  this._panel.layoutFromSettings(newSettings,App.appWidth,App.appHeight);
               }
               else
               {
                  this._panel.visible = false;
               }
            }
            if(this._panel2)
            {
               if(newSettings.wnxpanel != null)
               {
                  newWnxSettings = {};
                  newWnxSettings.panel = newSettings.wnxpanel;
                  newWnxSettings.text = newSettings.text;
                  wnxPositionMigrated = this._panel2.migrateAnchorPosition(newWnxSettings,App.appWidth,App.appHeight);
                  this._panel2.applySettings(newWnxSettings);
                  this._panel2.layoutFromSettings(newWnxSettings,App.appWidth,App.appHeight);
               }
               else
               {
                  this._panel2.visible = false;
               }
            }
            this.settings = newSettings;
            this._pendingMoeAnchorMigration = Boolean(this.settings.panel) && Boolean(this.settings.panel.pendingAnchorMigration) ? this.settings.panel.pendingAnchorMigration : null;
            this._pendingWnxAnchorMigration = Boolean(this.settings.wnxpanel) && Boolean(this.settings.wnxpanel.pendingAnchorMigration) ? this.settings.wnxpanel.pendingAnchorMigration : null;
            if(Boolean(moePositionMigrated) && Boolean(this._panel) && this.py_savePosition != null)
            {
               moeOffsetX = this._panel.offsetX;
               moeOffsetY = this._panel.offsetY;
            }
            if(Boolean(wnxPositionMigrated) && Boolean(this._panel2) && this.py_savePosition != null)
            {
               wnxOffsetX = this._panel2.offsetX;
               wnxOffsetY = this._panel2.offsetY;
            }
            if(Boolean(moePositionMigrated) && Boolean(this._panel) && this.py_savePosition != null)
            {
               this.py_savePosition(1,moeOffsetX,moeOffsetY);
            }
            if(Boolean(wnxPositionMigrated) && Boolean(this._panel2) && this.py_savePosition != null)
            {
               this.py_savePosition(2,wnxOffsetX,wnxOffsetY);
            }
         }
         catch(error:Error)
         {
         }
      }
   }
}

