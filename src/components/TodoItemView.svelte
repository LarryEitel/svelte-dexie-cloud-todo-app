<script lang="ts">
	import { onMount } from 'svelte';
	import { db } from '@/db';
	import type { TodoItem } from '@/db/TodoItem';
	import { faTrash } from '@fortawesome/free-solid-svg-icons';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';

	export let item: TodoItem;

	let can = {};

	onMount(async () => {
		can = await db.permissions(db, 'todoItems', item);
	});

	function updateDone(event) {
		db.todoItems.update(item.id, {
			done: event.target.checked,
		});
	}

	function deleteItem() {
		db.todoItems.delete(item.id);
	}
</script>

<div class={'todorow ' + (item.done ? 'done' : '')}>
	<div class="narrow">
		<input
			type="checkbox"
			disabled={!can.update('done')}
			checked={!!item.done}
			on:change={updateDone}
		/>
	</div>
	<div class="todo-item-text">{item.title}</div>
	<div class="todo-item-trash">
		<button
			disabled={!can.delete()}
			on:click={deleteItem}
			title="Delete item"
		>
			<FontAwesomeIcon icon={faTrash} />
		</button>
	</div>
</div>
