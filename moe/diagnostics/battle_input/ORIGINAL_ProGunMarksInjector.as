package
{
   import mods.common.AbstractComponentInjector;
   
   [SWF(width="1024", height="768", backgroundColor="#666666", frameRate="24")]
   public class ProGunMarksInjector extends AbstractComponentInjector
   {
      
      public function ProGunMarksInjector()
      {
         super();
      }
      
      override protected function onPopulate() : void
      {
         autoDestroy = false;
         componentName = "ProGunMarksUI";
         componentUI = ProGunMarksUI;
         super.onPopulate();
      }
   }
}

