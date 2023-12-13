<script>
	import writeable from 'svelte/store';
	import { onMount } from 'svelte';
	import { db } from '../db';
	import TodoItemView from './TodoItemView.svelte';
	import AddTodoItem from './AddTodoItem.svelte';
	import SharingForm from './access-control/SharingForm.svelte';
	import { faShareAlt, faTrashAlt } from '@fortawesome/free-solid-svg-icons';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';

	export let todoList;

	let items = [];
	let can = {};
	let showInviteForm = false;

	onMount(async () => {
		items = await db.todoItems.where({ todoListId: todoList.id }).toArray();
		can = await db.permissions(todoList);
	});

	function toggleInviteForm() {
		showInviteForm = !showInviteForm;
	}

	function deleteList() {
		todoList.delete();
	}
</script>

<div class="box">
	<div class="grid-row">
		<h2>{todoList.title}</h2>
		<div class="todo-list-trash">
			<button
				disabled={!can.delete}
				on:click={deleteList}
				title="Delete list"
			>
				<FontAwesomeIcon icon={faTrashAlt} />
			</button>
		</div>

		{#if !todoList.isPrivate}
			<div class="todo-list-trash">
				<button
					on:click={toggleInviteForm}
				>
					<FontAwesomeIcon icon={faShareAlt} />
				</button>
			</div>
		{/if}
	</div>
	{#if showInviteForm}
		<SharingForm {todoList} />
	{/if}
	<div>
		{#each items as item (item.id)}
			<TodoItemView {item} />
		{/each}
	</div>
	{#if can.add('todoItems')}
		<div>
			<AddTodoItem {todoList} />
		</div>
	{/if}
</div>
