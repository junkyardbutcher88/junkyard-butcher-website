# Junkyard Butcher — Portfolio Site

A two-page portfolio/funnel site, no build step, no framework. Each page
(`index.html`, `philosophy.html`) is a single self-contained file — CSS and
JS inlined, no `node_modules` — so it deploys to GitHub Pages as-is.

## Pages

- **`index.html`** — the pitch. Hero, process teaser, the two frameworks in
  brief, services, work, and the "Get on the Butcher's Block" conversion point.
- **`philosophy.html`** — the full read. Long-form thought-leadership content
  for warm leads doing research and for search/AI engines: the origin of the
  name, the belief system, both frameworks explained in depth, the stance on
  AI and craft, influences, and an FAQ. Linked from the homepage's "Process"
  section, the top nav, and the footer.

## Deploy to GitHub Pages

1. Create a new repo on GitHub (e.g. `junkyard-butcher` or `<yourname>.github.io`
   if you want it at the root of your GitHub account domain).
2. Push this folder's contents to the repo:
   ```bash
   git init
   git add .
   git commit -m "Launch Junkyard Butcher site"
   git branch -M main
   git remote add origin https://github.com/<you>/<repo>.git
   git push -u origin main
   ```
3. In the repo: **Settings → Pages → Build and deployment → Source** = `Deploy from a branch`,
   **Branch** = `main`, folder `/ (root)`. Save.
4. GitHub gives you a URL in a minute or two — `https://<you>.github.io/<repo>/`
   (or `https://<you>.github.io/` if you used the `<yourname>.github.io` repo name).
5. Optional: add a custom domain under **Settings → Pages → Custom domain** once you
   have one pointed at it.

## Important — replace the placeholder domain before going live

Every canonical link, Open Graph tag, JSON-LD `url`, `sitemap.xml` entry, and
the `Sitemap:` line in `robots.txt` currently points at `https://example.com/`.
Once you know your real domain (a GitHub Pages URL or a custom one), do a
find-and-replace for `https://example.com` across `index.html`,
`philosophy.html`, `sitemap.xml`, and `robots.txt`. Search/AI engines treat
this metadata as fact, so it needs to be correct before it's crawled — don't
leave the placeholder live.

## SEO / AIO (AI-optimized) infrastructure

This site is set up to be read by both search engines and AI answer engines
(ChatGPT, Claude, Perplexity, etc.), not just ranked by Google:

- **`robots.txt`** — explicitly allows standard crawlers plus named AI
  crawlers (GPTBot, ClaudeBot, PerplexityBot, CCBot, Google-Extended, and
  others), and points to `sitemap.xml`.
- **`sitemap.xml`** — lists both pages. Add a new `<url>` block here every
  time you add a page.
- **`llms.txt`** — a plain-text/markdown summary of the site for LLMs to
  ingest directly (an emerging convention, see llmstxt.org): what the brand
  is, what it does, and links to the core pages. Update this whenever the
  services, past work, or page list changes.
- **JSON-LD structured data** — both pages carry a `ProfessionalService`
  schema block (name, description, founder, services); `philosophy.html`
  also carries a `FAQPage` schema built from its FAQ section, which is what
  lets Google and AI engines lift individual Q&As directly. Keep the FAQ
  schema in sync with the visible `<details>` content if you edit either.
- **Semantic, static HTML** — all real content (headings, body copy, FAQ
  answers) lives directly in the HTML, not injected by JavaScript. Crawlers
  that don't execute JS still see everything that matters. Only decorative
  chrome (cursor, progress bar, grain) is JS-driven.
- **One `<h1>` per page, real heading hierarchy** — `index.html`'s `<h1>` is
  the hero wordmark; `philosophy.html`'s is "The Philosophy," with `<h2>`s
  for every essay section and FAQ question in a real, crawlable heading
  outline.

### Adding more AIO pages later

To build out another AI-optimized page (a services deep-dive, an individual
case study, etc.), the pattern to repeat is: static HTML content (no
JS-gated text), one clear `<h1>`, a real heading outline, a short FAQ block
with matching `FAQPage` JSON-LD, a `ProfessionalService` or `Article` JSON-LD
block, canonical/OG tags, and an entry added to both `sitemap.xml` and
`llms.txt`.

## Before you send it to a warm lead — placeholders to swap

Real assets pulled from the Google Drive "Temp portfolio" and "Junkyardbutcher
assets" folders are live for five of the seven work-grid tiles, and two of
those now play real, self-hosted video instead of a poster + link-out. This
is a working pass, not a final one — swap in final photo/video exports from
the iPad as they land.

- **CVALT** (done, real assets, now with real video) — a three-tile collage:
  a real brand video (`assets/cvalt_reel.mp4`, poster
  `assets/cvalt_reel_poster.jpg`) that opens in the on-page lightbox, the
  app-store listing screenshot (`assets/cvalt_app.jpg`), and the "Cannabis,
  Delivered" sticker design (`assets/cvalt_sticker.jpg`).
- **Kannabis Delivery** (done, real video) — a real interactive IG reel,
  compressed and self-hosted (`assets/kannabis_reel.mp4`, poster
  `assets/kannabis_reel_poster.jpg`), playable in the lightbox. Replaces the
  old "Reel — coming soon" placeholder.
- **Bosky Genetics** (done, real assets) — a two-image collage: the
  grow-room photo (`assets/bosky_genetics.jpg`) and a studio product shot of
  the jar (`assets/bosky_jar.jpg`). No video yet.
- **Premium Blossom** (done, real asset + working link) — cover frame from
  the real recap reel (`assets/premium_blossom.jpg`); the frame opens the
  lightbox preview with a "Watch on Instagram" CTA through to the actual
  Google Drive video
  (`https://drive.google.com/file/d/13LiJ7PhkfC53tEOpUiCsilCSxtH4GhWZ/view`),
  and the real client testimonial from Instagram is quoted in the copy. Once
  you have the final export sized for the web, swap the Drive link for the
  self-hosted `<video>` pattern already used on CVALT and Kannabis Delivery.
- **Farm Fiend** (done, real asset + working link) — now a full-width
  closing tile with the real cover frame (`assets/farmfiend_cover.jpg`); the
  lightbox preview links out to the real Instagram reel.
- **A Higher Xperience** — pulled off the work grid at Gabe's request (the
  case-study content didn't represent the brand well) but kept in the
  "Prime Cuts" trust strip, since it's still a real client relationship.
- **Herb and Joy** — pulled off the work grid at the client's request (no
  matching asset existed for it anyway) but kept in the "Prime Cuts" trust
  strip, since it's still a real client relationship — just not one with a
  case-study tile yet. Add a card back in whenever there's an asset to show.
- **Video lightbox** — clicking any reel tile now opens an on-page modal
  instead of jumping straight to a new tab. Self-hosted clips
  (`data-lightbox-video`) autoplay inline with native controls; Instagram-
  only reels (`data-lightbox-ig`) show the cover frame with a "Watch on
  Instagram ↗" ghost-link instead. Wire a new tile into it by adding
  `data-lightbox-video`/`data-lightbox-poster` (or `data-lightbox-ig` +
  `data-lightbox-poster`) and `data-lightbox-caption` to a `.work-frame`.
- **Video hosting** — mostly solved for clips Drive will let you download
  outright (under Drive's 10MB API cap): compress with `ffmpeg` (already
  installed) to roughly `-crf 26 -preset veryslow`, scale to ~540px wide,
  and you'll land well under 1MB per clip, easily small enough to self-host
  on GitHub Pages. Anything Drive won't hand over directly (the 70–100MB
  source `.mov` files) still needs a manual export/download pass before it
  can follow the same pipeline — Premium Blossom links out to Drive as a
  stopgap until that happens.
- **Email capture form** — the "Get on the Butcher's Block" form (`#join` on the
  homepage) has `action="#"` and does nothing yet. Point it at your ESP
  (Klaviyo, Flodesk, ConvertKit, etc.) or wire it to a serverless endpoint.
- **Contact email** — `mailto:hello@junkyardbutcher.com` appears in the Join
  section. Swap for your real inbox if that domain isn't live yet.
- **Social links** — Instagram is now live (`instagram.com/junkyardbutcher`)
  in both footers and both nav bars. TikTok is still an `href="#"` placeholder.
- **Testimonials** — mostly left out rather than faked, except the one real
  Premium Blossom quote now woven into that tile's copy. When you have more
  real client quotes, a short section between "The Cuts" and the Founder
  Reel would be the natural spot to add them.
- **`founder` name in the JSON-LD** — currently just "Gabe." Add a surname
  if/when you want the structured data more specific.
- **Philosophy page** — the "Why Junkyard. Why Butcher." section now opens
  with a real founder portrait (`assets/gabe_portrait.jpg`), and "Minimal
  Gear, Maximum Intent" still has the skateboard pull-quote photo
  (`assets/skate_frame.jpg`).

## Design system quick reference

- **Palette**: `--ink` #0c0c0a canvas, `--bone` #ece6d8 primary text,
  `--acid` #c9ff3f accent (CTAs, links, active states — used sparingly),
  `--rust` #ff5b23 secondary accent (eyebrow marks, cut-line dividers),
  `--smoke` muted gray, `--iron` / `--iron-2` card and section surfaces.
- **Type**: Anton (display/headlines), Space Grotesk (body/UI), JetBrains
  Mono (labels, tags, nav, captions).
- **Rules, on purpose**: 0px border-radius everywhere except genuinely
  circular motifs (the play button, the cursor, the rotating stamp) — no
  pills, no soft shadows. No filled CTA buttons anywhere on the site —
  every call-to-action is a typographic ghost link (`.link-cta`) that only
  reveals its underline on hover. Color is spent only where it's load-
  bearing (an active/hover state, the one CTA accent, the rust divider) —
  no decorative gradient glows or unmotivated tinted panels. The work grid
  uses irregular tile spans and aspect ratios on purpose, not a uniform
  card grid.

## The details that make it feel expensive

- A thin acid-green progress bar tracks scroll position at the top of the
  viewport on both pages.
- The homepage hero has a giant cropped "CUT" wordmark bleeding off the
  edge — pure CSS (`-webkit-text-stroke`), no images.
- A custom two-part cursor (dot + trailing ring) replaces the system
  pointer on desktop and enlarges over anything clickable. Skipped
  automatically on touch devices and under reduced-motion settings, with
  the system cursor as a safe fallback if JS doesn't run.
- Vertical "slug" labels sit at the left/right viewport edges on wider
  screens — a nod to print production marks.
- A hand-drawn jagged "cut line" (CSS, not an image) marks major section
  breaks instead of a plain rule.
- `philosophy.html` has a sticky, numbered table of contents and native
  `<details>/<summary>` FAQ accordions that work with JS off.
- Reel tiles open in an on-page lightbox instead of jumping straight to a
  new tab — real clips autoplay inline, Instagram-only reels get a branded
  preview panel with a single deliberate "Watch on Instagram" exit instead
  of an abrupt tab switch.
