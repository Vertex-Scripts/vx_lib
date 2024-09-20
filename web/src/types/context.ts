export type ContextOptions = {
  title?: string;
  description?: string;
  disabled?: boolean;
};

export type ContextMenuProps = {
  title: string;
  canClose?: boolean;
  options?: ContextOptions[];
};
