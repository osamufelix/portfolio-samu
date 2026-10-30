export type Lang = 'pt' | 'en';

// getStaticPaths de toda página: pt na raiz, en em /en.
export const langPaths = () => [
  { params: { lang: undefined }, props: { lang: 'pt' as Lang } },
  { params: { lang: 'en' }, props: { lang: 'en' as Lang } },
];

export const prefix = (lang: Lang) => (lang === 'pt' ? '' : '/en');

// Slugs iguais nos dois idiomas: trocar de idioma é só pôr ou tirar /en.
export const otherLangPath = (lang: Lang, path: string) =>
  lang === 'pt' ? `/en${path === '/' ? '' : path}` : path.replace(/^\/en/, '') || '/';

export const links = {
  github: 'https://github.com/osamufelix',
  linkedin: 'https://www.linkedin.com/in/samuelfelix',
  repo: 'https://github.com/osamufelix/portfolio-samu',
};

export const ui = {
  pt: {
    htmlLang: 'pt-BR',
    switchTo: 'EN',
    switchLabel: 'Read in English',
    cases: 'cases',
    howBuilt: 'como foi feito',
    theme: 'Alternar tema claro/escuro',
    stack: 'stack evidenciada nos cases',
    allCases: 'ver todos os cases',
    readCase: 'ler o case',
    casesTitle: 'Cases',
    casesIntro: 'Projetos meus, com código, decisões e números verificáveis.',
    footer: 'Site estático, código aberto.',
  },
  en: {
    htmlLang: 'en',
    switchTo: 'BR',
    switchLabel: 'Ler em português',
    cases: 'cases',
    howBuilt: 'how it is built',
    theme: 'Toggle light/dark theme',
    stack: 'stack backed by the cases',
    allCases: 'see all cases',
    readCase: 'read the case',
    casesTitle: 'Cases',
    casesIntro: 'My own projects, with code, decisions and numbers you can check.',
    footer: 'Static site, open source.',
  },
} as const;
