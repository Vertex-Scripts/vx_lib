import DebugBackgroundImage from "./components/debug-background-image";
import ContextMenu from "./features/contextMenu/context-menu";
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
         <ProgressCircle />

         <DebugBackgroundImage />
      </div>
   );
}
