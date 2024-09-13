import { useState } from "react";
import { useKeyListener } from "~/hooks/useKeyListener";
import { useNuiEvent } from "~/hooks/useNuiEvent";
import { ContextMenuProps } from "~/types/context";
import { debugEvent } from "~/utils/debugEvent";
import { fetchNui } from "~/utils/fetchNui";

import ContextMenuOption from "./context-menu-option";

debugEvent<ContextMenuProps>(
  {
    action: "openContextMenu",
    data: {
      title: "Garage: Blokkenpark",
      options: [
        {
          title: "Aventador",
          description: "Plate: 11-FRW-8",
        },
        {
          title: "Skyline",
          description: "Plate: 42-GSK-5",
        },
        {
          title: "Dodge",
        },
      ],
    },
  },
  1000,
);

export default function ContextMenu() {
  const [visible, setVisible] = useState(false);
  const [contextMenu, setContextMenu] = useState<ContextMenuProps>({
    title: "",
  });

  function closeContext() {
    setVisible(false);
    fetchNui("closeContextMenu");
  }

  useKeyListener("Escape", closeContext);

  useNuiEvent("openContextMenu", (data: ContextMenuProps) => {
    setContextMenu(data);
    setVisible(true);
  });

  useNuiEvent("hideContextMenu", () => {
    setVisible(false);
  });

  return (
    <>
      {visible && (
        <div className="absolute top-28 right-24 w-[320px] h-[600px] transition-all">
          <header className="bg-background py-2 text-center rounded-lg">
            <h1 className="text-lg font-medium">{contextMenu.title}</h1>
          </header>

          <div className="flex flex-col gap-1 pt-4">
            {contextMenu.options?.map((option, i) => (
              <ContextMenuOption key={i} id={i} option={option} />
            ))}
          </div>
        </div>
      )}
    </>
  );
}
