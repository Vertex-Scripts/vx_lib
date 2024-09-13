import { ContextOptions } from "~/types/context";
import { isBrowser } from "~/utils/cef";
import { fetchNui } from "~/utils/fetchNui";
import { cn } from "~/utils/tw";

export default function ContextMenuOption(props: {
  option: ContextOptions;
  id: number;
  hideContextMenu: () => void;
}) {
  function onClick() {
    if (props.option.disabled) return;

    if (!isBrowser()) {
      fetchNui("clickContextMenuOption", props.id);
      return;
    }

    props.hideContextMenu();
  }

  return (
    <div
      className={cn(
        "p-3 bg-background rounded-lg px-5 font-medium cursor-pointer hover:bg-muted transition-colors",
        props.option.disabled
          ? "bg-muted cursor-default text-foreground/50"
          : "",
      )}
      onClick={onClick}
    >
      <h1>{props.option.title}</h1>
      <p className="text-foreground/80 text-sm">{props.option.description}</p>
    </div>
  );
}
