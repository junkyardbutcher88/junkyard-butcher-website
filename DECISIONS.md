# Decisions

Why things are the way they are. Add to the top as new calls get made.

---

## Video

**Cloudflare R2, not Stream / Bunny / the repo.** Chosen 14 Sep 2026.
Free tier is 10 GB-month storage, 1M writes, 10M reads, and egress is always $0 —
about $0/month at our volume. Cloudflare Stream would be a $5/month floor; Bunny is
cheap but it's their player in their iframe. Keeping media out of the repo also keeps
git history clean and dodges the 1 GB GitHub Pages site cap.

**Custom domain, never `r2.dev`.** Cloudflare rate-limits `r2.dev`, documents it as
development-only, and it bypasses CDN caching. Everything serves from
`media.junkyardbutcher.com`.

**Versioned paths: `/reels/<slug>/<version>/`.** Segments are uploaded with a one-year
immutable cache header, so a re-cut publishes to a new version folder instead of
fighting a stale CDN. Manifests get a 300s TTL.

**CORS is mandatory.** `hls.js` fetches manifests and segments with `fetch()`. Without
`Access-Control-Allow-Origin: https://junkyardbutcher.com` on the bucket, every Tier B
video fails with a black frame and no obvious error. Policy lives in `tools/r2-cors.json`.

**Two tiers, not one.** Clips ≤20s (tile loops, ambient motion) stay in the repo as
plain MP4 — adaptive streaming for a six-second loop costs a manifest round-trip and
starts slower. Full reels 20s–3min go to R2 as HLS.

**Ladder leads with native resolution, capped at 1080.** An 810-tall master serves 810,
not a downscaled 720. Lower rungs are added only if meaningfully below the top (85%
threshold), so we never encode two near-identical renditions.

**Letterbox detection samples the timeline.** Never `cropdetect` with `reset=0` over a
long span — it reports the *union* across frames, so one bright transition makes a
genuinely matted reel look full-frame. This bit us on the CVALT master (1440x810 inside
a 1440x1080 container). The encoder now samples seven points with `reset=1` and takes
the most common result. `NOCROP=1` skips it for deliberately matted pieces.

---

## Player

**Hand-built `<jb-video>`, not Video.js or Plyr.** Both ship their own DOM and stylesheet
that take longer to fight than writing from scratch, and a themed Video.js still looks
like a themed Video.js. ~130 lines of vanilla JS plus hls.js (pinned 1.6.15, ~40 KB gz,
loaded only on non-Safari since Safari plays HLS natively).

**Degrades, never breaks.** If hls.js fails to load or throws a fatal error, the player
drops to the progressive `fallback.mp4` from the same folder. A viewer should never see
a black rectangle.

**The JB mark is the play button.** Clicking it runs the rust slash down the diagonal and
the poster splits into two halves along that line. The mark does the cutting rather than
sitting on the frame — this is the detail that makes the player ours.

**Mono until cut.** Frames sit desaturated; colour blooms in behind the falling halves
over ~1s. Also means an unplayed tile doesn't compete with the page, so a column of
reels has hierarchy instead of noise.

**Mono until engaged — site-wide, not just the player.** Extended 15 Sep 2026. Every
still and every reel poster rests desaturated; colour appears only in the lightbox and
in a playing reel. Clicking a photo enlarges it in full colour (`object-fit: contain`,
so the whole frame shows rather than a crop). Rationale: with one greyed video and
everything else in colour it read as a bug on the CVALT card. Applied to everything it
becomes a rule — colour is the reward for opening something, and a wall of tiles reads
as one system instead of a colour grid.

Stills are wired as lightbox triggers **in JS, not in markup** — any `.collage-tile`,
`.work-frame.has-image` or `.founder-frame` with a *direct* child `<img>` and no existing
`data-lightbox-*` gets `data-lightbox-image` on load, with the caption taken from its alt
text. Grid wrappers are skipped automatically because their images are nested, not direct
children. New tiles are covered without being hand-tagged.

**Stills colour on hover; reels don't.** Revised 15 Sep 2026, superseding the first pass
which held everything mono until clicked. The split follows what the thing *is*: a photo
is something you open, so a cursor pass is enough to earn colour and it signals the tile
is clickable. A reel is something you commit to — hovering a video tells you nothing, so
colour is held back until it actually plays. Implemented as `.is-still:hover img` inside
`@media (hover:hover)`, with `:focus-visible` parity for keyboard. Video tiles carry no
hover rule at all.

The earlier worry — that an all-grey page hides the colour work from anyone who only
scrolls — is what this resolves on desktop. On touch there's no hover, so stills stay mono
until tapped open; that's acceptable because a tap is cheap and the lightbox pays out in
full colour. The `.is-still` class is applied by the same JS that wires the lightbox, so
the hover behaviour can never drift out of sync with what's clickable.

**Class prefix is `jb-` but the play button is `.jb-cut`.** `.jb-mark` was already taken
by the site's own nav/footer monogram — using it in the player absolutely-positioned
those monograms into the middle of the page. Check for collisions before adding classes.

---

## Site

**Film grain, not halftone or xerox.** Chosen 14 Sep 2026 after comparing all three in
context. Grain reads as texture at any size and never as dirt; halftone fights small
mono type; xerox reads as a rendering bug to anyone who doesn't know it's deliberate.
One generated SVG noise layer (`#grit`), fixed, overlay blend, 40%.

**Klaviyo for The Block.** Free to 250 contacts; $20/mo email or $35/mo email+SMS after.
Using the tool we'd put a client on makes the site a live demo of the service. Public
API key only — it ships in client-side source by design. Never the private key.

**Cannabis SMS is a carrier problem, not a Klaviyo problem.** US carriers prohibit
cannabis content on 10DLC and short codes under the SHAFT rules, so every mainstream US
provider inherits it. Our own list is a marketing-services list and unaffected. This is
worth saying on the site rather than quietly omitting — it's the compliance knowledge a
generalist pitching a dispensary doesn't have.

**First person in the manifesto only.** The rest of the site keeps "we". One operator is
the product, but full first person everywhere closes the door on ever reading as a team.

**Byline sits above the manifesto, not by the work section.** The problem was that the
name didn't exist above the fold at all; putting it four sections down doesn't fix that.
Order reads: here are the brands → here's who did it → here's how he works.

---

**One brand page, not a system of them.** Decided 15 Sep 2026. The idea started as
"preview on the homepage, a media page per brand" — right instinct, wrong scope. The
actual driver is that CVALT isn't a case study, it's a *scope of work*: video, app store
listing, packaging, sticker runs, email & SMS, brand system, event coverage. Six
workstreams don't fit a tile no matter how many columns the collage gets. Every other
client is a single-discipline engagement — Premium Blossom is a shoot, Farm Fiend is a
shoot, Kannabis is a content cadence — and those fit a tile fine.

So: build `work/cvalt.html` only. A brand earns its own page later by accumulating
roughly one real reel, three-plus stills, and one outcome line. Below that bar a page
makes the work look *smaller* than the tile did — five thin pages read worse than five
dense tiles. Kannabis is the likeliest second, on volume (12+ reels plus the deal
designs), and it would be a content-system page rather than a scope page.

**Brand pages open with the stat line, then the reel.** Outcome above the fold
($4.6M attributed, 66%→86% deliverability), reel underneath. Note this only works for a
brand that *has* numbers — for one that doesn't, the layout opens on an empty promise.
Another reason CVALT goes first.

**Homepage previews must still move.** Whatever links out to a brand page, the preview
tile keeps playing the silent `loop.mp4` the encoder already generates (muted, autoplay
on scroll into view, mono until interacted with). Inline motion on the homepage is a
strength we already have — don't trade it for a click.

---

## Tooling gotchas

**Writing the same file path to the device twice sends stale bytes.** Hit 15 Sep 2026.
`device_commit_files` reported success, updated the file's mtime, and wrote the *previous*
contents of that path — `tools/p.sh` shipped a commit carrying the last commit's message.
Writing to a *new* filename landed correctly. So: when a helper script changes, give it a
new name (`fix1.sh`, `fix2.sh`) rather than overwriting, and check the byte count in
`device_list_dir` against the local file before trusting a rewrite.

---

## Gallery

**One or two previews, the rest in the album.** Decided 15 Sep 2026. CVALT had
grown to three stacked frames — the reel, a four-tile collage, and a two-up email
strip — 2,381px of card for one client. The fix isn't fewer images, it's fewer
images *on the grid*: each card now shows its strongest one or two frames and every
other frame in the set stays in the DOM as a lightbox trigger with `display:none`,
picked up automatically by the album's existing per-card grouping. A "View all N"
badge says what's behind the click. CVALT went 2,381px to 1,504px while its set grew
from six items to eight; the whole work grid dropped 18%.

**The tile carries the aspect ratio, not the frame.** Tiles are shaped to match the
source photographs: `g-wide` (3:2) for landscape sets, `g-tall` (3:4) for portrait,
`g-sq` (1:1) when a set mixes both. Premium Blossom's three frames are all 3:2 off
the film scan and were being cropped into portrait slots — now they render at 1.50
against a 1.51 source, which is no crop at all. Putting the ratio on the tile rather
than the frame is what lets a card go single-column on a phone without the strip
collapsing into a letterbox slit.

**Full-bleed featured cards get matted, not cropped.** Two portrait tiles across a
1,190px featured card are 800px tall on their own. `.inset` caps the grid at 640px
and centres it, so the images keep their shape and the card keeps its height. Same
treatment for `.reel-tall`: a 9:16 phone reel sitting in a 21:9 frame was showing
about a tenth of the shot.

---

## Open

- Cannabis-only, or local culture brands including cannabis? There's a finished
  La Michoacán menu ad and a High90s reel in the Drive with no home on the site.
- The Block has a working capture form and no welcome email behind it.
- `A Higher Xperience` carries an Archive tag with no work attached and nothing found in
  the Drive. Drop the tag or find the assets.
