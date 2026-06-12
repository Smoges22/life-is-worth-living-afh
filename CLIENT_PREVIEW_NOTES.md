# Life Worth Living Client Preview Notes

Local preview URL: http://127.0.0.1:4173/

Run locally with:

```powershell
node local-server.cjs
```

Or use the helper script:

```powershell
powershell -ExecutionPolicy Bypass -File .\start-local-server.ps1
```

## Pages Included

- Home: `/`
- About: `/about/`
- Services: `/services/`
- Gallery: `/gallery/`
- Contact: `/contact/`
- Schedule Tour: `/schedule-tour/`
- Privacy Policy: `/privacy-policy/`
- Terms: `/terms/`
- Sitemap: `/sitemap.xml`
- Robots: `/robots.txt`

## Preview Screenshots

Screenshots are saved in `client-preview-qa/screenshots/`:

- `desktop-home.png`
- `mobile-home.png`
- `desktop-services.png`
- `mobile-contact.png`
- `mobile-schedule-tour.png`

## Ready For Review

- Branded navbar and footer logos are implemented.
- Primary CTA buttons route to Schedule Tour.
- Contact and Schedule Tour forms use `mailto:lwlafh@outlook.com`.
- Favicon and Apple touch icon are present.
- Sitemap and robots files are available.
- Production SEO metadata uses `https://www.lifeworthlivingafh.com`.
- Mobile layouts were checked for Home, About, Services, Gallery, Contact, and Schedule Tour.
- Internal route and asset checks passed locally.

## Client Approval Needed

- Confirm all business information is final:
  - Phone: `(206) 354-3731` / `(206) 354-3732`
  - Fax: `(206) 260-7448`
  - Email: `lwlafh@outlook.com`
  - Address: `13205 12th Avenue Southwest, Burien, WA 98146`
- Confirm service list and RN-led specialized care language.
- Confirm privacy policy and terms text are acceptable.
- Confirm whether forms should remain `mailto:` or be connected to a hosted form service.

## Domain Confirmation Needed

The site is currently configured for:

`https://www.lifeworthlivingafh.com`

Confirm the final domain before Vercel launch. If the domain changes, update canonical URLs, Open Graph URLs, JSON-LD schema, `sitemap.xml`, `robots.txt`, and the deployment guide.

## Final Photos Needed

Replace placeholder images with approved real photography:

- Home hero image
- Home exterior
- Living room
- Bedrooms
- Dining area
- Outdoor space
- Resident activities or lifestyle image
