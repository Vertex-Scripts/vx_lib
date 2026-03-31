import DebugBackgroundImage from "./components/debug-background-image";
import ContextMenu from "./features/contextMenu/context-menu";
import PedInteraction from "./features/pedInteraction/ped-interaction";
import ProgressCircle from "./features/progress/progress.circle";
import { useNuiEvent } from "./hooks/useNuiEvent";
import setClipboard from "./utils/setClipboard";

export default function App() {
   useNuiEvent("setClipboard", (data: string) => {
      setClipboard(data);
   });

   return (
      <div className="text-foreground">
         <ContextMenu />
         <PedInteraction />
         <ProgressCircle />

         <DebugBackgroundImage />
      </div>
   );
}
