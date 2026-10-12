"use server";

import { cookies } from "next/headers";

import { parseTheme, THEME_COOKIE, type Theme } from "@/lib/theme";

export async function setTheme(theme: Theme) {
  const value = parseTheme(theme);
  (await cookies()).set(THEME_COOKIE, value, {
    path: "/",
    maxAge: 60 * 60 * 24 * 365,
    sameSite: "lax",
  });
}
