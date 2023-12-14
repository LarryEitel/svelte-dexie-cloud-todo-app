<script lang="ts">
	import { reactive } from 'svelte';
	import { db } from '@/db';
	import IconConnecting from '../icons/IconConnecting.svelte';
	import IconError from '../icons/IconError.svelte';
	import IconOffline from '../icons/IconOffline.svelte';
	import IconOnline from '../icons/IconOnline.svelte';
	import IconSleepyCloud from '../icons/IconSleepyCloud.svelte';
	import SvgIcon from './SvgIcon.svelte';

	export let className: string;

	let syncStatus = reactive(db.cloud.syncState);
</script>

{#if syncStatus.status === 'not-started'}
	<SvgIcon {className}></SvgIcon>
{:else if syncStatus.status === 'connecting'}
	<SvgIcon {className}>
		<IconConnecting />
	</SvgIcon>
{:else if syncStatus.status === 'connected'}
	<SvgIcon {className}>
		<IconOnline />
	</SvgIcon>
{:else if syncStatus.status === 'disconnected'}
	<SvgIcon {className}>
		<IconSleepyCloud />
	</SvgIcon>
{:else if syncStatus.status === 'offline'}
	<SvgIcon {className} title={syncStatus.error && '' + syncStatus.error}>
		<IconOffline />
	</SvgIcon>
{:else if syncStatus.status === 'error'}
	<SvgIcon {className} title={syncStatus.error && '' + syncStatus.error}>
		<IconError />
	</SvgIcon>
{:else}
	<SvgIcon {className}>{syncStatus.phase}</SvgIcon>
{/if}
