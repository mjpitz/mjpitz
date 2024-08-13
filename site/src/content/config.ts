import { defineCollection, z } from 'astro:content';

const common = z.object({
	title: z.string(),
	description: z.string(),
	series: z.object({
		title: z.string(),
		subtitle: z.string(),
	}).optional(),
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
	canonical: z.string().optional(),
});

export const collections = {
	'blog': defineCollection({
		type: 'content',
		schema: common,
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
