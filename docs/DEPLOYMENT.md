# Life Worth Living Deployment Guide

Production domain used in site files: `https://www.lifeworthlivingafh.com`

If the final domain changes, replace every instance of `https://www.lifeworthlivingafh.com` in HTML metadata, `sitemap.xml`, `robots.txt`, and JSON-LD schema before deploying.

## GitHub

1. Create a GitHub repository for the site.
2. Commit the full project folder, including:
   - `index.html`
   - page folders such as `about/`, `services/`, `gallery/`, `contact/`, `schedule-tour/`
   - `assets/`
   - `public/assets/`
   - `favicon.png`
   - `apple-touch-icon.png`
   - `sitemap.xml`
   - `robots.txt`
   - `vercel.json`
3. Push the repository to GitHub.

## Vercel

1. In Vercel, choose **Add New Project**.
2. Import the GitHub repository.
3. Use these settings:
   - Framework Preset: **Other**
   - Root Directory: project root
   - Build Command: leave empty
   - Output Directory: leave empty
   - Install Command: leave empty
4. Add both domains in Vercel:
   - `lifeworthlivingafh.com`
   - `www.lifeworthlivingafh.com`
5. Set `www.lifeworthlivingafh.com` as the primary production domain.
6. Deploy and confirm Vercel issues SSL certificates for both domains.

## Namecheap DNS

In Namecheap, open the domain DNS settings and use **Custom DNS** or **Advanced DNS** records that point to Vercel.

Required records:

| Type | Host | Value | TTL |
| --- | --- | --- | --- |
| A | `@` | `76.76.21.21` | Automatic |
| CNAME | `www` | `cname.vercel-dns.com` | Automatic |

Remove conflicting parked-domain, forwarding, or old host records for `@` and `www`.

## Final Deployment Checklist

- Confirm all canonical URLs use `https://www.lifeworthlivingafh.com`.
- Confirm `sitemap.xml` uses the production domain.
- Confirm `robots.txt` points to the production sitemap.
- Confirm JSON-LD `url` and `image` use production URLs.
- Confirm all internal links return `200`.
- Confirm `/favicon.png` and `/apple-touch-icon.png` load.
- Confirm `/assets/logo/logo-horizontal.png` and `/assets/logo/logo-primary.png` load.
- Confirm mobile layout on Home, Services, Contact, and Schedule Tour.
- Submit `https://www.lifeworthlivingafh.com/sitemap.xml` to Google Search Console after launch.
