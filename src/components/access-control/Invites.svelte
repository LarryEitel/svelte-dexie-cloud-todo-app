<script lang="ts">
	import { onMount } from 'svelte';
	import { db } from '@/db';
	import { faTrash } from '@fortawesome/free-solid-svg-icons';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';

	let currentUser;
	let invites = [];

	onMount(async () => {
		currentUser = await db.cloud.currentUser;
		invites = await db.cloud.invites || [];
	});

	function acceptInvite(invite) {
		invite.accept();
	}

	function rejectInvite(invite) {
		invite.reject();
	}

	function deleteInvite(invite) {
		db.members.delete(invite.id);
	}
</script>

{#if invites.length > 0}
	<h3>You've got invited!</h3>
	<table>
		<tr>
			<th></th>
			<th>Name of list</th>
			<th>Invited by</th>
			<th></th>
		</tr>
		{#each invites as invite (invite.id)}
			<tr>
				<td>
					<button
						on:keydown={null}
						on:click={() => acceptInvite(invite)}
						disabled={!!invite.accepted}
					>
						{invite.accepted ? 'Accepted' : 'Accept'}
					</button>
					<button
						on:keydown={null}
						on:click={() => rejectInvite(invite)}
						disabled={!!invite.rejected}
					>
						{invite.rejected ? 'Rejected' : 'Reject'}
					</button>
				</td>
				<td>{invite.realm?.name}</td>
				<td>{invite.invitedBy?.name}</td>
				<td>
					<button
						style="cursor: pointer;"
						on:click={() => deleteInvite(invite)}
						on:keydown={(event) => {
							if (event.key === 'Enter') deleteInvite(invite);
						}}
					>
						<FontAwesomeIcon icon={faTrash} />
					</button>
				</td>
			</tr>
		{/each}
	</table>
{/if}
