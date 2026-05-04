import { motion, AnimatePresence } from "framer-motion";
import { useState, useEffect, useRef, useCallback } from "react";
import { useKeyListener } from "~/hooks/useKeyListener";
import { useNuiEvent } from "~/hooks/useNuiEvent";
import {
   PedInteractionProps,
   PedInteractionButton,
} from "~/types/pedInteraction";
import { debugEvent } from "~/utils/debugEvent";
import { fetchNui } from "~/utils/fetchNui";
import { cn } from "~/utils/tw";

debugEvent<PedInteractionProps>(
   {
      action: "openPedInteraction",
      data: {
         name: "Dealer",
         messages: [
            "Hey, you looking for something?",
            "I got the good stuff today.",
            "What do you want to buy?",
         ],
         options: [
            { id: "weed", label: "Weed", description: "5x" },
            { id: "cocaine", label: "Cocaine", description: "3x" },
            {
               id: "meth",
               label: "Meth",
               icon: "https://via.placeholder.com/36",
               description: "10x",
            },
         ],
         buttons: [
            { id: "accept", label: "Accept", style: "primary" },
            { id: "decline", label: "Decline", style: "danger" },
         ],
      },
   },
   500,
);

const TYPING_DURATION = 1200;
const MESSAGE_PAUSE = 400;

const buttonStyles: Record<string, string> = {
   primary:
      "bg-primary/20 border-primary/40 text-primary hover:bg-primary/30",
   secondary:
      "bg-white/[0.06] border-white/10 text-white/70 hover:bg-white/10",
   danger:
      "bg-red-500/15 border-red-500/30 text-red-400 hover:bg-red-500/25",
};

export default function PedInteraction() {
   const [visible, setVisible] = useState(false);
   const [data, setData] = useState<PedInteractionProps | null>(null);
   const [revealedMessages, setRevealedMessages] = useState<number>(0);
   const [isTyping, setIsTyping] = useState(true);
   const [showActions, setShowActions] = useState(false);

   const timeoutsRef = useRef<ReturnType<typeof setTimeout>[]>([]);

   const clearTimeouts = useCallback(() => {
      timeoutsRef.current.forEach(clearTimeout);
      timeoutsRef.current = [];
   }, []);

   function reset() {
      clearTimeouts();
      setRevealedMessages(0);
      setIsTyping(true);
      setShowActions(false);
   }

   function close() {
      setVisible(false);
      reset();
      fetchNui("closePedInteraction");
   }

   function selectOption(id: string) {
      setVisible(false);
      reset();
      fetchNui("selectPedInteractionOption", { id });
   }

   function selectButton(id: string) {
      setVisible(false);
      reset();
      fetchNui("selectPedInteractionOption", { id });
   }

   useKeyListener("Escape", close);

   useNuiEvent("openPedInteraction", (incoming: PedInteractionProps) => {
      reset();
      setData(incoming);
      setVisible(true);
   });

   useNuiEvent("closePedInteraction", () => {
      setVisible(false);
      reset();
   });

   useEffect(() => {
      if (!visible || !data) return;

      const messageCount = data.messages.length;
      let elapsed = 0;
      const newTimeouts: ReturnType<typeof setTimeout>[] = [];

      for (let i = 0; i < messageCount; i++) {
         const typingStart = elapsed;
         newTimeouts.push(
            setTimeout(() => {
               setIsTyping(true);
            }, typingStart),
         );

         elapsed += TYPING_DURATION;
         const revealTime = elapsed;
         newTimeouts.push(
            setTimeout(() => {
               setIsTyping(false);
               setRevealedMessages(i + 1);
            }, revealTime),
         );

         if (i < messageCount - 1) {
            elapsed += MESSAGE_PAUSE;
         }
      }

      elapsed += MESSAGE_PAUSE;
      newTimeouts.push(
         setTimeout(() => {
            setShowActions(true);
         }, elapsed),
      );

      timeoutsRef.current = newTimeouts;
      return clearTimeouts;
   }, [visible, data, clearTimeouts]);

   if (!data) return null;

   const hasOptions = data.options && data.options.length > 0;
   const hasButtons = data.buttons && data.buttons.length > 0;

   return (
      <AnimatePresence>
         {visible && (
            <motion.div
               className="fixed bottom-10 left-1/2 z-[9999]"
               initial={{ opacity: 0, y: 20, x: "-50%" }}
               animate={{ opacity: 1, y: 0, x: "-50%" }}
               exit={{ opacity: 0, y: 20, x: "-50%" }}
               transition={{ duration: 0.25, ease: "easeOut" }}
            >
               <div className="w-[380px] rounded-2xl border border-primary/30 bg-[#030712] p-5 shadow-[0_20px_60px_rgba(0,0,0,0.6),0_0_40px_rgba(7,89,133,0.08)]">
                  <div className={cn("flex gap-3", (hasOptions || hasButtons) && "mb-4")}>
                     <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full border border-primary/30 bg-primary/10">
                        <svg
                           viewBox="0 0 24 24"
                           fill="none"
                           stroke="currentColor"
                           strokeWidth="1.5"
                           className="h-[18px] w-[18px] text-primary/80"
                        >
                           <path d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                        </svg>
                     </div>

                     <div className="flex min-w-0 flex-col gap-1.5">
                        <span className="text-[11px] font-semibold uppercase tracking-wider text-primary/50">
                           {data.name}
                        </span>

                        {data.messages.slice(0, revealedMessages).map((msg, i) => (
                           <motion.div
                              key={`msg-${i}`}
                              className="w-fit rounded-[2px_12px_12px_12px] border border-white/5 bg-white/[0.06] px-3.5 py-2.5 text-sm text-white/90"
                              initial={{ opacity: 0, y: 6, scale: 0.95 }}
                              animate={{ opacity: 1, y: 0, scale: 1 }}
                              transition={{ duration: 0.3 }}
                           >
                              {msg}
                           </motion.div>
                        ))}

                        <AnimatePresence>
                           {isTyping && (
                              <motion.div
                                 key="typing"
                                 className="w-fit rounded-[2px_12px_12px_12px] border border-white/5 bg-white/[0.06] px-[18px] py-3"
                                 initial={{ opacity: 0, y: 6, scale: 0.95 }}
                                 animate={{ opacity: 1, y: 0, scale: 1 }}
                                 exit={{ opacity: 0, scale: 0.95 }}
                                 transition={{ duration: 0.2 }}
                              >
                                 <div className="flex items-center gap-1">
                                    {[0, 1, 2].map((i) => (
                                       <span
                                          key={i}
                                          className="h-1.5 w-1.5 rounded-full bg-primary/50 animate-bounce"
                                          style={{
                                             animationDelay: `${i * 0.15}s`,
                                             animationDuration: "1.2s",
                                          }}
                                       />
                                    ))}
                                 </div>
                              </motion.div>
                           )}
                        </AnimatePresence>
                     </div>
                  </div>

                  <AnimatePresence>
                     {showActions && hasOptions && (
                        <motion.div
                           className="grid grid-cols-3 gap-2"
                           initial={{ opacity: 0, y: 10 }}
                           animate={{ opacity: 1, y: 0 }}
                           transition={{ duration: 0.35 }}
                        >
                           {data.options!.map((option, index) => (
                              <motion.div
                                 key={index}
                                 className={cn("flex cursor-pointer flex-col items-center gap-2 rounded-xl border border-white/[0.06] bg-white/[0.03] p-3.5 transition-all hover:-translate-y-0.5 hover:border-primary/30 hover:bg-primary/[0.15] hover:shadow-[0_4px_20px_rgba(7,89,133,0.15)] active:scale-[0.97]", !option.icon && "justify-center")}
                                 initial={{ opacity: 0, y: 8, scale: 0.93 }}
                                 animate={{ opacity: 1, y: 0, scale: 1 }}
                                 transition={{ delay: index * 0.07, duration: 0.3 }}
                                 onClick={() => selectOption(option.id)}
                              >
                                 {option.icon && (
                                    <img
                                       src={option.icon}
                                       alt={option.label}
                                       draggable={false}
                                       className="h-9 w-9 object-contain drop-shadow-[0_2px_6px_rgba(0,0,0,0.3)]"
                                    />
                                 )}
                                 <div className="flex flex-col items-center gap-0.5">
                                    <span className="text-xs font-medium text-white/85">
                                       {option.label}
                                    </span>
                                    {option.description && (
                                       <span className="text-[11px] text-white/35">
                                          {option.description}
                                       </span>
                                    )}
                                 </div>
                              </motion.div>
                           ))}
                        </motion.div>
                     )}
                  </AnimatePresence>

                  <AnimatePresence>
                     {showActions && hasButtons && (
                        <motion.div
                           className={cn("flex gap-2", hasOptions && "mt-2")}
                           initial={{ opacity: 0, y: 10 }}
                           animate={{ opacity: 1, y: 0 }}
                           transition={{ duration: 0.35, delay: hasOptions ? 0.1 : 0 }}
                        >
                           {data.buttons!.map((button: PedInteractionButton, index: number) => (
                              <motion.button
                                 key={index}
                                 className={cn(
                                    "flex-1 rounded-lg border px-4 py-2.5 text-sm font-medium transition-all active:scale-[0.97]",
                                    buttonStyles[button.style || "secondary"],
                                 )}
                                 initial={{ opacity: 0, y: 6 }}
                                 animate={{ opacity: 1, y: 0 }}
                                 transition={{ delay: index * 0.07, duration: 0.3 }}
                                 onClick={() => selectButton(button.id)}
                              >
                                 {button.label}
                              </motion.button>
                           ))}
                        </motion.div>
                     )}
                  </AnimatePresence>

                  <AnimatePresence>
                     {showActions && (
                        <motion.p
                           className="mt-3.5 text-center text-[11px] text-white/20"
                           initial={{ opacity: 0 }}
                           animate={{ opacity: 1 }}
                           transition={{ duration: 0.5 }}
                        >
                           Press{" "}
                           <kbd className="rounded border border-white/10 bg-white/[0.08] px-1.5 py-px font-sans text-[10px] text-white/40">
                              ESC
                           </kbd>{" "}
                           to close
                        </motion.p>
                     )}
                  </AnimatePresence>
               </div>
            </motion.div>
         )}
      </AnimatePresence>
   );
}
