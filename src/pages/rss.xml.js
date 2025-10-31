import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';
import { SITE_DESCRIPTION, SITE_TITLE } from '../consts';

export async function GET(context) {
	const posts = await getCollection('blog');

	if (!context.site) {
		throw new Error('RSS feed requires the `site` property to be set in astro.config.mjs');
	}

	const sortedPosts = posts.sort(
		(a, b) => b.data.pubDate.valueOf() - a.data.pubDate.valueOf(),
	);

	return rss({
		title: SITE_TITLE,
		description: SITE_DESCRIPTION,
		site: context.site,
		items: sortedPosts.map((post) => {
			const slug = post.slug ?? post.id.replace(/\.mdx?$/, '');

			return {
				title: post.data.title,
				description: post.data.description,
				pubDate: post.data.updatedDate ?? post.data.pubDate,
				link: `/blog/${slug}/`,
			};
		}),
	});
}
