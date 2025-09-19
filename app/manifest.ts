export default function manifest() {
  return {
    name: "SyncSlate",
    short_name: "SyncSlate",
    description: "Scheduling that respects your time.",
    start_url: "/",
    display: "standalone",
    background_color: "#ffffff",
    theme_color: "#4f46e5",
    icons: [{ src: "/favicon.ico", sizes: "any", type: "image/x-icon" }],
    authors: [{ name: "Maaz Ansari", url: "mailto:maazansari25667@gmail.com" }]
  };
}
