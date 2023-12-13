<script>
	import { onMount } from 'svelte';
	import { db } from '../db';
	import TodoListView from "@/components/TodoListView.svelte";

	let lists = [];

	onMount(async () => {
		lists = await db.todoLists.toArray();
	});
</script>

{#if lists.length > 0}
	<div>
		{#each lists as list (list.id)}
			<TodoListView {list} />
		{/each}
	</div>
{:else}
	<div>No lists available</div>
{/if}
