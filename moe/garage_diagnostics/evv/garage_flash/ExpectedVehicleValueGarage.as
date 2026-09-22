package de.champi.wot.evv.garage
{
   import de.champi.wot.utils.LabelWithBackground;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.wg.data.Aliases;
   import net.wg.data.constants.generated.LAYER_NAMES;
   import net.wg.gui.components.containers.MainViewContainer;
   import net.wg.gui.lobby.LobbyPage;
   import net.wg.gui.lobby.hangar.Hangar;
   import net.wg.infrastructure.base.AbstractView;
   import net.wg.infrastructure.events.LifeCycleEvent;
   import net.wg.infrastructure.events.LoaderEvent;
   import net.wg.infrastructure.interfaces.IManagedContent;
   import net.wg.infrastructure.interfaces.ISimpleManagedContainer;
   import net.wg.infrastructure.interfaces.IView;
   import net.wg.infrastructure.managers.impl.ContainerManagerBase;
   
   [SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="30")]
   public class ExpectedVehicleValueGarage extends AbstractView
   {
      
      public static const ResourceHackerInfo:String = "Dear Resourcehacker! Welcome to AS3. If you need any help to read the decompiled flash source feel free to send me a message and i\'ll try to help you. :)";
      
      public var py_getSettings:Function;
      
      public var py_savePosition:Function;
      
      private var _isLobbyChild:Boolean = true;
      
      private var _panel:LabelWithBackground;
      
      private var settings:Object;
      
      private var _pendingAnchorMigration:Object;
      
      private var _panelsVisible:Boolean = true;
      
      public function ExpectedVehicleValueGarage()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:IManagedContent = null;
         var _loc4_:IView = null;
         super.configUI();
         var _loc5_:ContainerManagerBase = App.containerMgr as ContainerManagerBase;
         _loc5_.loader.addEventListener(LoaderEvent.VIEW_LOADED,this.onViewLoaded);
         var _loc6_:MainViewContainer = this._getContainer(LAYER_NAMES.VIEWS) as MainViewContainer;
         if(_loc6_ != null)
         {
            _loc1_ = int(_loc6_.numChildren);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc4_ = _loc6_.getChildAt(_loc2_) as IView;
               if(_loc4_ != null)
               {
                  this.processView(_loc4_);
               }
               _loc2_++;
            }
            _loc3_ = _loc6_.getTopmostView();
            if(_loc3_ != null)
            {
               _loc6_.setFocusedView(_loc3_);
            }
         }
         App.instance.stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      override protected function onPopulate() : void
      {
         super.onPopulate();
      }
      
      private function _getContainer(param1:String) : ISimpleManagedContainer
      {
         return App.containerMgr.getContainer(LAYER_NAMES.LAYER_ORDER.indexOf(param1));
      }
      
      override protected function onDispose() : void
      {
         var _loc1_:ContainerManagerBase = App.containerMgr as ContainerManagerBase;
         _loc1_.loader.removeEventListener(LoaderEvent.VIEW_LOADED,this.onViewLoaded);
         super.onDispose();
      }
      
      override protected function nextFrameAfterPopulateHandler() : void
      {
         super.nextFrameAfterPopulateHandler();
         if(parent != App.instance)
         {
            (App.instance as MovieClip).addChild(this);
         }
      }
      
      private function onResize(param1:Event) : void
      {
         if(Boolean(this._panel) && Boolean(this.settings))
         {
            this._panel.layoutFromSettings(this.settings,stage.stageWidth,stage.stageHeight);
         }
      }
      
      private function onViewLoaded(param1:LoaderEvent) : void
      {
         this.processView(param1.view as IView);
      }
      
      private function onGaragePageDispose() : void
      {
         this.destroyPanel();
      }
      
      private function processView(param1:IView) : void
      {
         if(null == param1 || null == param1.as_config)
         {
            return;
         }
         var _loc2_:LobbyPage = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:String = param1.as_config.alias;
         if(_loc5_ != Aliases.LOBBY && _loc5_ != Aliases.LOBBY_HANGAR)
         {
            return;
         }
         if(_loc5_ == Aliases.LOBBY && !this._isLobbyChild)
         {
            return;
         }
         if(_loc5_ == Aliases.LOBBY_HANGAR && !this._isLobbyChild)
         {
            return;
         }
         if(_loc5_ == Aliases.LOBBY)
         {
            param1.addEventListener(LifeCycleEvent.ON_BEFORE_DISPOSE,this.onGaragePageDispose);
         }
         this.destroyPanel();
         this.createPanel();
         if(this._isLobbyChild)
         {
            _loc2_ = param1 as LobbyPage;
            _loc3_ = int(_loc2_.getChildIndex(_loc2_.waiting));
            _loc2_.addChildAt(this._panel,_loc3_ + 1);
         }
         else
         {
            _loc4_ = param1 as Hangar;
            _loc4_.addChild(this._panel);
         }
      }
      
      private function createPanel() : void
      {
         this.settings = this.py_getSettings();
         var _loc1_:TextFormat = new TextFormat(this.settings.text.font,this.settings.text.size,this.settings.text.color);
         _loc1_.align = TextFormatAlign.LEFT;
         this._panel = new LabelWithBackground(_loc1_,TextFormatAlign.LEFT,true,false,null);
         addChild(this._panel);
         this._panel.applySettings(this.settings);
         this._panel.layoutFromSettings(this.settings,App.appWidth,App.appHeight);
         this._panel.addEventListener(LabelWithBackground.POSITION_CHANGED,this.onPanelPosChanged);
         this._pendingAnchorMigration = Boolean(this.settings.panel) && Boolean(this.settings.panel.pendingAnchorMigration) ? this.settings.panel.pendingAnchorMigration : null;
         if(!this.settings.panel || !this.settings.panel.enable || this._pendingAnchorMigration != null)
         {
            this._panel.visible = false;
         }
         else
         {
            this._panel.visible = this._panelsVisible;
         }
      }
      
      private function destroyPanel() : void
      {
         if(this._panel)
         {
            if(this._panel.parent)
            {
               this._panel.parent.removeChild(this._panel);
            }
            this._panel = null;
         }
         this._pendingAnchorMigration = null;
      }
      
      private function onPanelPosChanged(param1:Event) : void
      {
         this.settings.panel.x = this._panel.offsetX;
         this.settings.panel.y = this._panel.offsetY;
         this.py_savePosition(this._panel.offsetX,this._panel.offsetY);
      }
      
      public function as_settingsChanged() : void
      {
         var newSettings:Object = null;
         var anchorPositionMigrated:Boolean = false;
         var pendingAnchorMigration:Object = null;
         try
         {
            newSettings = this.py_getSettings();
            anchorPositionMigrated = false;
            pendingAnchorMigration = Boolean(newSettings.panel) && Boolean(newSettings.panel.pendingAnchorMigration) ? newSettings.panel.pendingAnchorMigration : null;
            if(this._panel)
            {
               if(Boolean(newSettings.panel != null) && Boolean(newSettings.panel.enable) && (pendingAnchorMigration == null || this._panel.htmlText != null && this._panel.htmlText.length > 0))
               {
                  anchorPositionMigrated = this._panel.migrateAnchorPosition(newSettings,App.appWidth,App.appHeight);
               }
               this.settings = newSettings;
               this._pendingAnchorMigration = anchorPositionMigrated ? null : pendingAnchorMigration;
               if(this.settings.panel == null || this.settings.panel.enable == null || !this.settings.panel.enable || this._pendingAnchorMigration != null)
               {
                  this._panel.visible = false;
               }
               else
               {
                  this._panel.visible = this._panelsVisible;
               }
               this._panel.applySettings(this.settings);
               this._panel.layoutFromSettings(this.settings,App.appWidth,App.appHeight);
               if(anchorPositionMigrated)
               {
                  this._pendingAnchorMigration = null;
                  delete this.settings.panel.pendingAnchorMigration;
                  this._panel.visible = this._panelsVisible && Boolean(this.settings.panel.enable);
                  if(this.py_savePosition != null)
                  {
                     this.py_savePosition(this._panel.offsetX,this._panel.offsetY);
                  }
               }
            }
            else
            {
               this.settings = newSettings;
               this._pendingAnchorMigration = pendingAnchorMigration;
            }
         }
         catch(error:Error)
         {
         }
      }
      
      private function applyPendingAnchorMigration() : void
      {
         if(!this._panel || !this.settings || !this.settings.panel || !this.settings.panel.enable || !this._pendingAnchorMigration || this._panel.htmlText == null || this._panel.htmlText.length == 0)
         {
            return;
         }
         var _loc1_:Boolean = this._panel.migrateAnchorPositionFrom(String(this._pendingAnchorMigration.oldAlignX),String(this._pendingAnchorMigration.oldAlignY),Number(this._pendingAnchorMigration.oldX),Number(this._pendingAnchorMigration.oldY),this.settings,App.appWidth,App.appHeight);
         if(!_loc1_)
         {
            return;
         }
         this._panel.layoutFromSettings(this.settings,App.appWidth,App.appHeight);
         var _loc2_:Number = this._panel.offsetX;
         var _loc3_:Number = this._panel.offsetY;
         this._pendingAnchorMigration = null;
         delete this.settings.panel.pendingAnchorMigration;
         this._panel.visible = this._panelsVisible && Boolean(this.settings.panel.enable);
         if(this.py_savePosition != null)
         {
            this.py_savePosition(_loc2_,_loc3_);
         }
      }
      
      public function as_setText(param1:String) : void
      {
         if(this._panel)
         {
            this._panel.htmlText = param1;
            this.applyPendingAnchorMigration();
         }
      }
      
      public function as_visibilityChanged(param1:Boolean) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         this._panelsVisible = param1;
         if(this._panel)
         {
            this._panel.visible = param1 && this._pendingAnchorMigration == null && Boolean(this.settings.panel.enable);
         }
         if(this._isLobbyChild)
         {
            if(!this._panel || !this._panel.parent)
            {
               return;
            }
            _loc2_ = this._panel.parent as MovieClip;
            if(Boolean(_loc2_) && _loc2_.contains(this._panel))
            {
               _loc3_ = _loc2_.numChildren - 1;
               if(_loc2_.getChildIndex(this._panel) != _loc3_)
               {
                  _loc2_.setChildIndex(this._panel,_loc3_);
               }
            }
         }
      }
   }
}

