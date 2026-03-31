export type PedInteractionOption = {
  id: string;
  label: string;
  icon?: string;
  description?: string;
};

export type PedInteractionButton = {
  id: string;
  label: string;
  style?: "primary" | "secondary" | "danger";
};

export type PedInteractionProps = {
  name: string;
  messages: string[];
  options?: PedInteractionOption[];
  buttons?: PedInteractionButton[];
};
