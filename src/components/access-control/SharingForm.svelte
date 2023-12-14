<script lang="ts">
	import { onMount } from 'svelte';
	import { db, TodoList } from '@/db';
	import { faTrash } from '@fortawesome/free-solid-svg-icons';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import EditMember from './EditMember.svelte';
	import importFile from '../../data/importfile.json';

	export let todoList: TodoList;

	let name = '';
	let email = '';
	let members = [];
	let manualInviteOpen = false;
	let can = {};

	onMount(async () => {
		members = await db.members.where({ realmId: todoList.realmId }).toArray();
		can = await db.permissions(todoList);
	});

	function invite(demoUser) {
		manualInviteOpen = false;
		todoList.shareWith(demoUser, demoUser, true, ['doer']);
	}

	function sendInvite(event) {
		event.preventDefault();
		manualInviteOpen = false;
		todoList.shareWith(name, email, true, ['doer']);
	}

	function toggleManualInvite(event) {
		event.preventDefault();
		manualInviteOpen = true;
	}
</script>

{#if members && members.length > 0}
	<table>
		<thead>
			<tr>
				<th>Shared with:</th>
				<th>Role</th>
			</tr>
		</thead>
		<tbody>
			{#each members as member (member.id)}
				<EditMember {member} {todoList} />
			{/each}
		</tbody>
	</table>
{/if}
<hr />
{#if can.add('members')}
	<h4>Invite someone?</h4>
	<table>
		<tbody>
			{#each Object.keys(importFile.demoUsers).filter((demoUser) => demoUser !== db.cloud.currentUserId) as demoUser}
				<tr>
					<td>{demoUser}</td>
					<td>
						<button type="button" on:click={() => invite(demoUser)}>
							Invite
						</button>
					</td>
				</tr>
			{/each}
		</tbody>
	</table>
	{#if manualInviteOpen}
		<form on:submit|preventDefault={sendInvite}>
			<input type="email" bind:value={email} placeholder="Email" />
			<input type="text" bind:value={name} placeholder="Name" />
			<button type="submit" disabled={!/@/.test(email)}>
				Send invite
			</button>
		</form>
	{/if}
	<a href="/" on:click|preventDefault={toggleManualInvite}>
		Invite by email address
	</a>
	<hr />
{/if}
