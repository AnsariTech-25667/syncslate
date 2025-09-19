import React from "react";
import { SignedIn, SignedOut, SignInButton } from "@clerk/nextjs";
import Image from "next/image";
import Link from "next/link";
import { checkUser } from "@/lib/checkUser";
import UserMenu from "./user-menu";
import { Button } from "./ui/button";
import { PenBox } from "lucide-react";

async function Header() {
  // Server-side user bootstrap (safe in a Server Component)
  await checkUser();

  return (
    <nav className="mx-auto py-2 px-4 flex justify-between items-center shadow-md border-b-2">
      <Link href="/" className="flex items-center" aria-label="SyncSlate Home">
        <Image
          src="/logo.png"
          alt="SyncSlate Logo"
          width={150}
          height={60}
          className="h-16 w-auto"
          priority
        />
      </Link>

      <div className="flex items-center gap-4">
        <Link href="/events?create=true">
          <Button variant="default" className="flex items-center gap-2">
            <PenBox size={18} />
            <span className="hidden sm:inline">Create Event</span>
          </Button>
        </Link>

        <SignedOut>
          <SignInButton forceRedirectUrl="/dashboard">
            <Button variant="outline">Login</Button>
          </SignInButton>
        </SignedOut>

        <SignedIn>
          <UserMenu />
        </SignedIn>
      </div>
    </nav>
  );
}

export default Header;
