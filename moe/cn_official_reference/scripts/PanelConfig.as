package
{
   public class PanelConfig
   {
      
      public var lobby_x:int;
      
      public var lobby_y:int;
      
      public var battle_x:int;
      
      public var battle_y:int;
      
      public function PanelConfig(lobby_x:int, lobby_y:int, battle_x:int, battle_y:int)
      {
         super();
         this.lobby_x = lobby_x;
         this.lobby_y = lobby_y;
         this.battle_x = battle_x;
         this.battle_y = battle_y;
      }
   }
}

