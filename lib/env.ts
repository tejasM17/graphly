const requiredNames = [
  "NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY",
  "CLERK_SECRET_KEY",
  "NEXT_PUBLIC_SUPABASE_URL",
  "NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY",
] as const;

function read(name: (typeof requiredNames)[number]): string {
  const value = process.env[name]?.trim();
  if (!value) {
    throw new Error(
      `Missing environment: ${requiredNames.filter((key) => !process.env[key]?.trim()).join(", ")}. Set them in .env.local before starting the app.`,
    );
  }
  return value;
}

/** Throws on first import if sign-in or database configuration is absent. */
export function env() {
  return {
    clerkPublishableKey: read("NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY"),
    clerkSecretKey: read("CLERK_SECRET_KEY"),
    supabaseUrl: read("NEXT_PUBLIC_SUPABASE_URL"),
    supabasePublishableKey: read("NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY"),
  };
}
