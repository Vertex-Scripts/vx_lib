export default function setClipboard(value: string) {
  navigator.clipboard.writeText(value);
}
