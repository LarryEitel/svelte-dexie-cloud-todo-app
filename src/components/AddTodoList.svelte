<script lang="ts">
	import { db } from '@/db';
	import { onMount } from 'svelte';
	import { faList } from "@fortawesome/free-solid-svg-icons";
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';

	let isActive = false;
	let title = '';
	let hasAnyList;

	onMount(async () => {
		const listCount = await db.todoLists.count();
		hasAnyList = listCount > 0;
	});

	function addList() {
		db.todoLists.add({ title });
		title = '';
		isActive = false;
	}
</script>

{#if !isActive}
	<button class="large-button" on:click={() => isActive = !isActive}>
		<FontAwesomeIcon icon={faList} />{' '}
		{hasAnyList ? `Add another list` : `Create ToDo List`}
	</button>
{:else}
	<div class="box">
		<h2>Give your list a name:</h2>
		<div class="todo-item-input">
			<input
				type="text"
				placeholder="Name of list..."
				bind:value={title}
				on:keyup={(ev) => {
          if (ev.key === "Enter") {
            addList();
          }
        }}
			/>
		</div>
	</div>
{/if}
