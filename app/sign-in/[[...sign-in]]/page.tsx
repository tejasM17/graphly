import { SignIn } from "@clerk/nextjs";

export default function SignInPage() {
  return (
    <main className="flex min-h-full flex-1 items-center justify-center p-6">
      <SignIn
        fallbackRedirectUrl="/"
        signUpUrl="/sign-in"
        appearance={{
          variables: {
            colorPrimary: "#2f5bd1",
            colorBackground: "#f7f8fa",
            colorForeground: "#1a1c1f",
            borderRadius: "0px",
            fontSize: "13px",
          },
        }}
      />
    </main>
  );
}
