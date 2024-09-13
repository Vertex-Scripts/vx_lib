import { isBrowser } from "~/utils/cef";

export default function DebugBackgroundImage() {
  return (
    <>
      {isBrowser() && (
        <div className="absolute -z-10 w-screen h-screen bg-[url('https://i.redd.it/ru3zrlk8iz051.png')]"></div>
      )}
    </>
  );
}
