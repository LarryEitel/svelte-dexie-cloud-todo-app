<script lang="ts">
	import { onMount } from 'svelte';
	import { db } from '../db';
	import { faDatabase } from '@fortawesome/free-solid-svg-icons';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';

	async function resetDatabase() {
		await db.delete();
		location.reload(); // Reload the page to reset application state hard.
	}
</script>

<button class="large-button" on:click={resetDatabase}>
	<FontAwesomeIcon icon={faDatabase} />
	Factory reset client
</button>
