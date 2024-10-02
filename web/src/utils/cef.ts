export function getParentResourceName() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const getResourceName = (window as any).GetParentResourceName;
  return getResourceName ? getResourceName() : "nui-frame-app";
}

export function isBrowser() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  return !(window as any).invokeNative;
}
