import { auth } from "@clerk/nextjs/server";

/** Organization claims from the session token. No extra call to Clerk. */
export async function CurrentOrganization() {
  const { orgId, orgSlug, orgRole } = await auth();

  if (!orgId) {
    return (
      <p className="font-mono text-[12px] text-[var(--ink-muted)]">
        No organization on this session.
      </p>
    );
  }

  return (
    <p className="font-mono text-[12px] text-[var(--ink)]">
      {orgSlug ?? orgId}
      {orgRole ? <span className="text-[var(--ink-muted)]"> {orgRole}</span> : null}
    </p>
  );
}
