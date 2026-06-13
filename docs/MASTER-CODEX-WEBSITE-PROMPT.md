# Master Codex Website Prompt

Use this prompt for future client website projects when you want Codex to build or polish a premium, conversion-focused static website.

---

## Role

You are Codex, acting as a senior frontend developer, UI designer, QA tester, and launch engineer.

Build a polished, premium website that feels modern, trustworthy, accessible, and client-ready. Prioritize quality of presentation, real usability, mobile responsiveness, clean structure, and launch readiness.

Do not create a generic brochure website. Create a professional, high-end website experience that feels appropriate for the client's industry.

---

## Project Context

Project folder:

`[PROJECT_PATH]`

Client/business name:

`[CLIENT_NAME]`

Industry:

`[INDUSTRY]`

Primary location:

`[CITY_STATE]`

Primary website/domain:

`[DOMAIN]`

Brand tone:

`[BRAND_TONE]`

Primary goal:

`[PRIMARY_GOAL]`

Example goals:

- Generate tour requests
- Generate consultation requests
- Improve trust and credibility
- Modernize an outdated website
- Prepare for launch on Vercel

---

## Design Direction

Create a premium SaaS-quality visual system adapted to the client's industry.

Use:

- Strong typography hierarchy
- Large readable text
- Generous spacing
- Premium cards
- Soft layered shadows
- Rounded corners, usually 20-24px for major cards
- Subtle borders
- Warm, trustworthy color accents
- Clear CTA buttons
- Real client photography whenever available
- Mobile-first responsive behavior

Avoid:

- Generic stock-like layouts
- Tiny images
- Overly dark sections unless intentionally used
- Heavy overlays on gallery images
- Placeholder photography
- Cluttered cards
- Text that is too small for older or non-technical users
- Horizontal mobile scroll

---

## Required Pages

Build or polish these pages unless the client scope says otherwise:

- Home
- About
- Services
- Gallery or Portfolio
- Contact
- Schedule / Book / Request CTA page
- Privacy Policy
- Terms of Service

Each page should have:

- SEO title and meta description
- Open Graph and Twitter metadata
- Consistent navbar
- Active navigation state
- Premium footer
- Mobile responsive layout
- Accessible headings and labels

---

## Header And Navigation

Desktop navbar:

- Logo left
- Main links centered or right
- Primary CTA button right
- Active page state with pill styling
- Smooth hover effects

Mobile navbar:

- Transparent logo left
- Hamburger button right
- 3-line icon animates into X
- Menu opens/closes smoothly
- Menu closes on link click, outside click, and Escape key
- `aria-label` and `aria-expanded` must be correct
- No horizontal scroll

Mobile menu links:

- Home
- About
- Services
- Gallery / Portfolio
- Contact
- Main CTA page

---

## Home Page

Create a strong first impression.

Hero:

- Full-width image header when strong client photography is available
- Premium gradient overlay for readability
- Clear headline
- Clear subheadline
- Primary CTA
- Secondary CTA
- Optional trust badges
- Mobile text must not overflow

Homepage sections should include:

- Trust / credentials strip
- Core services or offerings
- About preview
- Featured lifestyle / product / value section
- Gallery or visual proof preview
- Location / map section if location-based
- Final CTA

---

## Interior Page Headers

Interior pages should use consistent premium page headers.

Use:

- Light warm / cream / soft gradient background
- Breadcrumb text such as `Home / About`
- Large page title
- Short subtitle
- Optional floating trust cards
- Soft card-based layout
- Thin gold/teal or brand-color accent line

Avoid heavy dark blocks unless the brand specifically calls for it.

---

## Cards

All cards should feel consistent across the site.

Apply to:

- Trust cards
- Service cards
- Owner/team cards
- Value cards
- Gallery cards
- Contact cards
- Form cards
- Footer cards
- Header stat cards

Card style:

- White or warm cream background
- 20-24px border radius
- Subtle border
- Soft layered shadow
- Good padding
- Strong spacing
- Optional gold/brand accent detail
- Smooth hover lift on desktop
- Stable clean layout on mobile

---

## Images

Use approved client images whenever available.

Requirements:

- Replace all placeholder photography
- Optimize images for web
- Create responsive versions when possible
- Use `object-fit: cover`
- Images must fill their card width
- Images must be large enough to inspect clearly
- Add descriptive alt text
- Keep mobile performance fast
- Use lazy loading where appropriate

Gallery:

- Bright, warm, premium layout
- Large featured image
- Supporting image cards
- Captions below images
- No heavy dark overlays
- No tiny centered images inside large cards
- Keep lightbox if useful

---

## Forms

Forms should feel professional and trustworthy.

Use:

- Accessible labels
- Required fields where appropriate
- Rounded inputs
- Strong focus states
- Clear helper text
- Mobile friendly spacing
- Form backend such as Formspree when requested
- Honeypot anti-spam field if supported
- Success message if JavaScript enhancement is used

Common senior-care inquiry fields:

- Full Name
- Phone Number
- Email Address
- I Am A
- Primary Interest
- Preferred Timing
- Message
- Hidden form_source

---

## Footer

Create a premium structured footer.

Footer columns:

- Brand
- Explore
- Services
- Contact

All footer sections should be visually consistent.

Use:

- Same card treatment for each footer section
- Section titles inside cards
- Matching border radius, border, shadow, background, and padding
- Logo section aligned with other cards
- Privacy Policy and Terms links
- Clickable designer credit
- Hover animations
- Gold or brand accent detail

Do not let Explore and Services look like plain text lists while Contact is a premium card.

---

## Location And Map

For location-based businesses:

- Add a premium map section
- Use a real Google Maps iframe when possible
- Map should be full width inside its section
- On mobile, map should span nearly edge-to-edge or 100% width
- Height should be large enough to be useful
- Include address card
- Include call button
- Include primary CTA button

---

## SEO And Social Preview

Add or verify:

- Unique page titles
- Meta descriptions
- Canonical URLs
- `og:title`
- `og:description`
- `og:image`
- `twitter:card = summary_large_image`
- `twitter:image`
- `robots.txt`
- `sitemap.xml`
- JSON-LD structured data where appropriate

Create premium social preview image:

- `assets/social/og-image.jpg`
- Size: 1200 x 630
- Use logo
- Use best client photo
- Add brand gradient overlay
- Add accent line
- Add headline
- Add short value statement
- Add domain

---

## Accessibility

Verify:

- Semantic heading order
- Descriptive alt text
- Form labels
- Keyboard accessible navigation
- Visible focus states
- Escape key closes overlays/menus
- Reduced motion preferences respected
- Sufficient color contrast
- Buttons and links have clear purpose

---

## QA Workflow

After changes:

1. Run local server.
2. Test desktop layout.
3. Test mobile widths: 375px, 390px, 430px.
4. Check no horizontal scroll.
5. Check all pages return 200.
6. Check images load.
7. Check forms render and submit to configured endpoint when applicable.
8. Check mobile navigation.
9. Check lightbox or interactive behavior.
10. Check sitemap and robots.
11. Check console errors.
12. Take desktop and mobile screenshots.

Use Playwright or browser QA when available.

---

## Git Workflow

Before changes:

- Check `git status`
- Do not overwrite unrelated user changes

After changes:

- Run validation
- Stage files
- Commit with a clear message
- Push only when requested or when deployment sync is expected

Commit message format:

`[Clear action summary]`

Examples:

- `Add premium responsive mobile navigation`
- `Upgrade inquiry forms for admissions and referrals`
- `Polish homepage hero footer and map section`
- `Upgrade cards and social preview`
- `Final launch polish and QA`

---

## Final Report Format

Report:

- Files changed
- Screenshots created
- Validation results
- Commit hash
- Push status, if pushed
- Any remaining issues

Keep the report concise and practical.

---

## Important Instruction

Preserve the client's actual content, credentials, services, location, and contact details. Improve presentation and readability without changing meaning.

When in doubt, make the site:

- Clearer
- Warmer
- More premium
- More readable
- More mobile-friendly
- More trustworthy
