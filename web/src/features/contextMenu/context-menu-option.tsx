import { ContextOptions } from "~/types/context";
import { fetchNui } from "~/utils/fetchNui";

export default function ContextMenuOption(props: {
  option: ContextOptions;
  id: number;
}) {
  function onClick() {
    fetchNui("clickContextMenuOption", props.id);
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
