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

Live at `https://junkyardbutcher88.github.io/junkyard-butcher-website/` and
being pointed at the custom domain below. For reference, this is how it was
stood up:

1. Repo: `github.com/junkyardbutcher88/junkyard-butcher-website` (public).
2. **Settings → Pages → Build and deployment → Source** = `Deploy from a branch`,
   **Branch** = `main`, folder `/ (root)`.
3. Custom domain (below) is set via a `CNAME` file at the repo root, which is
   what tells GitHub Pages to serve the site at that domain instead of (or in
   addition to) the `github.io` URL.

## Custom domain — junkyardbutcher.com

Gabe owns `junkyardbutcher.com`. It's wired up as the primary domain:

- **`CNAME`** file at the repo root contains `junkyardbutcher.com` — this is
  what GitHub Pages reads to know the custom domain. Don't delete it or the
  domain mapping breaks.
- Every canonical link, Open Graph tag, JSON-LD `url`, `sitemap.xml` entry,
  the `Sitemap:` line in `robots.txt`, and the links in `llms.txt` point at
  `https://junkyardbutcher.com/` — search/AI engines treat this metadata as
  fact, so keep it in sync if the domain ever changes again.
- **DNS** (at whichever registrar/DNS host the domain lives at) needs, for the
  apex domain `junkyardbutcher.com`:
  - Four `A` records pointing to GitHub Pages: `185.199.108.153`,
    `185.199.109.153`, `185.199.110.153`, `185.199.111.153`.
  - (Optional, IPv6) Four `AAAA` records: `2606:50c0:8000::153`,
    `2606:50c0:8001::153`, `2606:50c0:8002::153`, `2606:50c0:8003::153`.
  - If `www.junkyardbutcher.com` should also work, a `CNAME` record for `www`
    pointing to `junkyardbutcher88.github.io`.
- Once DNS resolves, **Settings → Pages** on the repo will show the domain as
  verified and let you check **Enforce HTTPS** — do that once it's available;
  it can take a little while (sometimes up to a day) for GitHub's certificate
  to provision after DNS first propagates.

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
  Delivered" sticker design (`assets/cvalt_sticker.jpg`). Copy now leads with
  the real email/SMS numbers — $4.6M in platform-attributed revenue in one
  year on ~$22K spend, delivery rate up from 66% to 86% — called out in a
  `.work-stats` row under the description (see
  `junkyard-butcher-portfolio-case-studies.md` for the source figures).
- **Kannabis Delivery** (done, real video) — a real interactive IG reel,
  compressed and self-hosted (`assets/kannabis_reel.mp4`, poster
  `assets/kannabis_reel_poster.jpg`), playable in the lightbox. Replaces the
  old "Reel — coming soon" placeholder.
- **Bosky Genetics** (done, real assets, copy updated) — a two-image collage:
  the grow-room photo (`assets/bosky_genetics.jpg`) and a studio product shot
  of the jar (`assets/bosky_jar.jpg`). No video yet — if a Transbay/harvest
  highlight reel ever gets exported it belongs on this card (see the TODO
  comment above the card in `index.html`).
- **Premium Blossom** (real asset + working link, copy updated, photo swap
  pending) — cover frame from the real recap reel (`assets/premium_blossom.jpg`);
  the frame opens the lightbox preview with a "Watch on Instagram" CTA through
  to the actual Google Drive video
  (`https://drive.google.com/file/d/13LiJ7PhkfC53tEOpUiCsilCSxtH4GhWZ/view`),
  and the real client testimonial from Instagram is quoted in the copy. Gabe
  picked three specific shots to replace this single-frame tile with a
  3-image collage (hero: the candid toss/celebration shot with the "Harvest
  Market 2026" screen behind it; second: the ribbon-cutting crowd shot;
  third: the candid customer-at-the-counter shot) — see the TODO comment
  above this card in `index.html` and `junkyard-butcher-portfolio-case-studies.md`
  for the full shot list. Once those exports land, rebuild this card as a
  3-tile collage matching CVALT's pattern, and swap the Drive link for a
  self-hosted `<video>` if a final web-sized export of the reel itself shows up too.
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
  circular motifs (the play button, the cursor, the rotating stamp, the
  `.mark-selected` stamp badge) — no pills, no soft shadows. No filled CTA
  buttons anywhere on the site — every call-to-action is a typographic ghost
  link (`.link-cta`) that only reveals its underline on hover. Color is
  spent only where it's load-bearing (an active/hover state, the one CTA
  accent, the rust divider) — no decorative gradient glows or unmotivated
  tinted panels. The work grid uses irregular tile spans and aspect ratios
  on purpose, not a uniform card grid.
- **JB house mark**: brought in from Gabe's brand style guide — a `.jb-mark`
  inline SVG (bold "JB" with a diagonal rust cut) replaces the plain "/"
  prefix in both the nav wordmark and the footer mark, and the favicon is
  now a dark-circle JB badge instead of the placeholder knife emoji. If a
  final custom logotype/monogram asset ever gets exported from the style
  guide, swap it in for this inline-SVG approximation.
- **Butcher's Marks visual language**: the style guide's stamp system
  (`CUT` / `KEEP` / `REJECT` / `SELECTED` / `ARCHIVE`) is echoed sparingly —
  an `.mark-archive` tag flags "A Higher Xperience" and "Herb and Joy" in
  the trust strip as relationships kept off the work grid, and a
  `.mark-selected` stamp badge marks the CVALT card as the flagship case
  study. The hero also now carries the guide's tagline pairing: "Bespoke
  Design + Content Creation — No templates. No fucking filler."

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
