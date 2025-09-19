export default function About() {
  return (
    <main className="mx-auto max-w-3xl px-6 py-16">
      <h1 className="text-3xl font-semibold">About SyncSlate</h1>
      <p className="mt-4 text-slate-700">
        SyncSlate is maintained by <strong>Maaz Ansari</strong> (<a className="text-brand-600" href="mailto:maazansari25667@gmail.com">maazansari25667@gmail.com</a>).
      </p>
      <p className="mt-4 text-slate-700">
        This repository includes upstream work acknowledged in <code>README.upstream.md</code> and covered by the upstream LICENSE.
      </p>
    </main>
  );
}
