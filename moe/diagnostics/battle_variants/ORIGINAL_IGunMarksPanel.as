package poliroid.views.battle.gunmarks
{
   import net.wg.infrastructure.interfaces.IMovieClip;
   
   public interface IGunMarksPanel extends IMovieClip
   {
      
      function setData(param1:Object) : void;
      
      function setSettings(param1:Object) : void;
      
      function get panelHeight() : int;
      
      function get panelWidth() : int;
   }
}

