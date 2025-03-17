import { motion } from "framer-motion";
import { useState } from "react";
import { useNuiEvent } from "~/hooks/useNuiEvent";
import { debugEvent } from "~/utils/debugEvent";
import { fetchNui } from "~/utils/fetchNui";

type ProgressCircleProps = {
   duration: number;
   label: string;
};

debugEvent<ProgressCircleProps>(
   {
      action: "progressCircle",
      data: {
         duration: 5000,
         label: "Reparing...",
      },
   });

export default function ProgressCircle() {
   const [visible, setVisible] = useState(false);
   const [value, setValue] = useState(0);
   const [label, setLabel] = useState("");

   useNuiEvent("progressCancel", () => {
      setVisible(false);
      setValue(100);
   });

   useNuiEvent<ProgressCircleProps>("progressCircle", (data) => {
      if (visible) return;

      setVisible(true);
      setValue(0);
      setLabel(data.label);

      const updateProgress = setInterval(() => {
         setValue((prev) => {
            const newValue = prev + 1;
            if (newValue >= 100) {
               fetchNui("progressComplete")
               clearInterval(updateProgress);
               setVisible(false);
               setValue(0);
            }

            return newValue;
         });
      }, data.duration * 0.01);
   });

   return (
      <motion.div
         className="fixed bottom-20 left-1/2 -translate-x-1/2 flex flex-col items-center justify-center gap-2"
         initial={{ opacity: 0 }}
         animate={{ opacity: visible ? 1 : 0 }}
      >
         <div className="relative h-26 w-24">
            <svg className="h-full w-full" viewBox="0 0 100 100">
               <circle
                  className="stroke-primary/20"
                  fill="none"
                  strokeWidth="8"
                  cx="50"
                  cy="50"
                  r="42"
                  transform="rotate(-90 50 50)"
               />
               <motion.circle
                  className="stroke-primary"
                  fill="none"
                  strokeWidth="8"
                  strokeLinecap="round"
                  cx="50"
                  cy="50"
                  r="42"
                  transform="rotate(-90 50 50)"
                  initial={{ pathLength: 0 }}
                  animate={{ pathLength: value / 100 }}
               />
            </svg>
            <div className="absolute inset-0 flex items-center justify-center">
               <span className="text-xl font-semibold text-white">{Math.round(value)}%</span>
            </div>
         </div>
         <span className="text-white/80">{label}</span>
      </motion.div>
   );
}
