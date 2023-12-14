<script lang="ts">
	import { onMount } from 'svelte';
	import { db, TodoList } from '@/db';
	import { getTiedRealmId } from 'dexie-cloud-addon';
	import { faCheckDouble, faEye, faQuestion, faUserEdit, faUserTie } from '@fortawesome/free-solid-svg-icons';

	export let todoList: TodoList;
	export let member;
	export let access: string;

	const memberAccessIcon = {
		owner: faUserEdit,
		doer: faCheckDouble,
		manager: faUserTie,
		readonly: faEye,
	};

	let roles = {};

	onMount(async () => {
		roles = await db.cloud.roles || {};
	});

	async function changeAccess(
		todoList: TodoList,
		member,
		existingAccess: string,
		newAccess: string
	) {
		const realmId = getTiedRealmId(todoList.id);
		await db.transaction('rw', db.todoLists, db.members, db.realms, async () => {
			if (existingAccess !== 'owner' && newAccess === 'owner') {
				if (!member.userId)
					throw new Error(
						`Cannot give ownership to user before invite is accepted.`
					);
				await db.members
					.where({ realmId, userId: todoList.owner })
					.modify({ roles: ['manager'] });
				await db.members.where({ realmId }).modify({ owner: member.userId });
				await db.todoLists.update(todoList, { owner: member.userId });
				await db.realms.update(realmId, { owner: member.userId });
			}
			if (newAccess !== 'owner') {
				await db.members.update(member, { permissions: {}, roles: [newAccess] });
			}
			if (existingAccess === 'owner' && newAccess !== 'owner') {
				await db.todoLists.update(todoList, { owner: db.cloud.currentUserId });
				await db.realms.update(realmId, {
					owner: db.cloud.currentUserId,
				});
			}
		});
	}
</script>

<select
	disabled={todoList.owner === member.userId && member.userId === db.cloud.currentUserId}
	bind:value={access}
	on:change="{(ev) => changeAccess(todoList, member, access, ev.target.value)}"
>
	<option value="owner" disabled={!member.userId}>
		Owner
	</option>

	{#each Object.entries(roles) as [roleName, role]}
		<option key={roleName} value={roleName}>
			{role.displayName}
		</option>
	{/each}

	{#if !roles[access] && access !== 'owner'}
		<option key={access}>(unknown)</option>`}
	{/if}
</select>
