import { ContextOptions } from "~/types/context";
import { isBrowser } from "~/utils/cef";
import { fetchNui } from "~/utils/fetchNui";

export default function ContextMenuOption(props: {
  option: ContextOptions;
  id: number;
  hideContextMenu: () => void;
}) {
  function onClick() {
    if (!isBrowser()) {
      fetchNui("clickContextMenuOption", props.id);
      return;
    }

    props.hideContextMenu();
  }

  return (
    <div
      className="p-3 bg-background rounded-lg px-5 font-medium cursor-pointer hover:bg-muted transition-colors"
      onClick={onClick}
    >
      <h1>{props.option.title}</h1>
      <p className="text-foreground/80 text-sm">{props.option.description}</p>
    </div>
  );
}
