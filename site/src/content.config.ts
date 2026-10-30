import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

// Todo o texto vem de ../content/{pt,en}/ (fonte única: o chat da fase 3 lê a mesma pasta).
// ids: "pt/home", "en/cases/guardiao-impacta", "pt/como-foi-feito"...
const pages = defineCollection({
  loader: glob({ pattern: '**/*.md', base: '../content' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    // só na home
    stack: z.array(z.string()).optional(),
    // só nos cases
    order: z.number().optional(),
    metrics: z.array(z.object({ value: z.string().optional(), label: z.string() })).optional(),
    tags: z.array(z.string()).optional(),
  }),
});

export const collections = { pages };
