import { OrganizationSwitcher, Show, UserButton } from "@clerk/nextjs";
import { InviteMembersButton } from "@clerk/nextjs";

import { ThemeControl } from "@/app/theme-control";
import { parseTheme, THEME_COOKIE } from "@/lib/theme";
import { cookies } from "next/headers";

export const instant = false;

export default async function WorkspaceLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const theme = parseTheme((await cookies()).get(THEME_COOKIE)?.value);

  return (
    <div className="flex min-h-full flex-col">
      <header className="flex h-9 items-center gap-3 border-b border-[var(--line)] px-3">
        <span className="text-[13px] font-medium">Graphly</span>
        <OrganizationSwitcher
          hidePersonal
          afterSelectOrganizationUrl="/"
          appearance={{
            elements: {
              rootBox: "flex items-center",
              organizationSwitcherTrigger:
                "h-7 rounded-none border border-[var(--line)] px-2 text-[12px]",
            },
          }}
        />
        <Show when="signed-in">
          <InviteMembersButton
            appearance={{
              elements: {
                button:
                  "h-7 rounded-none border border-[var(--line)] bg-transparent px-2 text-[12px] text-[var(--ink)] shadow-none",
              },
            }}
          />
        </Show>
        <div className="ml-auto flex items-center gap-3">
          <ThemeControl theme={theme} />
          <UserButton
            appearance={{ elements: { avatarBox: "h-6 w-6" } }}
          />
        </div>
      </header>
      <div className="flex flex-1 flex-col">{children}</div>
    </div>
  );
}
