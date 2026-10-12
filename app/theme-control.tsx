"use client";

import { useRouter } from "next/navigation";

import { setTheme } from "@/app/theme-action";
import { themes, type Theme } from "@/lib/theme";

export function ThemeControl({ theme }: { theme: Theme }) {
  const router = useRouter();

  return (
    <div className="flex border border-[var(--line)]">
      {themes.map((option) => (
        <button
          key={option}
          type="button"
          aria-pressed={theme === option}
          onClick={async () => {
            await setTheme(option);
            router.refresh();
          }}
          className={
            theme === option
              ? "bg-[var(--accent)] px-2 py-1 text-[11px] text-white"
              : "px-2 py-1 text-[11px] text-[var(--ink-muted)]"
          }
        >
          {option}
        </button>
      ))}
    </div>
  );
}
