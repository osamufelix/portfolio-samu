---
title: Guardião Impacta
description: Security awareness app built as my capstone project and used by real participants in a field study.
order: 1
metric: 475 + 385 tests · p95 of 20 ms with 100 users
tags: [Node.js, React, PostgreSQL, Docker Compose, Azure, GitHub Actions, k6, OWASP ZAP, Semgrep, Trivy, Claude Code]
---

<!-- PENDENTE: replace ENRICO741/nodeLogin links with the copy of the repo in my account -->
<!-- PENDENTE: updated thesis (PDF in site/public/docs/, link under "Links" and study numbers) -->

## Summary

Guardião Impacta ("Impacta Guardian") was a mobile web app (PWA) that taught information security to people who don't work in IT, through short lessons, trivia, points, achievements and a leaderboard. It was my group's capstone project for a Computer Science degree, and it ran in production while the study collected data, until November 2, 2026. The app was then shut down.

| | |
|---|---|
| Automated tests | 475 on the API (100% line coverage) and 385 on the UI (99.8%) |
| Load test | 100 concurrent users for 3 minutes: zero failures, 95% of responses within 20 ms; up to 41 ms in a 1,000-user stress test |
| Security | 7 issues found in code review and fixed; OWASP ZAP with zero failures afterwards |
| Delivery | every push to `main` with a green CI went to production on its own, with no SSH port open |

## Context

Security awareness programs tend to have low engagement, especially among non-technical staff. The study asked whether a gamified app is more engaging than the traditional trainings the participants had already taken.

The capstone was a five-person group project. **My part was building the whole app (UI, API and database), the infrastructure, the CI/CD, and writing the thesis.** I authored 156 of the repository's 159 commits.

## Architecture

<figure class="wide">
  <img src="/img/guardiao/arquitetura.png" alt="Diagram, labeled in Portuguese: participants and admins reach Caddy over HTTPS, on an Azure VM running Docker Compose; Caddy forwards /api to the Node.js API, which uses PostgreSQL and sends emails over SMTP. Developers push to GitHub, and GitHub Actions tests and deploys to the VM." loading="lazy" />
  <figcaption>Production architecture (figure from the thesis, in Portuguese).</figcaption>
</figure>

- Three containers on an Azure VM (Ubuntu, 2 vCPUs, 8 GB), orchestrated with Docker Compose: Caddy, the API and Postgres.
- Caddy served the PWA, issued the HTTPS certificate and proxied `/api` to the API. UI and API shared one origin, so there was no CORS to configure.
- Only ports 80 and 443 were open. The API and database lived only on the internal Compose network, and admin access went through Azure Bastion.
- The database was backed up daily.

## Engineering decisions

**Scoring enforced by the database, not the phone.** Points drove the leaderboard and fed the study data. Computed on the device, they could be tampered with. So the rule lived on the server: `FOR UPDATE` transactions kept two requests for the same round from running in parallel, and partial unique indexes let each question score only once per person, even with repeated taps or concurrent requests. Integration tests covered these races.

**Session checked against the database on every request.** The JWT only identified the user; the middleware loaded the user from the database each time. Deactivating an account or changing its role took effect immediately, and changing the password invalidated older tokens.

**Versioned schema.** The database was defined by numbered SQL migrations, applied in order when the API started. An applied migration was never edited; every change became a new file.

Details in the [project README](https://github.com/ENRICO741/nodeLogin#backend) (in Portuguese).

## How content was added

Writing a lesson required no database or programming: each lesson was a folder with one HTML file.

```text
conteudo/aulas/          (lessons)
  16-new-topic/
    aula.html            title, text and questions
    imagens/             images used in the lesson
```

1. Copy `conteudo/modelo/` (the template) to `conteudo/aulas/16-new-topic/`. The number sets the lesson's place in the track.
2. Edit `aula.html`. Each question has 4 options, one marked as correct, and an explanation shown after the answer (attributes are in Portuguese):

```html
<div data-pergunta="password-request" data-pontos="10">
  <p data-enunciado>Someone calls claiming to be IT support and asks for your password. What do you do?</p>
  <ol>
    <li>Give the password, since it's support</li>
    <li>Give only half of it</li>
    <li data-correta>Refuse, hang up and report it to security</li>
    <li>Ask them to send an email first</li>
  </ol>
  <p data-explicacao>No legitimate person asks for your password. Refuse and report.</p>
</div>
```

3. Open the file in a browser to preview it with the app's look.
4. Run the validator. If something is wrong, it names the file, the question and the problem:

```text
$ docker compose exec api npm run importar-aulas -- --validar
04-engenharia-social/aula.html: pergunta "pedido-de-senha": precisa de exatamente 1 alternativa com data-correta, tem 2
(needs exactly 1 option with data-correta, has 2)
```

5. Push. CI ran the same validator and, if everything was green, the deploy shipped it. The API imported the lesson on startup without losing answers or points already earned.

**Trivia questions** were added through the app's admin area, with no code: prompt, options, explanation, level (easy, medium or hard) and a reference lesson, which became a "Review lesson" link when someone answered wrong.

That made content versioned and tested just like code, and lesson authors never had to touch the database. The full guide is in [conteudo/README.md](https://github.com/ENRICO741/nodeLogin/blob/main/conteudo/README.md) (in Portuguese).

## Continuous delivery

Every push ran this sequence on [GitHub Actions](https://github.com/ENRICO741/nodeLogin/blob/main/.github/workflows/ci.yml):

```text
lint and format           eslint + prettier
caddy validate            a broken Caddyfile would take the site down
lessons                   the validator from the previous section
API tests                 against a real Postgres, 80% minimum coverage
UI tests and build        80% minimum coverage
deploy (main only)        Azure login via OIDC → Run Command on the VM → deploy.sh
```

- **No secrets stored in GitHub:** the Azure login used OIDC.
- **No SSH port open:** the command reached the VM through Azure Run Command.
- **Login action pinned by SHA**, not by tag, because that job's token had root access to the VM.
- **One deploy at a time**, in push order, never cancelling one already running.
- **Lean public log:** Actions showed only progress lines; API logs stayed on the VM.

## AI agents under control

I used Claude Code as a development agent. An agent with terminal and cloud access needs clear limits, and those limits were versioned in the repository:

- **What it could not do** ([`.claude/settings.json`](https://github.com/ENRICO741/nodeLogin/blob/main/.claude/settings.json)): read `.env` files, keys or state files; log in to Azure or request tokens; change roles and permissions; delete resource groups or VMs; `git push --force` and `git reset --hard`; edit its own rules.
- **What it had to ask first:** `git push`, Azure deployments, VM and network commands, `ssh` and `curl`.
- **Extra safety net:** a [hook](https://github.com/ENRICO741/nodeLogin/blob/main/.claude/hooks/block-dangerous.sh) ran before every command and blocked destructive patterns (`rm -rf` on root or home, `az group delete`, `terraform destroy`), even if they slipped past the rules above.
- **Least privilege in the cloud:** the agent used a service principal scoped to the capstone's resource group only. [`CLAUDE.md`](https://github.com/ENRICO741/nodeLogin/blob/main/CLAUDE.md) required a `what-if` before any deployment and told the agent to stop if the active account wasn't that service principal.

The thesis discloses the use of generative AI in development and in proofreading (section 1.6).

## Quality and performance

- **475 API tests and 385 UI tests**, covering 100% and 99.8% of lines. They included error and edge cases: access to another user's data (IDOR), point farming, scoring races, password recovery and rate limiting.
- **k6 load test** on a copy of the production VM, with simulated users waiting 1 to 15 seconds between clicks:
  - **100 concurrent users for 3 minutes**, half new (sign-up and lesson track) and half with existing accounts: zero failures, and 95% of API responses within 20 ms (150 ms for login and sign-up).
  - **Stress test from 250 to 1,000** logged-in users, ramping in steps: p95 went from 21 ms to 41 ms. Of 59,262 requests, only 1 failed, blocked by the rate limiter.
  - This is synthetic load, not real traffic. With the pauses between clicks, 1,000 users produced about 146 requests per second.
  <!-- PENDENTE: link to the published raw k6 results -->

<!-- PENDENTE: mutation testing (number + link to the report) -->

## Security

On October 1, 2026, midway through development, I ran a security pass with Claude Code: a review of the API and UI code, followed by four scanners against the production stack running locally.

**The code review found 7 issues, all fixed with tests:**

| Severity | Issue | Fix |
|---|---|---|
| Medium | A wrong answer revealed the right one, and the next attempt scored: you could top the leaderboard knowing nothing | Only the first attempt at each question scores |
| Medium | Each lesson's HTML, answer key included, was public with no login | The route now serves images only |
| Low-medium | A telemetry event starting with `-` became a formula in the CSV exported to Excel | Anything starting with `-` that isn't a number gets escaped |
| Low | With SMTP off in production, the password reset link went to the log | In production the email is dropped without logging the link |
| Low | Telemetry and trivia accepted 300 requests per minute | A 60-per-minute limit per user |
| Low | The browser cached API responses on disk | `Cache-Control: no-store` on `/api` |
| Low | The password reset token stayed in browser history | The token is removed from the URL as soon as the page opens |

**Then the scanners:**

| Tool | Type | Result |
|---|---|---|
| OWASP ZAP, passive scan | DAST | 0 failures, 5 warnings, 62 rules with no alert |
| OWASP ZAP, active scan | DAST | 0 failures, 2 warnings (headers), 139 rules with no alert |
| Semgrep (601 rules) | SAST | 0 issues in the code; 4 configuration alerts (development Dockerfiles and actions not pinned by SHA) |
| Trivy | dependencies and images | 0 vulnerabilities in the app's dependencies; 19 CVEs in the API image, all in the npm bundled with the Node image |
| Gitleaks | secrets | 1 alert, a false positive (empty `JWT_SECRET=` in `.env.example`) |

npm was removed from the API's production image, and Trivy then found 0 CVEs in it. The Caddy image's CVEs were in its binary; the deploy now rebuilds images with `--pull` on every release. The pass also caught an availability bug: with the database down, the API crashed instead of returning 503. That was fixed.

Limits: ZAP only tested public pages, since it can't log in on its own. The HTML and JSON reports were lost with the temporary folder; what exists today was rebuilt from the session log. <!-- PENDENTE: link to the published reports -->

## Study and privacy

- Consent was required at sign-up, and admin accounts were excluded from the study.
- Data was exported as CSV under pseudonyms, with no name, email or nickname.
- The initial questionnaire (40 items) was required before the first lesson. The final one (32 items) opened 14 days later, with an email invitation and reminder.
- By October 19, 2026, the study had 26 valid initial questionnaires.

## Limits and what I would do differently

- **A single VM, no high availability.** For a study with a few dozen participants, daily backups were enough; for a product, they wouldn't be.
- **The k6 script and results stayed out of Git.** Today I would version both alongside the code.
- **The README fell behind the thesis** on test counts.
- **The study had no control group:** results show association, not causation.

## Screens

The app's interface is in Portuguese.

<div class="gallery">
  <figure><img src="/img/guardiao/trilha.png" alt="Lessons screen with a progress bar, two lessons completed, the third unlocked and the rest locked" loading="lazy" /><figcaption>A 15-lesson track, unlocked in order.</figcaption></figure>
  <figure><img src="/img/guardiao/pergunta-aula.png" alt="Multiple-choice question with the correct option highlighted and the explanation below" loading="lazy" /><figcaption>An explanation right after every answer.</figcaption></figure>
  <figure><img src="/img/guardiao/trivia-erro.png" alt="Trivia question answered wrong, with the explanation and a link to review lesson 9" loading="lazy" /><figcaption>A wrong trivia answer points to the lesson to review.</figcaption></figure>
  <figure><img src="/img/guardiao/trivia-niveis.png" alt="Trivia difficulty choice: easy, medium and hard" loading="lazy" /><figcaption>Trivia in three levels.</figcaption></figure>
  <figure><img src="/img/guardiao/cadastro.png" alt="Sign-up form with password rules and consent to take part in the study" loading="lazy" /><figcaption>Sign-up with study consent.</figcaption></figure>
  <figure><img src="/img/guardiao/conquistas.png" alt="Achievements screen with 2 of 14 unlocked" loading="lazy" /><figcaption>14 achievements.</figcaption></figure>
  <figure><img src="/img/guardiao/ranking.png" alt="Leaderboard with names hidden for privacy" loading="lazy" /><figcaption>Leaderboard (names hidden).</figcaption></figure>
</div>

## Links

- Code: [github.com/ENRICO741/nodeLogin](https://github.com/ENRICO741/nodeLogin)
- Thesis (in Portuguese): coming soon
