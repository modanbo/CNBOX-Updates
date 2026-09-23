package
{
   import com.adobe.serialization.json.JSONDecoder;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.getQualifiedClassName;
   import net.wg.app.iml.base.AbstractApplication;
   import net.wg.data.constants.Cursors;
   import net.wg.data.constants.generated.LAYER_NAMES;
   import net.wg.gui.battle.random.views.BattlePage;
   import net.wg.gui.components.containers.*;
   import net.wg.gui.components.controls.ProgressBar;
   import net.wg.infrastructure.base.AbstractView;
   import net.wg.infrastructure.events.LoaderEvent;
   import net.wg.infrastructure.interfaces.IManagedContent;
   import net.wg.infrastructure.interfaces.ISimpleManagedContainer;
   import net.wg.infrastructure.interfaces.IView;
   import net.wg.infrastructure.managers.impl.ContainerManagerBase;
   import net.wg.infrastructure.managers.impl.TooltipMgr.TooltipFormatter;
   import scaleform.clik.controls.Slider;
   import scaleform.clik.events.InputEvent;
   import stub.Component;
   
   [SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="30")]
   public class MarkOnGunUI extends AbstractView
   {
      
      public static var panelConfig:PanelConfig = null;
      
      public var data:Array = ["",0,0,0,0,0,0,0,0,0,false,false,"{}",0,"{}",0];
      
      public var lobbyPanel:MarkOnGunPanel = null;
      
      private var bgHolder:Sprite;
      
      private var _bgIsLoaded:Boolean = false;
      
      private var _backgroundId:int = -1;
      
      private var screen_x:int = 0;
      
      private var screen_y:int = 0;
      
      private var vehicleCD:String = "";
      
      private var RADIO_ASSIST:int = 0;
      
      private var TRACK_ASSIST:int = 0;
      
      private var STUN_ASSIST:int = 0;
      
      private var TANKING:int = 0;
      
      private var battleDamage:int = 0;
      
      private var movingAvgDamage:int = 0;
      
      private var c_movingAvgDamage:int = 0;
      
      private var c_damage:int = 0;
      
      private var damageRating:Number = 0;
      
      private var inBattle:Boolean = false;
      
      private var moe_slider:Slider;
      
      private var progress:ProgressBar;
      
      public var py_getCustomConfig:Function;
      
      public var openURL:Function = null;
      
      public var populated:Function = null;
      
      public var savePosition:Function = null;
      
      public var getPanelPosition:Function = null;
      
      public var retrieveData:Function = null;
      
      public var maskLobbyPanel:Boolean = false;
      
      private var last_viewtype:int = -1;
      
      private var bgCache:Object = new Object();
      
      private var componentList:Array = [];
      
      private var BGSIZE_WIDTH:Array = [218,218,299,299];
      
      private var BGSIZE_HEIGHT:Array = [132,132,214,214];
      
      private var TEXT_X:Array = [50,50,77,77];
      
      private var TEXT_Y:Array = [10,10,77,77];
      
      private var LOBBYTEXTCLIPS_ID:Object = new Object();
      
      private var isHover:Boolean = false;
      
      private var sn:Number = 0;
      
      private var testmode:Boolean = false;
      
      private var saveBattlePosition:Boolean = false;
      
      public function MarkOnGunUI()
      {
         this.bgCache[Const.LOBBY_NORMAL_ID] = new Const.LOBBY_NORMAL_BG_CLASS();
         this.bgCache[Const.LOBBY_HOVER_ID] = new Const.LOBBY_HOVER_BG_CLASS();
         this.bgCache[Const.BATTLE_NORMAL_ID] = new Const.BATTLE_NORMAL_BG_CLASS();
         this.bgCache[Const.BATTLE_HOVER_ID] = new Const.BATTLE_HOVER_BG_CLASS();
         this.bgCache[Const.BATTLELONG_NORMAL_ID] = new Const.BATTLELONG_NORMAL_BG_CLASS();
         this.bgCache[Const.BATTLELONG_HOVER_ID] = new Const.BATTLELONG_HOVER_BG_CLASS();
         var date:Date = new Date();
         this.sn = date.time;
         trace("===========================================flash class " + this + "inited");
         super();
         trace("in constructor this.maskLobbyPanel=" + this.maskLobbyPanel);
      }
      
      override protected function get autoShowViewProperty() : int
      {
         return 0;
      }
      
      public function as_hide() : void
      {
         this.visible = false;
      }
      
      public function as_show() : void
      {
         this.visible = true;
      }
      
      public function as_hideLobbyPanel() : void
      {
         trace("hide lobby panel");
         this.lobbyPanel.visible = false;
      }
      
      public function as_showLobbyPanel() : void
      {
         trace("show lobby panel according to mask and data");
         trace("this.maskLobbyPanel=" + this.maskLobbyPanel);
         trace("data=" + this.data[Const.DATA_VISIBLE]);
         this.lobbyPanel.visible = !this.maskLobbyPanel && Boolean(this.data[Const.DATA_VISIBLE]);
      }
      
      public function as_hangarDisposed() : void
      {
         this.lobbyPanel = null;
      }
      
      override protected function initialize() : void
      {
         trace("invoking initialize");
         super.initialize();
         this.width = this.bgCache[Const.LOBBY_HOVER_ID].width;
         this.height = this.bgCache[Const.LOBBY_HOVER_ID].height;
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.RELEASE_OUTSIDE,this.onReleaseOutside);
         this.focusable = false;
         this.bgHolder = new Sprite();
         this.bgHolder.name = "bgHolder";
         addChildAt(this.bgHolder,0);
      }
      
      override public function toString() : String
      {
         return "MarkOnGunUI[sn=" + this.sn + "]";
      }
      
      override protected function onDispose() : void
      {
         super.onDispose();
         var containerManagerBase:ContainerManagerBase = App.containerMgr as ContainerManagerBase;
         containerManagerBase.loader.removeEventListener(LoaderEvent.VIEW_LOADED,this.onViewLoaded);
         trace("=================================================== " + this + " disposing");
         this.saveBattlePosition = false;
      }
      
      override protected function onSetModalFocus(param1:InteractiveObject) : void
      {
         trace("setting modal focus");
      }
      
      private function getViewID() : int
      {
         var viewid:int = 0;
         var name:String = "" + App.instance;
         if(name == "[object LobbyApp]")
         {
            viewid = Const.LOBBY_NORMAL_ID;
         }
         else
         {
            viewid = Const.BATTLE_NORMAL_ID;
         }
         if(this.isHover)
         {
            viewid++;
         }
         return viewid;
      }
      
      private function getViewType(viewid:int) : int
      {
         trace("viewid is " + viewid + " in getViewType");
         if(viewid == Const.LOBBY_NORMAL_ID || viewid == Const.LOBBY_HOVER_ID)
         {
            return Const.VIEW_LOBBY;
         }
         if(viewid == Const.BATTLE_NORMAL_ID || viewid == Const.BATTLE_HOVER_ID)
         {
            return Const.VIEW_BATTLE;
         }
         return Const.VIEW_UNKNOWN;
      }
      
      override protected function configUI() : void
      {
         trace("configUI invoked");
         super.configUI();
         var containerManagerBase:ContainerManagerBase = App.containerMgr as ContainerManagerBase;
         containerManagerBase.loader.addEventListener(LoaderEvent.VIEW_LOADED,this.onViewLoaded);
      }
      
      private function getTopAncestor(obj:DisplayObject) : DisplayObject
      {
         while(obj.parent != null)
         {
            obj = obj.parent;
         }
         return obj;
      }
      
      private function printAllTree(obj:DisplayObject, indent:Number = 0) : String
      {
         var topAncestor:DisplayObject = this.getTopAncestor(obj);
         trace("topAncestor " + topAncestor);
         trace(" found(" + (topAncestor is DisplayObjectContainer) + ")");
         if(topAncestor != null)
         {
            return this.printTree(topAncestor);
         }
         return "topAnsestor is null";
      }
      
      private function printTree(obj:DisplayObject, indent:Number = 1) : String
      {
         var parent_index:Number = NaN;
         var obj_text:String = null;
         var iView:IView = null;
         var container:DisplayObjectContainer = null;
         var i:Number = NaN;
         var content:String = new Array(indent - 1).join("-");
         var iView_alias:String = "";
         if(obj is IView)
         {
            iView = obj as IView;
            iView_alias = iView.as_config.alias;
         }
         if(obj is DisplayObjectContainer)
         {
            container = obj as DisplayObjectContainer;
            this.processView(container);
            content += "+";
            content += obj;
            content += "(name:" + obj.name + ")(visible:" + obj.visible + ")(parent:" + obj.parent + ")";
            if(obj is IView)
            {
               content += "(alias:" + iView_alias + ")";
            }
            if(obj.parent != null)
            {
               content += "(index:" + obj.parent.getChildIndex(obj) + ")";
            }
            if(obj is TextField)
            {
               content += "text:" + (obj as TextField).text + ")";
            }
            content += "\r\n";
            for(i = 0; i < container.numChildren; i++)
            {
               content += this.printTree(container.getChildAt(i),indent + 1);
            }
         }
         else
         {
            content += "-";
            content += obj;
            content += "(name:" + obj.name + ")(visible:" + obj.visible;
            if(obj is IView)
            {
               content += "(alias:" + iView_alias + ")";
            }
            if(obj.parent != null)
            {
               content += "(index:" + obj.parent.getChildIndex(obj) + ")";
            }
            if(obj is TextField)
            {
               content += "text:" + (obj as TextField).text + ")";
            }
            content += "\r\n";
         }
         return content;
      }
      
      private function traverseView(layerName:String = "subView") : void
      {
         trace("traverseView over " + layerName);
         var mainViewContainer:* = null;
         var content:String = this.printAllTree(this);
         trace("got mainViewContainer =" + mainViewContainer);
      }
      
      private function onViewLoaded(e:LoaderEvent) : void
      {
         trace("ViewLoaded triggered" + e.view);
         this.traverseView();
      }
      
      private function _getContainer(param1:String) : ISimpleManagedContainer
      {
         return App.containerMgr.getContainer(LAYER_NAMES.LAYER_ORDER.indexOf(param1));
      }
      
      public function createPanel(thisView:IView) : void
      {
      }
      
      private function processView(thisView:DisplayObjectContainer) : void
      {
         var className:String = null;
         try
         {
            if(this.lobbyPanel == null)
            {
               className = getQualifiedClassName(thisView).split("::")[1];
               if(className == "LobbyApp")
               {
                  trace("before panel creation this.maskLobbyPanel=" + this.maskLobbyPanel);
                  this.lobbyPanel = App.utils.classFactory.getComponent("MarkOnGunPanel",MarkOnGunPanel);
                  trace("after panel creation this.maskLobbyPanel=" + this.maskLobbyPanel);
                  if(!this.disposed)
                  {
                     this.lobbyPanel.setParentView(this);
                     trace("setting parentView of lobbypanel to " + this);
                     this.lobbyPanel.updateDisplay("init");
                  }
                  else
                  {
                     trace(this + " UI disposed , dont\'t set it as parentView");
                  }
                  thisView.addChild(this.lobbyPanel);
                  trace("got LobbyPanel=" + this.lobbyPanel);
                  trace("added " + this.lobbyPanel + " to hangar");
               }
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
      }
      
      private function setFocusToContainer() : void
      {
         var mainViewContainer:MainViewContainer = this.searchMainViewContainer();
         var topmost:IManagedContent = mainViewContainer.getTopmostView();
         if(topmost != null)
         {
            mainViewContainer.setFocusedView(topmost);
         }
         else
         {
            trace("topmost is null in setfocus");
         }
      }
      
      private function searchMainViewContainer() : MainViewContainer
      {
         var app:AbstractApplication = App.instance as AbstractApplication;
         var len:int = int(app.numChildren);
         var mainViewContainer:MainViewContainer = null;
         for(var i:int = 0; i < len; i++)
         {
            mainViewContainer = app.getChildAt(i) as MainViewContainer;
            if(mainViewContainer != null)
            {
               break;
            }
         }
         return mainViewContainer;
      }
      
      public function as_loadConfig() : void
      {
         MarkOnGunUI.panelConfig = Utils.loadPanelPosition(this.getPanelPosition());
      }
      
      override protected function onPopulate() : void
      {
         var i:int = 0;
         var viewContainer:* = undefined;
         var j:int = 0;
         var battlepageui:* = undefined;
         var battleMessageUI:* = undefined;
         var fullStats:* = undefined;
         var k:int = 0;
         var ui:* = undefined;
         var index:int = 0;
         super.onPopulate();
         try
         {
            for(i = 0; i < parent.parent.numChildren; i++)
            {
               viewContainer = parent.parent.getChildAt(i);
               if(viewContainer is MainViewContainer)
               {
                  for(j = 0; j < viewContainer.numChildren; j++)
                  {
                     battlepageui = viewContainer.getChildAt(j);
                     if(battlepageui is BattlePage)
                     {
                        battleMessageUI = null;
                        fullStats = null;
                        for(k = 0; k < battlepageui.numChildren; k++)
                        {
                           ui = battlepageui.getChildAt(k);
                           if(ui.name == "messageListsContainer")
                           {
                              battleMessageUI = ui;
                           }
                           if(ui.name == "fullStats")
                           {
                              fullStats = ui;
                           }
                        }
                        if(battleMessageUI != null && fullStats != null)
                        {
                           trace("battleMessageUI=" + battleMessageUI + ",fullStats=" + fullStats);
                           battlepageui.removeChild(battleMessageUI);
                           index = int(battlepageui.getChildIndex(fullStats));
                           this.parent.removeChild(this);
                           battlepageui.addChildAt(this,index);
                           battlepageui.addChildAt(battleMessageUI,index);
                        }
                        break;
                     }
                  }
                  break;
               }
            }
         }
         catch(e:Error)
         {
            trace("not in battle");
            trace(e.getStackTrace());
         }
         trace("onPopulate this.maskLobbyPanel=" + this.maskLobbyPanel);
         trace("onPopulate has hasFocus = " + this.hasFocus);
         this.focusable = false;
         this.traverseView();
         this.saveBattlePosition = true;
         trace("===========================================flash class populate");
         if(MarkOnGunUI.panelConfig == null)
         {
            MarkOnGunUI.panelConfig = Utils.loadPanelPosition(this.getPanelPosition());
         }
         x = MarkOnGunUI.panelConfig.battle_x;
         y = MarkOnGunUI.panelConfig.battle_y;
         trace("x=" + x);
         trace("y=" + y);
         this.populated();
      }
      
      override protected function initSize() : void
      {
         trace("initSize");
         var viewid:int = this.getViewID();
         var bgwidth:int = int(this.BGSIZE_WIDTH[viewid]);
         var bgheight:int = int(this.BGSIZE_HEIGHT[viewid]);
         setViewSize(bgwidth,bgheight);
         trace("view size is " + this.width + "x" + this.height);
      }
      
      override protected function draw() : void
      {
         var viewid:int = 0;
         var viewtype:int = 0;
         var slidervalue:Number = NaN;
         var pyData:Array = null;
         var i:int = 0;
         var dispobj:DisplayObject = null;
         try
         {
            trace("================================================invoking draw in " + this);
            trace(App.appWidth + "x" + App.appHeight + "@" + App.appScale);
            super.draw();
            viewid = this.getViewID();
            trace("viewid is " + viewid + " in draw()");
            viewtype = this.getViewType(viewid);
            if(viewtype == Const.VIEW_LOBBY)
            {
               if(this.componentList.length == 0)
               {
                  this.componentList = Utils.createComponentList(Const.BATTLECOMPONENTS);
                  this.traverseView();
               }
               visible = false;
               return;
            }
            if(viewtype == Const.VIEW_BATTLE && (this.data[Const.DATA_MDICT] == "{}" || this.data[Const.DATA_ESTIMATEDICT] == "{}"))
            {
               pyData = this.retrieveData();
               trace("MarkOnGunUI data pre-battle retrieve , got data = " + pyData);
               this.data = pyData.slice();
               trace("data in MarkOnGunUI is copied from dumpfile");
            }
            visible = this.data[Const.DATA_VISIBLE];
            this.setBackground(viewid);
            trace("lastviewtype=" + this.last_viewtype + ",viewid=" + viewid);
            if(this.componentList.length == 0)
            {
               this.componentList = Utils.createComponentList(Const.BATTLECOMPONENTS);
               slidervalue = this.data[Const.DATA_C_DAMAGE] / this.data[Const.DATA_MOVING_AVG_DAMAGE] * 100;
               for(i = 0; i < this.componentList.length; i++)
               {
                  dispobj = (this.componentList[i] as Component).dispobj;
                  addChild(dispobj);
               }
            }
            this.updateDisplay();
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
         finally
         {
            trace("in draw");
         }
      }
      
      private function onControlOut(e:MouseEvent) : void
      {
         App.toolTipMgr.hide();
      }
      
      private function onControlOver(e:MouseEvent) : void
      {
         trace(App.toolTipMgr.getDefaultTooltipProps());
         var tf:TooltipFormatter = new TooltipFormatter();
         tf.addAttention("Attention",true);
         tf.addBody("Body",true);
         tf.addHeader("header");
         App.toolTipMgr.show("平均战斗力");
      }
      
      private function onRollOver(e:MouseEvent) : void
      {
         trace("onRollOver");
         this.isHover = true;
         App.cursor.forceSetCursor(Cursors.DRAG_OPEN);
         invalidate();
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         trace("onMouseDown");
         App.cursor.forceSetCursor(Cursors.MOVE);
         this.startDrag();
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         trace("onMouseUp");
         this.stopDrag();
         this.savePosition(true,this.x,this.y);
         App.cursor.forceSetCursor(Cursors.DRAG_OPEN);
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         trace("onMouseOut");
         this.isHover = false;
         App.cursor.forceSetCursor(Cursors.ARROW);
      }
      
      private function onRollOut(e:MouseEvent) : void
      {
         trace("onRollOut");
         this.isHover = false;
         App.cursor.forceSetCursor(Cursors.ARROW);
         this.stopDrag();
         invalidate();
      }
      
      override protected function allowHandleInput() : Boolean
      {
         return false;
      }
      
      private function onReleaseOutside(e:MouseEvent) : void
      {
         trace("onReleaseOutside");
         this.isHover = false;
         this.stopDrag();
         invalidate();
      }
      
      override public function updateStage(param1:Number, param2:Number) : void
      {
         trace("updating MarkOnGunBattleUI with " + param1 + "," + param2 + "," + this.data[Const.DATA_INBATTLE]);
         this.maskLobbyPanel = false;
         this.refreshLocation(param1,param2);
         super.updateStage(param1,param2);
      }
      
      private function refreshLocation(screen_x:Number, screen_y:Number) : void
      {
         var lobby_x_ratio:Number = NaN;
         var lobby_y_ratio:Number = NaN;
         var battle_x_ratio:Number = NaN;
         var battle_y_ratio:Number = NaN;
         trace("refreshLocation this.maskLobbyPanel=" + this.maskLobbyPanel);
         trace("refreshing location, windw resize to " + screen_x + "x" + screen_y);
         if(MarkOnGunUI.panelConfig == null)
         {
            MarkOnGunUI.panelConfig = Utils.loadPanelPosition(this.getPanelPosition());
         }
         if(screen_x != 0 && screen_y != 0)
         {
            trace("lobbyPanel=" + this.lobbyPanel);
            if(this.lobbyPanel != null)
            {
               lobby_x_ratio = Number(this.lobbyPanel.x) / this.screen_x;
               lobby_y_ratio = Number(this.lobbyPanel.y) / this.screen_y;
               if(lobby_x_ratio >= 0.8)
               {
                  lobby_x_ratio = 0.8;
               }
               else if(lobby_x_ratio < 0)
               {
                  lobby_x_ratio = 0;
               }
               if(lobby_y_ratio >= 0.8)
               {
                  lobby_y_ratio = 0.8;
               }
               else if(lobby_y_ratio < 0)
               {
                  lobby_y_ratio = 0;
               }
               this.lobbyPanel.x = lobby_x_ratio * screen_x;
               this.lobbyPanel.y = lobby_y_ratio * screen_y;
               trace("lobby panel at(" + this.lobbyPanel.x + "," + this.lobbyPanel.y + ")");
               this.savePosition(false,this.lobbyPanel.x,this.lobbyPanel.y);
            }
            trace("saveBattlePosition=" + this.saveBattlePosition);
            trace("this.x this.y=" + this.x + "," + this.y);
            if(this.saveBattlePosition)
            {
               battle_x_ratio = Number(x) / this.screen_x;
               battle_y_ratio = Number(y) / this.screen_y;
               if(battle_x_ratio >= 0.8)
               {
                  battle_x_ratio = 0.8;
               }
               else if(battle_x_ratio < 0)
               {
                  battle_x_ratio = 0;
               }
               if(battle_y_ratio >= 0.8)
               {
                  battle_y_ratio = 0.8;
               }
               else if(battle_y_ratio < 0)
               {
                  battle_y_ratio = 0;
               }
               this.x = battle_x_ratio * screen_x;
               this.y = battle_y_ratio * screen_y;
               trace("battle panel moved to(" + x + "," + y + ")");
               this.savePosition(true,x,y);
            }
         }
         this.screen_x = screen_x;
         this.screen_y = screen_y;
         trace("saved window size changed to (" + this.screen_x + "," + this.screen_y + ")");
      }
      
      override public function handleInput(e:InputEvent) : void
      {
         e.handled = false;
         super.handleInput(e);
      }
      
      public function as_clearPercentile() : void
      {
         if(this.lobbyPanel != null)
         {
            this.lobbyPanel.clearPercentile();
         }
      }
      
      public function as_setMaskLobbyPanel(mask:Boolean) : void
      {
         trace("set maskLobbyPanel to " + mask);
         this.maskLobbyPanel = mask;
      }
      
      public function as_updateData(values:Array, reason:String, setActive:Boolean) : void
      {
         var i:int = 0;
         trace("this.maskLobbyPanel=" + this.maskLobbyPanel);
         try
         {
            for(i = 0; i < values.length; i++)
            {
               this.data[i] = values[i];
            }
            trace("1. got " + this.data + " due to " + reason);
            this.updateDisplay(reason);
            if(this.lobbyPanel == null)
            {
               trace("pannel is empty now,traversing view");
               trace("data[Const.DATA_INBATTLE]=" + this.data[Const.DATA_INBATTLE]);
               if(!this.data[Const.DATA_INBATTLE])
               {
                  try
                  {
                     this.traverseView();
                  }
                  catch(err:Error)
                  {
                     trace("caught error in traverseView() " + err.getStackTrace());
                  }
               }
            }
            trace("this.maskLobbyPanel=" + this.maskLobbyPanel);
            if(this.lobbyPanel != null)
            {
               this.lobbyPanel.updateData(this.data,reason);
               this.lobbyPanel.updateDisplay(reason);
               trace("data[Const.DATA_VISIBLE]=" + this.data[Const.DATA_VISIBLE]);
               if(this.inBattle)
               {
                  this.lobbyPanel.visible = this.data[Const.DATA_VISIBLE];
               }
               else
               {
                  trace("this.maskLobbyPanel=" + this.maskLobbyPanel);
                  if(this.maskLobbyPanel)
                  {
                     this.lobbyPanel.visible = false;
                  }
                  else
                  {
                     trace("this.maskLobbyPanel = " + this.maskLobbyPanel);
                     this.lobbyPanel.visible = this.data[Const.DATA_VISIBLE];
                  }
               }
            }
         }
         catch(err:Error)
         {
            trace("try catch in update data" + err.getStackTrace());
         }
      }
      
      public function as_getLobbyPanel() : MarkOnGunPanel
      {
         return this.lobbyPanel;
      }
      
      private function updateDisplay(reason:String = "ondraw") : void
      {
         var pyData:Array = null;
         var originalMAD:int = 0;
         var currentMAD:int = 0;
         var estimated_DR:Number = NaN;
         var original_DR:Number = NaN;
         var viewtype:int = this.getViewType(this.getViewID());
         trace("in updateDisplay of hidden panel viewid=" + this.getViewID());
         trace("data.inbattle = " + this.data[Const.DATA_INBATTLE] + " data.inbattle=false , viewtye=2? ");
         if(viewtype == Const.VIEW_BATTLE && (this.data[Const.DATA_MDICT] == "{}" || this.data[Const.DATA_ESTIMATEDICT] == "{}"))
         {
            pyData = this.retrieveData();
            trace("MarkOnGunUI data retrieve , got data = " + pyData);
            this.data = pyData.slice();
            trace("data in MarkOnGunUI is retrieved");
         }
         trace("updating " + this);
         if(this.componentList.length == 0)
         {
            if(reason == "ondraw")
            {
               trace("componentList is empty, calling invalidate()");
               invalidate();
            }
         }
         else if(viewtype == Const.VIEW_BATTLE)
         {
            trace("updating display due to " + reason);
            trace(this.componentList[Const.BATTLECOMP_DR].dispobj.text);
            trace(this.data[Const.DATA_DAMAGE_RATING] + "%");
            this.componentList[Const.BATTLECOMP_DR].dispobj.text = Number(this.data[Const.DATA_DAMAGE_RATING]).toFixed(2) + "%";
            this.componentList[Const.BATTLECOMP_DMG].dispobj.text = Number(this.data[Const.DATA_C_DAMAGE]).toFixed(0);
            this.componentList[Const.BATTLECOMP_C_MAD].dispobj.text = Number(this.data[Const.DATA_C_MOVING_AVG_DAMAGE]).toFixed(0);
            originalMAD = int(this.data[Const.DATA_MOVING_AVG_DAMAGE]);
            currentMAD = int(this.data[Const.DATA_C_MOVING_AVG_DAMAGE]);
            Utils.changeDeltaDigit(this,this.componentList[Const.BATTLECOMP_MAD_ARROW],this.componentList[Const.BATTLECOMP_MAD_DELTA],currentMAD - originalMAD);
            try
            {
               estimated_DR = this.getEstimated_DR(this.data[Const.DATA_C_MOVING_AVG_DAMAGE]);
               original_DR = Number(this.data[Const.DATA_DAMAGE_RATING]);
               Utils.changeDeltaDigit(this,this.componentList[Const.BATTLECOMP_DR_ARROW],this.componentList[Const.BATTLECOMP_DR_DELTA],estimated_DR - original_DR,true);
               this.componentList[Const.BATTLECOMP_DR].dispobj.text = estimated_DR.toFixed(2) + "%";
            }
            catch(e:Error)
            {
               trace(e.getStackTrace());
            }
            Utils.adjustComponentList(this.componentList);
         }
      }
      
      private function getEstimated_DR(avgDmg:int) : Number
      {
         var percent_center:int = 0;
         var next_percent:int = 0;
         var centerKey:String = null;
         var nextKey:String = null;
         var rating:Number = NaN;
         var floorDmg:Number = NaN;
         var ceilingDmg:Number = NaN;
         var lower_limit:int = 0;
         var upper_limit:int = 0;
         var estimate:Number = NaN;
         var curve:Object = null;
         var i:int = 0;
         var valueOnCurve:Number = NaN;
         var foundSpan:Boolean = false;
         var t:Number = NaN;
         var P0_x:Number = NaN;
         var P0_y:Number = NaN;
         var x_21:Number = NaN;
         var y_21:Number = NaN;
         var x_22:Number = NaN;
         var y_22:Number = NaN;
         var P1_x:Number = NaN;
         var P1_y:Number = NaN;
         var P2_x:Number = NaN;
         var P2_y:Number = NaN;
         var A_x:Number = NaN;
         var A_y:Number = NaN;
         var B_x:Number = NaN;
         var B_y:Number = NaN;
         var P_x:Number = NaN;
         var P_y:Number = NaN;
         var currentDmg:Number = NaN;
         var nextDmg:Number = NaN;
         var debugtrace:Boolean = false;
         var jsonString:String = this.data[Const.DATA_ESTIMATEDICT];
         var result:Object = new JSONDecoder(jsonString,false).getValue();
         var offset:Number = 0;
         if(result.tank_id == undefined)
         {
            estimate = 0;
         }
         else
         {
            if(debugtrace)
            {
               trace(jsonString);
            }
            percent_center = int(this.data[Const.DATA_DAMAGE_RATING]);
            if(debugtrace)
            {
               trace("percent_center=" + percent_center);
            }
            next_percent = percent_center + 1;
            centerKey = String(percent_center);
            if(debugtrace)
            {
               trace("centerKey=" + centerKey);
            }
            nextKey = String(next_percent);
            rating = Number(this.data[Const.DATA_DAMAGE_RATING]);
            if(debugtrace)
            {
               trace(result.data);
            }
            floorDmg = Number(result.centerKey);
            ceilingDmg = Number(result.nextKey);
            lower_limit = percent_center - 20;
            if(lower_limit < 0)
            {
               lower_limit = 0;
            }
            upper_limit = percent_center + 21;
            if(upper_limit > 100)
            {
               upper_limit = 100;
            }
            estimate = percent_center;
            curve = new Object();
            for(i = lower_limit; i <= upper_limit; i++)
            {
               if(i <= 20)
               {
                  for(t = 0; t < 1; t += 0.01)
                  {
                     P0_x = 0;
                     P0_y = 0;
                     x_21 = 21;
                     y_21 = Number(result["21"]);
                     x_22 = 22;
                     y_22 = Number(result["22"]);
                     P1_x = 21 - y_21 / (y_22 - y_21);
                     P1_y = 0;
                     P2_x = 21;
                     P2_y = Number(result["21"]);
                     A_x = t * P1_x;
                     A_y = 0;
                     B_x = P1_x + (P2_x - P1_x) * t;
                     B_y = P2_y * t;
                     P_x = (B_x - A_x) * t + A_x;
                     P_y = B_y * t;
                     if(P_x > i)
                     {
                        curve[i] = P_y;
                        break;
                     }
                  }
               }
               else
               {
                  curve[i] = result[String(i)];
               }
               if(debugtrace)
               {
                  trace(i + "," + curve[i]);
               }
            }
            valueOnCurve = this.lookupInCurve(Number(this.data[Const.DATA_DAMAGE_RATING]),curve,0,lower_limit,upper_limit);
            if(debugtrace)
            {
               trace("valueOnCurve=" + valueOnCurve);
            }
            offset = Number(this.data[Const.DATA_MOVING_AVG_DAMAGE]) - valueOnCurve;
            foundSpan = false;
            if(debugtrace)
            {
               trace("offset=" + offset);
            }
            for(i = lower_limit; i <= upper_limit; i++)
            {
               currentDmg = curve[i] + offset;
               nextDmg = curve[i + 1] + offset;
               if(debugtrace)
               {
                  trace("currentDmg(" + i + ")=" + currentDmg);
                  trace("nextDmg(" + (i + 1) + ")=" + nextDmg);
               }
               if(avgDmg >= currentDmg)
               {
                  if(avgDmg < nextDmg)
                  {
                     if(debugtrace)
                     {
                        trace("i=" + i + ",avgDmg=" + avgDmg + ",current=" + currentDmg + ",next=" + nextDmg);
                     }
                     estimate = (avgDmg - currentDmg) / (nextDmg - currentDmg) + i;
                     foundSpan = true;
                     break;
                  }
                  estimate = i;
               }
               else if(!foundSpan)
               {
                  estimate = upper_limit;
               }
            }
         }
         return estimate;
      }
      
      private function lookupInCurve(battleRating:Number, curve:Object, offset:Number, lower_limit:int, upper_limit:int) : Number
      {
         var _left:int = int(battleRating);
         var _right:int = _left + 1;
         var value:Number = curve[_left] + (battleRating - _left) * (curve[_right] - curve[_left]);
         trace("_left=" + _left + ",_right=" + _right + ",curve[_left]=" + curve[_left] + ",curve[_right]=" + curve[_right]);
         return value;
      }
      
      public function setBackground(id:int) : void
      {
         var background:DisplayObject = this.bgCache[id];
         if(this._backgroundId != id)
         {
            trace("change _backgroundId to " + id);
            this._backgroundId = id;
            this.updateBgHolder(background);
            this._bgIsLoaded = true;
         }
      }
      
      protected function updateBgHolder(background:DisplayObject) : void
      {
         this.clearBackground();
         if(visible)
         {
            this.bgHolder.width = background.width;
            this.bgHolder.height = background.height;
            this.bgHolder.scaleX = this.bgHolder.scaleY = 1;
            this.bgHolder.addChild(background);
         }
      }
      
      private function clearBackground() : void
      {
         if(this.bgHolder.numChildren > 0)
         {
            this.bgHolder.removeChildAt(0);
         }
      }
      
      override protected function onSetFocus(obj:InteractiveObject) : void
      {
         trace("got focus");
         this.setFocusToContainer();
      }
   }
}

