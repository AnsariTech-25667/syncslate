export default function Footer() {
  return (
    <footer className="mt-16 border-t border-slate-200">
      <div className="mx-auto max-w-6xl px-6 py-8 text-sm text-slate-600 flex flex-col sm:flex-row items-center justify-between gap-2">
        <div>© {new Date().getFullYear()} SyncSlate</div>
        <div>
          Maintained by{" "}
          <a href="mailto:maazansari25667@gmail.com" className="text-brand-600 hover:underline">
            Maaz Ansari
          </a>
        </div>
      </div>
    </footer>
  );
}
