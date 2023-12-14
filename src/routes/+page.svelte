<script>
	import { db } from '@/db';
	import NavBar from '../components/navbar/NavBar.svelte';
	import TodoLists from '../components/TodoLists.svelte';
	import Invites from '../components/access-control/Invites.svelte';
	import AddTodoList from '../components/AddTodoList.svelte';
	import ResetDatabaseButton from '../components/ResetDatabaseButton.svelte';
	import { onMount } from 'svelte';

	let currentUser;
	let license;

	onMount(async () => {
		currentUser = await db.cloud.currentUser;
		license = currentUser?.license;
	});

	async function deleteUserAccount(user) {
		if (!user?.userId) return; // Safety check
		const confirmed = confirm(`Are you sure you want to delete your user completely along all stored data for ${user.userId}? Private data will be deleted. Shared data will not be deleted. This action cannot be undone.`);
		if (!confirmed) return;
		await fetch(`${db.cloud.options?.databaseUrl}/users/${user.userId}`, {
			method: 'DELETE',
			headers: {
				Authorization: `Bearer ${user.accessToken}`,
			},
		});
		await db.cloud.logout({ force: true });
	}
</script>

<div>
	<h1>Svelte Dexie Cloud Todo App (WIP)</h1>

	<p>This is an attempt to port a sample
		<a href="https://github.com/dexie/Dexie.js/tree/master/samples/dexie-cloud-todo-app">(React) ToDo app
			from Dexie.js
		</a>
		to Svelte.
	</p>
	<p>
		<b>Note:</b> Parts converted to svelte but not yet functional.
	</p>
	<p>
		<b>If this interests you, <a href="https://github.com/LarryEitel/svelte-dexie-cloud-todo-app">please jump in</a>.</b>
	</p>
</div>

<div>
	<NavBar />
	<Invites />
	<TodoLists />
	<AddTodoList />
	<ResetDatabaseButton />
</div>
