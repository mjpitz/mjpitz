import { defineCollection, z } from 'astro:content';

const common = z.object({
	title: z.string(),
	description: z.string(),
	// Transform string to Date object
	pubDate: z
		.string()
		.or(z.date())
		.transform((val: string|Date) => new Date(val)),
	updatedDate: z
		.string()
		.optional()
		.transform((str: string) => (str ? new Date(str) : undefined)),
	heroImage: z.string().optional(),
});

export const collections = {
	'blog': defineCollection({
		type: 'content',
		schema: common,
	}),
	'go': defineCollection({
		type: 'data',
		schema: z.object({
			redirect: z.string(),
		}),
	}),
	'media': defineCollection({
		type: 'content',
		schema: common,
	}),
	'papers': defineCollection({
		type: 'content',
		schema: common,
	}),
};
