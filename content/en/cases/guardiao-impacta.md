---
title: Guardião Impacta
description: Information security app built as a capstone project and used in a field study.
order: 1
metrics:
  - { value: "475 + 385", label: tests }
  - { value: "p99 184 ms", label: "with 1,300 users and 260 req/s" }
tags: [Node.js, React, PostgreSQL, Docker Compose, Azure, GitHub Actions, k6, OWASP ZAP, Semgrep, Trivy, Claude Code]
---

## TL;DR
- **What it is:** a mobile web app (PWA) on information security, a group capstone; I built the app, the infrastructure and the CI/CD.
- **Proof:** SSH-free deploys and 475 + 385 automated tests.
- **Study:** the results are in the thesis.

The app had short lessons, trivia, points, achievements and a leaderboard for people who don't work in IT. It ran in October 2026 and was then shut down.

| | |
|---|---|
| Automated tests | 475 on the API (100% line coverage) and 385 on the UI (99.8%); line coverage doesn't prove quality |
| Load test | 100 concurrent users for 3 minutes (synthetic load): zero failures, 95% of responses within 20 ms; up to 184 ms (p99) in a 1,300-user stress test |
| Security | 6 issues found in code review and fixed; OWASP ZAP with zero failures afterwards (ZAP: public pages only) |
| Delivery | every push to `main` with a green CI went to production on its own: deployed straight to the Azure VM, with no SSH |

## Context

Security awareness programs tend to have low engagement, especially among non-technical staff. The study asked whether a gamified app is more engaging than the traditional trainings the participants had already taken.

## Architecture

<figure class="diagram grande">
  <svg viewBox="0 0 960 720" role="img" aria-label="Production architecture: participants and admins reach Caddy over HTTPS, on an Azure VM running Docker Compose; Caddy forwards /api to the Node.js API, which uses PostgreSQL and sends emails through Brevo over SMTP. Developers push to GitHub, and GitHub Actions tests and deploys to the VM.">
    <defs><marker id="g-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse"><path d="M0 0 L10 5 L0 10 z" class="head" /></marker></defs>
    <rect class="group" x="245" y="10" width="560" height="425" style="stroke-dasharray:7 5" />
    <rect class="group" x="270" y="65" width="510" height="340" style="stroke-dasharray:7 5" />
    <g fill="#0078D4"><rect x="262" y="20" width="32" height="22" rx="2" /><rect x="272" y="46" width="12" height="3" /><rect x="266" y="49" width="24" height="3" rx="1" /></g>
    <text x="306" y="40" text-anchor="start" class="t">Microsoft Azure: virtual machine</text>
    <svg x="278" y="73" width="36" height="36" viewBox="0 0 24 24"><path d="M13.983 11.078h2.119a.186.186 0 00.186-.185V9.006a.186.186 0 00-.186-.186h-2.119a.185.185 0 00-.185.185v1.888c0 .102.083.185.185.185m-2.954-5.43h2.118a.186.186 0 00.186-.186V3.574a.186.186 0 00-.186-.185h-2.118a.185.185 0 00-.185.185v1.888c0 .102.082.185.185.185m0 2.716h2.118a.187.187 0 00.186-.186V6.29a.186.186 0 00-.186-.185h-2.118a.185.185 0 00-.185.185v1.887c0 .102.082.185.185.186m-2.93 0h2.12a.186.186 0 00.184-.186V6.29a.185.185 0 00-.185-.185H8.1a.185.185 0 00-.185.185v1.887c0 .102.083.185.185.186m-2.964 0h2.119a.186.186 0 00.185-.186V6.29a.185.185 0 00-.185-.185H5.136a.186.186 0 00-.186.185v1.887c0 .102.084.185.186.186m5.893 2.715h2.118a.186.186 0 00.186-.185V9.006a.186.186 0 00-.186-.186h-2.118a.185.185 0 00-.185.185v1.888c0 .102.082.185.185.185m-2.93 0h2.12a.185.185 0 00.184-.185V9.006a.185.185 0 00-.184-.186h-2.12a.185.185 0 00-.184.185v1.888c0 .102.083.185.185.185m-2.964 0h2.119a.185.185 0 00.185-.185V9.006a.185.185 0 00-.184-.186h-2.12a.186.186 0 00-.186.186v1.887c0 .102.084.185.186.185m-2.92 0h2.12a.185.185 0 00.184-.185V9.006a.185.185 0 00-.184-.186h-2.12a.185.185 0 00-.184.185v1.888c0 .102.082.185.185.185M23.763 9.89c-.065-.051-.672-.51-1.954-.51-.338.001-.676.03-1.01.087-.248-1.7-1.653-2.53-1.716-2.566l-.344-.199-.226.327c-.284.438-.49.922-.612 1.43-.23.97-.09 1.882.403 2.661-.595.332-1.55.413-1.744.42H.751a.751.751 0 00-.75.748 11.376 11.376 0 00.692 4.062c.545 1.428 1.355 2.48 2.41 3.124 1.18.723 3.1 1.137 5.275 1.137.983.003 1.963-.086 2.93-.266a12.248 12.248 0 003.823-1.389c.98-.567 1.86-1.288 2.61-2.136 1.252-1.418 1.998-2.997 2.553-4.4h.221c1.372 0 2.215-.549 2.68-1.009.309-.293.55-.65.707-1.046l.098-.288Z" fill="#2496ED" /></svg>
    <text x="322" y="98" text-anchor="start" class="t">Docker Compose</text>
    <path d="M150,235 H335" fill="none" style="stroke:var(--fg);stroke-width:1.3" marker-end="url(#g-arrow)" marker-start="url(#g-arrow)" />
    <text x="242" y="226" text-anchor="middle" class="lbl">HTTPS</text>
    <path d="M335,275 H215 V470 H150" fill="none" style="stroke:var(--fg);stroke-width:1.3" marker-end="url(#g-arrow)" marker-start="url(#g-arrow)" />
    <text x="215" y="380" text-anchor="middle" class="lbl">HTTPS</text>
    <path d="M405,250 H575" fill="none" style="stroke:var(--fg);stroke-width:1.3" marker-end="url(#g-arrow)" marker-start="url(#g-arrow)" />
    <text x="490" y="242" text-anchor="middle" class="lbl">/api</text>
    <path d="M645,250 H845" fill="none" style="stroke:var(--fg);stroke-width:1.3" marker-end="url(#g-arrow)" />
    <text x="745" y="242" text-anchor="middle" class="lbl">emails</text>
    <path d="M610,284 V330" fill="none" style="stroke:var(--fg);stroke-width:1.3" marker-end="url(#g-arrow)" marker-start="url(#g-arrow)" />
    <text x="625" y="312" text-anchor="start" class="lbl">SQL</text>
    <path d="M335,600 H465" fill="none" style="stroke:var(--fg);stroke-width:1.3" marker-end="url(#g-arrow)" />
    <text x="400" y="592" text-anchor="middle" class="lbl">push</text>
    <path d="M535,600 H665" fill="none" style="stroke:var(--fg);stroke-width:1.3" marker-end="url(#g-arrow)" />
    <text x="600" y="585" text-anchor="middle" class="lbl">on every</text>
    <text x="600" y="605" text-anchor="middle" class="lbl">change</text>
    <path d="M700,565 V435" fill="none" style="stroke:var(--fg);stroke-width:1.3" marker-end="url(#g-arrow)" />
    <text x="712" y="495" text-anchor="start" class="lbl">automatic</text>
    <text x="712" y="515" text-anchor="start" class="lbl">deploy</text>
    <g><circle cx="111" cy="212" r="13" class="p2" /><path d="M87,258 A24,24 0 0 1 135,258 Z" class="p2" /><circle cx="83" cy="216" r="14" class="p1" /><path d="M57,260 A26,26 0 0 1 109,260 Z" class="p1" /></g>
    <text x="95" y="315" text-anchor="middle" class="t">Participants</text>
    <text x="95" y="337" text-anchor="middle">PWA on phone</text>
    <text x="95" y="359" text-anchor="middle">or computer</text>
    <g class="p1"><circle cx="95" cy="456" r="14" /><path d="M69,500 A26,26 0 0 1 121,500 Z" /></g>
    <text x="95" y="550" text-anchor="middle" class="t">Admins</text>
    <text x="95" y="572" text-anchor="middle">admin area</text>
    <svg x="338" y="218" width="64" height="64" viewBox="0 0 24 24"><path d="M11.094.47c-.842 0-1.696.092-2.552.288a11.37 11.37 0 0 0-4.87 2.423 10.632 10.632 0 0 0-2.36 2.826A10.132 10.132 0 0 0 .305 8.582c-.398 1.62-.4 3.336-.043 5.048.085.405.183.809.31 1.212a11.85 11.85 0 0 0 1.662 3.729 3.273 3.273 0 0 0-.086.427 3.323 3.323 0 0 0 2.848 3.71 3.279 3.279 0 0 0 1.947-.346c1.045.51 2.17.864 3.339 1.04a11.66 11.66 0 0 0 4.285-.155 11.566 11.566 0 0 0 4.936-2.485 10.643 10.643 0 0 0 2.352-2.894 11.164 11.164 0 0 0 1.356-4.424 11.214 11.214 0 0 0-.498-4.335c.175-.077.338-.175.486-.293a.444.444 89.992 0 0 .001 0c.402-.322.693-.794.777-1.342a2.146 2.146 0 0 0-1.79-2.434 2.115 2.115 0 0 0-1.205.171c-.038-.043-.078-.086-.113-.13a11.693 11.693 0 0 0-3.476-2.93 13.348 13.348 0 0 0-1.76-.81 13.55 13.55 0 0 0-2.06-.613A12.121 12.121 0 0 0 11.093.47Zm.714.328c.345-.004.688.01 1.028.042a9.892 9.892 0 0 1 2.743.639c.984.39 1.89.958 2.707 1.632.803.662 1.502 1.45 2.091 2.328.026.039.048.08.07.12a2.12 2.12 0 0 0-.435 2.646c-.158.114-.97.692-1.634 1.183-.414.308-.733.557-.733.557l.581.68s.296-.276.665-.638c.572-.562 1.229-1.233 1.395-1.403a2.122 2.122 0 0 0 1.907.677 11.229 11.229 0 0 1-.013 4.046 11.41 11.41 0 0 1-1.475 3.897 12.343 12.343 0 0 1-2.079 2.587c-1.19 1.125-2.633 2.022-4.306 2.531a10.826 10.826 0 0 1-3.973.484 11.04 11.04 0 0 1-3.057-.652 3.304 3.304 0 0 0 1.417-2.294 3.275 3.275 0 0 0-.294-1.842c.18-.162.403-.363.656-.6 1.015-.955 2.353-2.303 2.353-2.303l-.47-.599s-1.63.972-2.801 1.728c-.307.198-.573.378-.777.517a3.273 3.273 0 0 0-1.516-.611c-1.507-.198-2.927.672-3.487 2.017a10.323 10.323 0 0 1-.695-1.078A10.92 10.92 0 0 1 .728 14.8a10.35 10.35 0 0 1-.2-1.212c-.164-1.653.103-3.258.629-4.754a12.95 12.95 0 0 1 1.087-2.288c.57-.968 1.248-1.872 2.069-2.656A11.013 11.013 0 0 1 11.808.797Zm-.147 3.257a3.838 3.838 0 0 0-3.82 3.82v2.36h-.94c-.751 0-1.377.625-1.377 1.377v3.8h1.46v-3.718h9.354v6.264H10.02v1.46h6.4c.751 0 1.377-.625 1.377-1.377v-6.43c0-.751-.626-1.377-1.377-1.377h-.94v-2.36a3.838 3.838 0 0 0-3.82-3.819zm0 1.46a2.371 2.371 0 0 1 2.36 2.36v2.36H9.3v-2.36a2.372 2.372 0 0 1 2.36-2.36zm10.141.392a1.253 1.253 0 0 1 1.296 1.434c-.049.319-.217.59-.453.78-.266.213-.61.318-.968.264a1.253 1.253 0 0 1-1.045-1.42 1.255 1.255 0 0 1 1.17-1.058zM5.384 17.425a2.02 2.02 0 0 1 1.917 1.298c.116.3.159.628.114.967a2.015 2.015 0 0 1-2.249 1.728 2.016 2.016 0 0 1-1.727-2.25 2.017 2.017 0 0 1 1.945-1.743z" fill="#1F88C0" /></svg>
    <text x="370" y="150" text-anchor="middle" class="t">Caddy</text>
    <text x="370" y="172" text-anchor="middle">HTTPS (Let's Encrypt)</text>
    <text x="370" y="194" text-anchor="middle">and the PWA files</text>
    <svg x="578" y="218" width="64" height="64" viewBox="0 0 24 24"><path d="M11.998,24c-0.321,0-0.641-0.084-0.922-0.247l-2.936-1.737c-0.438-0.245-0.224-0.332-0.08-0.383 c0.585-0.203,0.703-0.25,1.328-0.604c0.065-0.037,0.151-0.023,0.218,0.017l2.256,1.339c0.082,0.045,0.197,0.045,0.272,0l8.795-5.076 c0.082-0.047,0.134-0.141,0.134-0.238V6.921c0-0.099-0.053-0.192-0.137-0.242l-8.791-5.072c-0.081-0.047-0.189-0.047-0.271,0 L3.075,6.68C2.99,6.729,2.936,6.825,2.936,6.921v10.15c0,0.097,0.054,0.189,0.139,0.235l2.409,1.392 c1.307,0.654,2.108-0.116,2.108-0.89V7.787c0-0.142,0.114-0.253,0.256-0.253h1.115c0.139,0,0.255,0.112,0.255,0.253v10.021 c0,1.745-0.95,2.745-2.604,2.745c-0.508,0-0.909,0-2.026-0.551L2.28,18.675c-0.57-0.329-0.922-0.945-0.922-1.604V6.921 c0-0.659,0.353-1.275,0.922-1.603l8.795-5.082c0.557-0.315,1.296-0.315,1.848,0l8.794,5.082c0.57,0.329,0.924,0.944,0.924,1.603 v10.15c0,0.659-0.354,1.273-0.924,1.604l-8.794,5.078C12.643,23.916,12.324,24,11.998,24z M19.099,13.993 c0-1.9-1.284-2.406-3.987-2.763c-2.731-0.361-3.009-0.548-3.009-1.187c0-0.528,0.235-1.233,2.258-1.233 c1.807,0,2.473,0.389,2.747,1.607c0.024,0.115,0.129,0.199,0.247,0.199h1.141c0.071,0,0.138-0.031,0.186-0.081 c0.048-0.054,0.074-0.123,0.067-0.196c-0.177-2.098-1.571-3.076-4.388-3.076c-2.508,0-4.004,1.058-4.004,2.833 c0,1.925,1.488,2.457,3.895,2.695c2.88,0.282,3.103,0.703,3.103,1.269c0,0.983-0.789,1.402-2.642,1.402 c-2.327,0-2.839-0.584-3.011-1.742c-0.02-0.124-0.126-0.215-0.253-0.215h-1.137c-0.141,0-0.254,0.112-0.254,0.253 c0,1.482,0.806,3.248,4.655,3.248C17.501,17.007,19.099,15.91,19.099,13.993z" fill="#5FA04E" /></svg>
    <text x="610" y="170" text-anchor="middle" class="t">API</text>
    <text x="610" y="192" text-anchor="middle">Node.js + Express</text>
    <svg x="582" y="332" width="56" height="56" viewBox="0 0 24 24"><path d="M23.5594 14.7228a.5269.5269 0 0 0-.0563-.1191c-.139-.2632-.4768-.3418-1.0074-.2321-1.6533.3411-2.2935.1312-2.5256-.0191 1.342-2.0482 2.445-4.522 3.0411-6.8297.2714-1.0507.7982-3.5237.1222-4.7316a1.5641 1.5641 0 0 0-.1509-.235C21.6931.9086 19.8007.0248 17.5099.0005c-1.4947-.0158-2.7705.3461-3.1161.4794a9.449 9.449 0 0 0-.5159-.0816 8.044 8.044 0 0 0-1.3114-.1278c-1.1822-.0184-2.2038.2642-3.0498.8406-.8573-.3211-4.7888-1.645-7.2219.0788C.9359 2.1526.3086 3.8733.4302 6.3043c.0409.818.5069 3.334 1.2423 5.7436.4598 1.5065.9387 2.7019 1.4334 3.582.553.9942 1.1259 1.5933 1.7143 1.7895.4474.1491 1.1327.1441 1.8581-.7279.8012-.9635 1.5903-1.8258 1.9446-2.2069.4351.2355.9064.3625 1.39.3772a.0569.0569 0 0 0 .0004.0041 11.0312 11.0312 0 0 0-.2472.3054c-.3389.4302-.4094.5197-1.5002.7443-.3102.064-1.1344.2339-1.1464.8115-.0025.1224.0329.2309.0919.3268.2269.4231.9216.6097 1.015.6331 1.3345.3335 2.5044.092 3.3714-.6787-.017 2.231.0775 4.4174.3454 5.0874.2212.5529.7618 1.9045 2.4692 1.9043.2505 0 .5263-.0291.8296-.0941 1.7819-.3821 2.5557-1.1696 2.855-2.9059.1503-.8707.4016-2.8753.5388-4.1012.0169-.0703.0357-.1207.057-.1362.0007-.0005.0697-.0471.4272.0307a.3673.3673 0 0 0 .0443.0068l.2539.0223.0149.001c.8468.0384 1.9114-.1426 2.5312-.4308.6438-.2988 1.8057-1.0323 1.5951-1.6698zM2.371 11.8765c-.7435-2.4358-1.1779-4.8851-1.2123-5.5719-.1086-2.1714.4171-3.6829 1.5623-4.4927 1.8367-1.2986 4.8398-.5408 6.108-.13-.0032.0032-.0066.0061-.0098.0094-2.0238 2.044-1.9758 5.536-1.9708 5.7495-.0002.0823.0066.1989.0162.3593.0348.5873.0996 1.6804-.0735 2.9184-.1609 1.1504.1937 2.2764.9728 3.0892.0806.0841.1648.1631.2518.2374-.3468.3714-1.1004 1.1926-1.9025 2.1576-.5677.6825-.9597.5517-1.0886.5087-.3919-.1307-.813-.5871-1.2381-1.3223-.4796-.839-.9635-2.0317-1.4155-3.5126zm6.0072 5.0871c-.1711-.0428-.3271-.1132-.4322-.1772.0889-.0394.2374-.0902.4833-.1409 1.2833-.2641 1.4815-.4506 1.9143-1.0002.0992-.126.2116-.2687.3673-.4426a.3549.3549 0 0 0 .0737-.1298c.1708-.1513.2724-.1099.4369-.0417.156.0646.3078.26.3695.4752.0291.1016.0619.2945-.0452.4444-.9043 1.2658-2.2216 1.2494-3.1676 1.0128zm2.094-3.988-.0525.141c-.133.3566-.2567.6881-.3334 1.003-.6674-.0021-1.3168-.2872-1.8105-.8024-.6279-.6551-.9131-1.5664-.7825-2.5004.1828-1.3079.1153-2.4468.079-3.0586-.005-.0857-.0095-.1607-.0122-.2199.2957-.2621 1.6659-.9962 2.6429-.7724.4459.1022.7176.4057.8305.928.5846 2.7038.0774 3.8307-.3302 4.7363-.084.1866-.1633.3629-.2311.5454zm7.3637 4.5725c-.0169.1768-.0358.376-.0618.5959l-.146.4383a.3547.3547 0 0 0-.0182.1077c-.0059.4747-.054.6489-.115.8693-.0634.2292-.1353.4891-.1794 1.0575-.11 1.4143-.8782 2.2267-2.4172 2.5565-1.5155.3251-1.7843-.4968-2.0212-1.2217a6.5824 6.5824 0 0 0-.0769-.2266c-.2154-.5858-.1911-1.4119-.1574-2.5551.0165-.5612-.0249-1.9013-.3302-2.6462.0044-.2932.0106-.5909.019-.8918a.3529.3529 0 0 0-.0153-.1126 1.4927 1.4927 0 0 0-.0439-.208c-.1226-.4283-.4213-.7866-.7797-.9351-.1424-.059-.4038-.1672-.7178-.0869.067-.276.1831-.5875.309-.9249l.0529-.142c.0595-.16.134-.3257.213-.5012.4265-.9476 1.0106-2.2453.3766-5.1772-.2374-1.0981-1.0304-1.6343-2.2324-1.5098-.7207.0746-1.3799.3654-1.7088.5321a5.6716 5.6716 0 0 0-.1958.1041c.0918-1.1064.4386-3.1741 1.7357-4.4823a4.0306 4.0306 0 0 1 .3033-.276.3532.3532 0 0 0 .1447-.0644c.7524-.5706 1.6945-.8506 2.802-.8325.4091.0067.8017.0339 1.1742.081 1.939.3544 3.2439 1.4468 4.0359 2.3827.8143.9623 1.2552 1.9315 1.4312 2.4543-1.3232-.1346-2.2234.1268-2.6797.779-.9926 1.4189.543 4.1729 1.2811 5.4964.1353.2426.2522.4522.2889.5413.2403.5825.5515.9713.7787 1.2552.0696.087.1372.1714.1885.245-.4008.1155-1.1208.3825-1.0552 1.717-.0123.1563-.0423.4469-.0834.8148-.0461.2077-.0702.4603-.0994.7662zm.8905-1.6211c-.0405-.8316.2691-.9185.5967-1.0105a2.8566 2.8566 0 0 0 .135-.0406 1.202 1.202 0 0 0 .1342.103c.5703.3765 1.5823.4213 3.0068.1344-.2016.1769-.5189.3994-.9533.6011-.4098.1903-1.0957.333-1.7473.3636-.7197.0336-1.0859-.0807-1.1721-.151zm.5695-9.2712c-.0059.3508-.0542.6692-.1054 1.0017-.055.3576-.112.7274-.1264 1.1762-.0142.4368.0404.8909.0932 1.3301.1066.887.216 1.8003-.2075 2.7014a3.5272 3.5272 0 0 1-.1876-.3856c-.0527-.1276-.1669-.3326-.3251-.6162-.6156-1.1041-2.0574-3.6896-1.3193-4.7446.3795-.5427 1.3408-.5661 2.1781-.463zm.2284 7.0137a12.3762 12.3762 0 0 0-.0853-.1074l-.0355-.0444c.7262-1.1995.5842-2.3862.4578-3.4385-.0519-.4318-.1009-.8396-.0885-1.2226.0129-.4061.0666-.7543.1185-1.0911.0639-.415.1288-.8443.1109-1.3505.0134-.0531.0188-.1158.0118-.1902-.0457-.4855-.5999-1.938-1.7294-3.253-.6076-.7073-1.4896-1.4972-2.6889-2.0395.5251-.1066 1.2328-.2035 2.0244-.1859 2.0515.0456 3.6746.8135 4.8242 2.2824a.908.908 0 0 1 .0667.1002c.7231 1.3556-.2762 6.2751-2.9867 10.5405zm-8.8166-6.1162c-.025.1794-.3089.4225-.6211.4225a.5821.5821 0 0 1-.0809-.0056c-.1873-.026-.3765-.144-.5059-.3156-.0458-.0605-.1203-.178-.1055-.2844.0055-.0401.0261-.0985.0925-.1488.1182-.0894.3518-.1226.6096-.0867.3163.0441.6426.1938.6113.4186zm7.9305-.4114c.0111.0792-.049.201-.1531.3102-.0683.0717-.212.1961-.4079.2232a.5456.5456 0 0 1-.075.0052c-.2935 0-.5414-.2344-.5607-.3717-.024-.1765.2641-.3106.5611-.352.297-.0414.6111.0088.6356.1851z" fill="#4169E1" /></svg>
    <text x="570" y="345" text-anchor="end" class="t">PostgreSQL</text>
    <text x="570" y="367" text-anchor="end">app data</text>
    <text x="570" y="387" text-anchor="end">and study views</text>
    <svg x="858" y="218" width="64" height="64" viewBox="0 0 24 24"><path d="M12 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0zM7.2 4.8h5.747c2.34 0 3.895 1.406 3.895 3.516 0 1.022-.348 1.862-1.09 2.588C17.189 11.812 18 13.22 18 14.785c0 2.86-2.64 5.016-6.164 5.016H7.199v-15zm2.085 1.952v5.537h.07c.233-.432.858-.796 2.249-1.226 2.039-.659 3.037-1.52 3.037-2.655 0-.998-.766-1.656-1.924-1.656H9.285zm4.87 5.266c-.766.385-1.67.748-2.76 1.11-1.229.387-2.11 1.386-2.11 2.407v2.315h2.365c2.387 0 4.149-1.34 4.149-3.155 0-1.067-.625-2.087-1.645-2.677z" fill="#0B996E" /></svg>
    <text x="890" y="330" text-anchor="middle" class="t">Brevo</text>
    <text x="890" y="352" text-anchor="middle">email sending</text>
    <text x="890" y="374" text-anchor="middle">(SMTP)</text>
    <g class="p1"><circle cx="300" cy="586" r="14" /><path d="M274,630 A26,26 0 0 1 326,630 Z" /></g>
    <text x="300" y="665" text-anchor="middle" class="t">Developers</text>
    <svg x="468" y="568" width="64" height="64" viewBox="0 0 24 24"><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12" fill="var(--fg)" /></svg>
    <text x="500" y="665" text-anchor="middle" class="t">GitHub</text>
    <text x="500" y="687" text-anchor="middle">repository</text>
    <svg x="668" y="568" width="64" height="64" viewBox="0 0 24 24"><path d="M10.984 13.836a.5.5 0 0 1-.353-.146l-.745-.743a.5.5 0 1 1 .706-.708l.392.391 1.181-1.18a.5.5 0 0 1 .708.707l-1.535 1.533a.504.504 0 0 1-.354.146zm9.353-.147l1.534-1.532a.5.5 0 0 0-.707-.707l-1.181 1.18-.392-.391a.5.5 0 1 0-.706.708l.746.743a.497.497 0 0 0 .706-.001zM4.527 7.452l2.557-1.585A1 1 0 0 0 7.09 4.17L4.533 2.56A1 1 0 0 0 3 3.406v3.196a1.001 1.001 0 0 0 1.527.85zm2.03-2.436L4 6.602V3.406l2.557 1.61zM24 12.5c0 1.93-1.57 3.5-3.5 3.5a3.503 3.503 0 0 1-3.46-3h-2.08a3.503 3.503 0 0 1-3.46 3 3.502 3.502 0 0 1-3.46-3h-.558c-.972 0-1.85-.399-2.482-1.042V17c0 1.654 1.346 3 3 3h.04c.244-1.693 1.7-3 3.46-3 1.93 0 3.5 1.57 3.5 3.5S13.43 24 11.5 24a3.502 3.502 0 0 1-3.46-3H8c-2.206 0-4-1.794-4-4V9.899A5.008 5.008 0 0 1 0 5c0-2.757 2.243-5 5-5s5 2.243 5 5a5.005 5.005 0 0 1-4.952 4.998A2.482 2.482 0 0 0 7.482 12h.558c.244-1.693 1.7-3 3.46-3a3.502 3.502 0 0 1 3.46 3h2.08a3.503 3.503 0 0 1 3.46-3c1.93 0 3.5 1.57 3.5 3.5zm-15 8c0 1.378 1.122 2.5 2.5 2.5s2.5-1.122 2.5-2.5-1.122-2.5-2.5-2.5S9 19.122 9 20.5zM5 9c2.206 0 4-1.794 4-4S7.206 1 5 1 1 2.794 1 5s1.794 4 4 4zm9 3.5c0-1.378-1.122-2.5-2.5-2.5S9 11.122 9 12.5s1.122 2.5 2.5 2.5 2.5-1.122 2.5-2.5zm9 0c0-1.378-1.122-2.5-2.5-2.5S18 11.122 18 12.5s1.122 2.5 2.5 2.5 2.5-1.122 2.5-2.5zm-13 8a.5.5 0 1 0 1 0 .5.5 0 0 0-1 0zm2 0a.5.5 0 1 0 1 0 .5.5 0 0 0-1 0zm12 0c0 1.93-1.57 3.5-3.5 3.5a3.503 3.503 0 0 1-3.46-3.002c-.007.001-.013.005-.021.005l-.506.017h-.017a.5.5 0 0 1-.016-.999l.506-.017c.018-.002.035.006.052.007A3.503 3.503 0 0 1 20.5 17c1.93 0 3.5 1.57 3.5 3.5zm-1 0c0-1.378-1.122-2.5-2.5-2.5S18 19.122 18 20.5s1.122 2.5 2.5 2.5 2.5-1.122 2.5-2.5z" fill="#2088FF" /></svg>
    <text x="700" y="665" text-anchor="middle" class="t">GitHub Actions</text>
    <text x="700" y="687" text-anchor="middle">tests and build</text>
  </svg>
  <figcaption>Production architecture.</figcaption>
</figure>

- Three containers on an Azure VM (Ubuntu, 2 vCPUs, 8 GB), orchestrated with Docker Compose: Caddy, the API and Postgres.
- Caddy served the PWA, issued the HTTPS certificate and proxied `/api` to the API. UI and API shared one origin, so there was no CORS to configure.
- Only ports 80 and 443 were open. The API and database lived only on the internal Compose network, and admin access went through Azure Bastion.
- The database was backed up daily.

## Engineering decisions

**Scoring stored on the server, not the phone.** Points drove the leaderboard and the study data, so they couldn't live on the device. The rule handled parallel rounds and repeated taps, and integration tests covered those races.

**Session checked against the database on every request.** Deactivating an account or changing its role took effect immediately, and changing the password invalidated older tokens.

**Versioned schema.** [Numbered SQL migrations](https://github.com/osamufelix/guardiao-impacta#backend) (in Portuguese), applied when the API started and never edited once applied.

## How content was added
A new lesson or question was just one HTML file, with no database and no programming: 4 options, one correct, and an explanation shown after the answer (attributes are in Portuguese).

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

A [validator](https://github.com/osamufelix/guardiao-impacta/blob/main/conteudo/README.md) (in Portuguese) named the file, the question and the problem, and CI ran the same validator before the deploy. The API imported the lesson on startup without losing answers or points already earned.

## Continuous delivery

Every push ran this sequence on [GitHub Actions](https://github.com/osamufelix/guardiao-impacta/blob/main/.github/workflows/ci.yml):

```text
lint and format           eslint + prettier
caddy validate            a broken Caddyfile would take the site down
lessons                   the validator from the previous section
API tests                 against a real Postgres, 80% minimum coverage
UI tests and build        80% minimum coverage
deploy (main only)        Azure login via OIDC → Run Command on the VM → deploy.sh
```

- **No long-lived Azure credential in GitHub:** login used OIDC (email and database credentials lived only on the VM).
- **No SSH port open:** the command reached the VM through Azure Run Command.
- **Login action pinned by SHA**, not by tag, because that job's token had root access to the VM.
- **One deploy at a time**, in push order, never cancelling one already running.
- **Minimal public logs:** Actions showed only progress lines; API logs stayed on the VM.

## AI agents under control

I used Claude Code as a development agent. An agent with terminal and cloud access needs clear limits, and those limits were versioned in the repository:

- **What it could not do** ([`.claude/settings.json`](https://github.com/osamufelix/guardiao-impacta/blob/main/.claude/settings.json)): read `.env` files, keys or state files; log in to Azure or request tokens; change roles and permissions; delete resource groups or VMs; `git push --force` and `git reset --hard`; edit its own rules.
- **What it had to ask first:** `git push`, Azure deployments, VM and network commands, `ssh` and `curl`.
- **Extra safety net:** a [hook](https://github.com/osamufelix/guardiao-impacta/blob/main/.claude/hooks/block-dangerous.sh) ran before every command and blocked destructive patterns (`rm -rf` on root or home, `az group delete`, `terraform destroy`), even if they slipped past the rules above.
- **Least privilege in the cloud:** the agent used a service principal scoped to the capstone's resource group only. [`CLAUDE.md`](https://github.com/osamufelix/guardiao-impacta/blob/main/CLAUDE.md) required a `what-if` before any deployment and told the agent to stop if the active account wasn't that service principal.

## Quality and performance
- **The tests cover error and edge cases:** access to another user's data (IDOR), point farming, scoring races, password recovery and rate limiting.
- **The k6 load ran on a copy of the production VM**, with simulated users waiting 1 to 15 seconds between clicks (synthetic load, not real traffic). In the stress test from 100 to 1,300 users, p95 went from 18 to 68 ms and none of the 59,330 requests failed, at about 260 requests per second.

## Security
I ran an AI-assisted security review with Claude Code: a review of the API and UI code, plus SAST and DAST with Semgrep and OWASP ZAP.

**The code review issues were fixed with tests in commit [`1b8948c`](https://github.com/osamufelix/guardiao-impacta/commit/1b8948c):**

| Severity | Issue | Fix |
|---|---|---|
| Medium | Each lesson's HTML, answer key included, was public with no login | The route now serves images only |
| Low-medium | A telemetry event starting with `-` became a formula in the CSV exported to Excel | Anything starting with `-` that isn't a number gets escaped |
| Low | With SMTP off in production, the password reset link went to the log | In production the email is dropped without logging the link |
| Low | Telemetry and trivia accepted 300 requests per minute | A 60-per-minute limit per user |
| Low | The browser cached API responses on disk | `Cache-Control: no-store` on `/api` |
| Low | The password reset token stayed in browser history | The token is removed from the URL as soon as the page opens |

**Then the scanners:**

| Tool | Type | Result |
|---|---|---|
| OWASP ZAP (passive and active) | DAST | 0 failures in both scans, warnings only |
| Semgrep | SAST | 0 issues in the code; 4 configuration alerts |
| Trivy | dependencies and images | 0 vulnerabilities in dependencies; 19 CVEs in the API image, all in the bundled npm |
| Gitleaks | secrets | 1 alert, a false positive |

npm was removed from the API's production image ([`0dcca2d`](https://github.com/osamufelix/guardiao-impacta/commit/0dcca2d)), and Trivy then found 0 CVEs in it; the deploy also now rebuilds images with `--pull`.

## Limits and what I would do differently
- **A single VM with Compose, no high availability.** For a study with a few dozen participants, daily backups were enough; for a product, they wouldn't be. AKS would need at least 2 nodes, a load balancer and, for an SLA, the paid tier: a choice for simplicity and cost.
- **Availability bug:** with the database down, the API crashed instead of returning 503; fixed in commit [`cb715eb`](https://github.com/osamufelix/guardiao-impacta/commit/cb715eb).
- **The k6 script and results stayed out of Git,** and the scanners' raw reports weren't kept. Today I would version it all alongside the code.
- **The same lessons and questions for everyone.** There were no audience-specific tracks, such as marketing or HR, with content of their own.
- **The study had no control group:** results show association, not causation.

## Study and privacy
- Consent was required at sign-up (admins were excluded), data was exported as CSV under pseudonyms, with no name, email or nickname, and questionnaires were answered in the app: the initial one (40 items) before the first lesson and the final one (32 items) 14 days later.

## Screens

The app's interface is in Portuguese.

<div class="gallery">
  <figure><img src="/img/guardiao/ranking.png" alt="Leaderboard with names hidden for privacy" loading="lazy" /><figcaption>Leaderboard (names hidden).</figcaption></figure>
  <figure><img src="/img/guardiao/pergunta-aula.png" alt="Multiple-choice question with the correct option highlighted and the explanation below" loading="lazy" /><figcaption>An explanation right after every answer.</figcaption></figure>
  <figure><img src="/img/guardiao/trilha.png" alt="Lessons screen with a progress bar, two lessons completed, the third unlocked and the rest locked" loading="lazy" /><figcaption>A 15-lesson track, unlocked in order.</figcaption></figure>
</div>

## Links
- Interested in the code? See it on [GitHub](https://github.com/osamufelix/guardiao-impacta).
- Thesis (PDF, in Portuguese): [Gamificação em security awareness](/docs/monografia-guardiao-impacta.pdf)
