<script lang="ts">
	import { onMount } from 'svelte';
	import { db, TodoList } from '@/db';
	import { faCheckDouble, faEye, faQuestion, faUserEdit, faUserTie } from '@fortawesome/free-solid-svg-icons';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import EditMemberAccess from './EditMemberAccess.svelte';

	export let member;
	export let todoList: TodoList;

	const memberAccessIcon: {
		[memberAccess: string]
	} = {
		owner: faUserEdit,
		doer: faCheckDouble,
		manager: faUserTie,
		readonly: faEye,
	};

	let can = {};
	let globalRoles = {};
	let roleName = member.roles?.[0];
	let role = roleName ? globalRoles?.[roleName] : null;

	let memberAccess = member.userId === todoList.owner ? 'owner' : roleName || 'readonly';
	let memberAccessDisplayName = memberAccess === 'owner' ? 'Owner' : role?.displayName || memberAccess;

	onMount(async () => {
		can = await db.permissions(db, 'members', member);
		globalRoles = await db.cloud.roles;
	});
</script>

<fieldset class="border p-1">
	<FontAwesomeIcon style="margin: 0 4px 0 0; width: 22" icon={memberAccessIcon[memberAccess] || faQuestion} />
	{#if can.update('roles')}
		<EditMemberAccess {todoList} {member} access={memberAccess} />
	{:else}
		{memberAccessDisplayName}
	{/if}
</fieldset>
