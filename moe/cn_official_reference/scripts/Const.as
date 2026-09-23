package
{
   import stub.ImageComponent;
   import stub.TextComponent;
   
   public class Const
   {
      
      public static var VIEW_UNKNOWN:int = -1;
      
      public static var VIEW_LOBBY:int = 0;
      
      public static var VIEW_BATTLE:int = 1;
      
      public static var LOBBY_NORMAL_ID:int = 0;
      
      public static var LOBBY_HOVER_ID:int = 1;
      
      public static var BATTLE_NORMAL_ID:int = 2;
      
      public static var BATTLE_HOVER_ID:int = 3;
      
      public static var BATTLELONG_NORMAL_ID:int = 4;
      
      public static var BATTLELONG_HOVER_ID:int = 5;
      
      public static var LOBBYCOMP_STAR1:int = 1;
      
      public static var LOBBYCOMP_STAR2:int = 2;
      
      public static var LOBBYCOMP_STAR3:int = 3;
      
      public static var LOBBYCOMP_DR:int = 4;
      
      public static var LOBBYCOMP_ARROW:int = 5;
      
      public static var LOBBYCOMP_DELTA:int = 6;
      
      public static var LOBBYCOMP_MAD:int = 8;
      
      public static var LOBBYCOMP_65:int = 10;
      
      public static var LOBBYCOMP_85:int = 12;
      
      public static var LOBBYCOMP_95:int = 14;
      
      public static var LOBBYCOMP_100:int = 16;
      
      public static var BATTLECOMP_DR:int = 0;
      
      public static var BATTLECOMP_DR_ARROW:int = 1;
      
      public static var BATTLECOMP_DR_DELTA:int = 2;
      
      public static var BATTLECOMP_DMG:int = 4;
      
      public static var BATTLECOMP_C_MAD:int = 6;
      
      public static var BATTLECOMP_MAD_ARROW:int = 7;
      
      public static var BATTLECOMP_MAD_DELTA:int = 8;
      
      public static var DATA_TANK_ID:int = 0;
      
      public static var DATA_RADIO_ASSIST:int = 1;
      
      public static var DATA_TRACK_ASSIST:int = 2;
      
      public static var DATA_STUN_ASSIST:int = 3;
      
      public static var DATA_TANKING:int = 4;
      
      public static var DATA_BATTLE_DAMAGE:int = 5;
      
      public static var DATA_MOVING_AVG_DAMAGE:int = 6;
      
      public static var DATA_C_MOVING_AVG_DAMAGE:int = 7;
      
      public static var DATA_C_DAMAGE:int = 8;
      
      public static var DATA_DAMAGE_RATING:int = 9;
      
      public static var DATA_INBATTLE:int = 10;
      
      public static var DATA_VISIBLE:int = 11;
      
      public static var DATA_MDICT:int = 12;
      
      public static var DATA_LOBBY_DELTA:int = 13;
      
      public static var DATA_ESTIMATEDICT:int = 14;
      
      public static var DATA_MARKONGUN:int = 15;
      
      public static var IMAGE_SCALE:Number = 1;
      
      public static var LOBBY_NORMAL_BG_CLASS:Class = Const_LOBBY_NORMAL_BG_CLASS;
      
      public static var LOBBY_HOVER_BG_CLASS:Class = Const_LOBBY_HOVER_BG_CLASS;
      
      public static var LOBBY_CIRCLE:Class = Const_LOBBY_CIRCLE;
      
      public static var BATTLE_NORMAL_BG_CLASS:Class = Const_BATTLE_NORMAL_BG_CLASS;
      
      public static var BATTLE_HOVER_BG_CLASS:Class = Const_BATTLE_HOVER_BG_CLASS;
      
      public static var BATTLELONG_NORMAL_BG_CLASS:Class = Const_BATTLELONG_NORMAL_BG_CLASS;
      
      public static var BATTLELONG_HOVER_BG_CLASS:Class = Const_BATTLELONG_HOVER_BG_CLASS;
      
      public static var DARKSTAR_CLASS:Class = Const_DARKSTAR_CLASS;
      
      public static var LIGHTSTAR_CLASS:Class = Const_LIGHTSTAR_CLASS;
      
      public static var ARROWINC_CLASS:Class = Const_ARROWINC_CLASS;
      
      public static var ARROWDESC_CLASS:Class = Const_ARROWDESC_CLASS;
      
      public static var LOBBYCOMPONENTS:Array = [new ImageComponent("20","24",10,10,true,Const.LOBBY_CIRCLE),new ImageComponent("72","11",22,21,true,Const.LIGHTSTAR_CLASS),new ImageComponent("89","11",22,21,true,Const.LIGHTSTAR_CLASS),new ImageComponent("106","11",22,21,true,Const.LIGHTSTAR_CLASS),new TextComponent("73","37",0,0,true,"0%",16776438,18),new ImageComponent("+7","39",11,6,true,Const.ARROWINC_CLASS),new TextComponent("+3","39",0,0,true,"3.2%",4128665,14),new TextComponent("73","61",70,0,true,"平均标伤",16777215,12,0.6),new TextComponent("+5","60",22,0,true,"0",16772812,14),new TextComponent("19","95",25,0,true,"65%",16777215,13,0.6),new TextComponent("55","95",50,0,true,"--",16777215,13),new TextComponent("125","95",24,0,true,"85%",16777215,13,0.6),new TextComponent("160","95",30,0,true,"--",16777215,13),new TextComponent("19","114",25,0,true,"95%",16777215,13,0.6),new TextComponent("54","114",31,0,true,"--",16777215,13),new TextComponent("119","114",30,0,true,"100%",16777215,13,0.6),new TextComponent("160"
      ,"114",30,0,true,"--",16777215,13)];
      
      public static var BATTLECOMPONENTS:Array = [new TextComponent("14","14",61,14,true,"{DR}",16776438,18),new ImageComponent("+7","17",11,6,true,Const.ARROWINC_CLASS),new TextComponent("+3","18",6,12,true,"0.00",16733502,14),new TextComponent("14","42",49,13,true,"本场标伤",16777215,14,0.7),new TextComponent("+6","41",31,10,true,"0",16777215,14),new TextComponent("15","66",49,13,true,"平均标伤",16777215,14,0.7),new TextComponent("+6","65",39,10,true,"0",16777215,14),new ImageComponent("+7","66",11,6,true,Const.ARROWINC_CLASS),new TextComponent("+3","66",6,11,true,"6",16733502,14)];
      
      public function Const()
      {
         super();
      }
   }
}

