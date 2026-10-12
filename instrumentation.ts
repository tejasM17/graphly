export async function register() {
  if (process.env.NEXT_PHASE === "phase-production-build") return;
  const { env } = await import("./lib/env");
  env();
}
