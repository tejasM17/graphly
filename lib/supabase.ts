import "server-only";

import { auth } from "@clerk/nextjs/server";
import { createClient } from "@supabase/supabase-js";

import { env } from "./env";

/**
 * Postgres client for server code. The Clerk session token rides on every
 * request; this client does not keep a Supabase session of its own.
 */
export async function createSupabase() {
  const { getToken } = await auth();
  const { supabaseUrl, supabasePublishableKey } = env();

  return createClient(supabaseUrl, supabasePublishableKey, {
    accessToken: async () => getToken(),
    auth: {
      persistSession: false,
      autoRefreshToken: false,
      detectSessionInUrl: false,
    },
  });
}
