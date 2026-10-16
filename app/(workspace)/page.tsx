import { createSupabase } from "@/lib/supabase";

export const instant = false;

type Analysis = {
  id: string;
  status: "queued" | "running" | "completed" | "failed";
  created_at: string;
  project: {
    repository_name: string;
    repository_url: string;
  };
};

export default async function WorkspacePage() {
  const supabase = await createSupabase();
  const { data, error } = await supabase
    .from("analyses")
    .select("id, status, created_at, project:projects(repository_name, repository_url)")
    .order("created_at", { ascending: false })
    .limit(50)
    .overrideTypes<Analysis[], { merge: false }>();

  if (error) {
    throw new Error("Unable to load analyses", { cause: error });
  }

  const analyses = data ?? [];

  return (
    <main className="flex flex-1 flex-col gap-3 p-3">
      <div className="flex items-baseline justify-between border-b border-[var(--line)] pb-2">
        <h1 className="text-[13px] font-medium">Analyses</h1>
        <span className="font-mono text-[11px] text-[var(--ink-muted)]">
          {analyses.length} {analyses.length === 1 ? "analysis" : "analyses"}
        </span>
      </div>

      {analyses.length === 0 ? (
        <p className="py-3 text-[12px] text-[var(--ink-muted)]">
          No analyses yet for this organization.
        </p>
      ) : (
        <ul className="divide-y divide-[var(--line)]">
          {analyses.map((analysis) => (
            <li
              key={analysis.id}
              className="flex items-center gap-3 py-2 text-[12px]"
            >
              <a
                href={analysis.project.repository_url}
                className="min-w-0 flex-1 truncate font-mono text-[var(--ink)] underline decoration-[var(--line)] underline-offset-2"
              >
                {analysis.project.repository_name}
              </a>
              <time
                dateTime={analysis.created_at}
                className="shrink-0 font-mono text-[11px] text-[var(--ink-muted)]"
              >
                {new Date(analysis.created_at).toLocaleString()}
              </time>
              <span className="w-20 shrink-0 text-right text-[var(--ink-muted)]">
                {analysis.status}
              </span>
            </li>
          ))}
        </ul>
      )}
    </main>
  );
}
