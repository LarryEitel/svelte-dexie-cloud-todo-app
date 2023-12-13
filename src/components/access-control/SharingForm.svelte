<script>
	import writable from 'svelte/store';
	import { onMount } from 'svelte';
	import { db } from '../../db';
	import EditMember from './EditMember.svelte';
	import { faTrash } from '@fortawesome/free-solid-svg-icons';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import importFile from '../../data/importfile.json';

	export let todoList;

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
				<MemberRow {member} {todoList} />
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
	{:else}
		<a href="#" on:click|preventDefault={toggleManualInvite}>
			Invite by email address
		</a>
	{/if}
	<hr />
{/if}

<script>
	function MemberRow({ member, todoList }) {
		const can = db.permissions(db, 'members', member);
		const isMe = member.userId === db.cloud.currentUserId;
		const isOwner = member.userId === todoList.owner;
		let memberText = member.name || member.email || member.userId;
		if (isMe) memberText += ' (me)';

		return (
			<tr style={member.accepted ? {} : { opacity: 0.5 }}>
				<td style={{ paddingRight: 12 }}>{memberText}</td>
				<td>
					<EditMember {member} {todoList} />
				</td>
				<td>
					{can.delete() && !isOwner ? (
						<div className="todo-list-trash">
							<button className="button" on:click={() => todoList.unshareWith(member)}>
								{!!member.rejected && <span style={{ fontStyle: 'italic' }}>Rejected </span>}
								{!member.rejected && !member.accepted && <span style={{ fontStyle: 'italic' }}>Pending invite </span>}
								<FontAwesomeIcon icon={faTrash} />
							</button>
						</div>
					) : (
						!isOwner && member.userId === db.cloud.currentUserId && ((member.accepted?.getTime() || 0) > (member.rejected?.getTime() || 0) ? (
							<button on:click={() => todoList.leave()}>Leave list</button>
						) : (
							<button on:click={() => db.members.update(member.id, { accepted: new Date(), rejected: undefined })}>
								Accept invite
							</button>
						))}
					)}
				</td>
				<td></td>
			</tr>
		);
	}
</script>
