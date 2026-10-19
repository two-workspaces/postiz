# Deploy and Host Postiz on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/postiz-production?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=postiz-production)

[Postiz](https://postiz.com/) is an open-source social media scheduler. You write a post once, then schedule or publish it to X, LinkedIn, Instagram, Facebook, Threads, Bluesky, Mastodon, YouTube, TikTok, Pinterest, Reddit, Discord, Telegram and more than 20 other channels. It has a calendar, an AI writer, team workspaces, comments and approvals, analytics, a public API and an MCP server for AI agents. This template runs Postiz v2.25.1 with its own Temporal server on Postgres, so it needs no Elasticsearch.

## About Hosting Postiz

The stack has four services: Postiz, Temporal, Redis and Postgres.

- **Postiz** is the official `ghcr.io/gitroomhq/postiz-app` image (pinned at v2.25.1). It runs the web app, the API and the Temporal worker that publishes your posts. Uploaded media is stored on a volume at `/uploads` and served from your own domain, so the social networks can fetch it.
- **Temporal** schedules every post and retries failed publishes. It is the production `temporalio/server` image, not the deprecated `auto-setup` image. Schema migrations run on every deploy. It uses Postgres for advanced visibility, so the search attributes Postiz needs (`organizationId`, `postId`) work without Elasticsearch, which would add a JVM using 1 GB or more.
- **Postgres** holds Postiz's data and Temporal's two databases. One Postgres serves both apps.
- **Redis** is a cache only, with no volume.

Two fixes are baked in:

- **The session cookie is host-only.** Postiz sets its login cookie on the parent domain. On a `*.up.railway.app` address that parent domain is `.railway.app`, so the browser would send your session to every app hosted on Railway. This template's nginx rewrites the cookie to your exact host. With a custom domain it does the same.
- **Sign-up is closed after the first account.** `DISABLE_REGISTRATION=true` lets the first person to sign up create the workspace and blocks everyone after that. Invite teammates from Settings. Set it to `false` if you want public sign-up. No email provider is needed, because accounts are activated straight away when none is configured.

### After deploying

1. Open the Postiz domain and **sign up right away**. The first account owns the instance.
2. Connect your channels. Most networks need you to create a developer app and add its keys as variables on the **Postiz** service, for example `X_API_KEY` and `X_API_SECRET`, `LINKEDIN_CLIENT_ID` and `LINKEDIN_CLIENT_SECRET`, or `FACEBOOK_APP_ID` and `FACEBOOK_APP_SECRET`. Use `https://<your-domain>/integrations/social/<provider>` as the redirect URL. The full list is in the [Postiz provider docs](https://docs.postiz.com/providers). Bluesky, Mastodon (any instance), Nostr, Lemmy, Dev.to, Hashnode, Medium and WordPress connect with just a login, key or token.
3. Optional: set `OPENAI_API_KEY` to turn on the AI writer, image generation and agent features. Set `EMAIL_PROVIDER=resend` with `RESEND_API_KEY`, `EMAIL_FROM_ADDRESS` and `EMAIL_FROM_NAME` to send notification emails. Railway blocks SMTP on most plans, but Resend's HTTP API works.

For a custom domain, add it to the Postiz service and set `MAIN_URL`, `FRONTEND_URL` and `NEXT_PUBLIC_BACKEND_URL` (the domain followed by `/api`) to it.

## Common Use Cases

- Scheduling a content calendar across every social network from one place, with no per-seat SaaS fees
- Agencies managing many clients' channels, with separate customers, team roles and post approvals
- Letting AI agents draft and schedule posts through the Postiz API or its MCP server
- Reposting blog posts, newsletters and RSS items to social media automatically

## Dependencies for Postiz Hosting

- Postgres 17 (included, private network only)
- Redis (included, private network only)
- Temporal server (included, private network only)
- Developer app keys for the social networks you want to post to

### Deployment Dependencies

- Postiz: https://github.com/gitroomhq/postiz-app
- Postiz self-hosting docs: https://docs.postiz.com/installation/docker-compose
- Temporal: https://temporal.io/
- Template source: https://github.com/two-workspaces/postiz

### Resources

Measured idle on Railway: about 2 GB of RAM for the whole stack. Postiz uses about 1.6 GB (web app, API and worker), Postgres about 190 MB, Temporal about 190 MB and Redis about 12 MB. The Postiz image is also large (1.7 GB compressed). Plan on the **Hobby plan**: Free and Trial limits are too small.

## Why Deploy Postiz on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Postiz on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
