<script lang="ts">
	import { writable } from 'svelte/store'
	import { db } from '@/db';
	import type { TodoItem } from '@/db/TodoItem';
	import type { TodoList } from '@/db/TodoList';

	export let todoList: TodoList;

	let title = '';

	function addTodoItem(event) {
		event.preventDefault();
		db.todoItems.add({
			todoListId: todoList.id,
			realmId: todoList.realmId,
			title: title,
		});
		title = '';
	}
</script>

<div class="todorow add-item">
	<div class="narrow">
		<input type="checkbox" disabled />
	</div>
	<div class="todo-item-input">
		<form on:submit|preventDefault={addTodoItem}>
			<input
				type="text"
				placeholder="Add todo item ..."
				bind:value={title}
			/>
		</form>
	</div>
</div>
