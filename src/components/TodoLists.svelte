<script lang="ts">
	import { onMount } from 'svelte';
	import { db } from '../db';
	import TodoListView from '@/components/TodoListView.svelte';

	let lists = [];

	onMount(async () => {
		lists = await db.todoLists.toArray();
		console.log('lists', lists);
	});
</script>

{#if lists.length > 0}
	<div>
		{#each lists as list (list.id)}
			<pre>{JSON.stringify(list)}</pre>
		{/each}
	</div>
{:else}
	<div>No lists available</div>
{/if}
