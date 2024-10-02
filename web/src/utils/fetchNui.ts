import { getParentResourceName } from "./cef";

export async function fetchNui<T>(event: string, data?: T) {
  const resourceName = getParentResourceName();
  try {
    await fetch(`https://${resourceName}/${event}`, {
      method: "post",
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: JSON.stringify(data),
    });
  } catch {
    /* empty */
  }
}

export async function fetchNuiReturning<T, D>(event: string, data?: D) {
  const resourceName = getParentResourceName();
  const response = await fetch(`https://${resourceName}/${event}`, {
    method: "post",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify(data),
  });

  const body = await response.json();
  return body as T;
}
