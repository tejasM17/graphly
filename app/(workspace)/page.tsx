import { CurrentOrganization } from "@/app/current-organization";
import { createSupabase } from "@/lib/supabase";

export const instant = false;

export default async function WorkspacePage() {
  await createSupabase();

  return (
    <main className="flex flex-1 flex-col gap-2 p-3">
      <CurrentOrganization />
    </main>
  );
}
