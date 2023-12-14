<script lang="ts">
	import IconSync from './IconSync.svelte';
</script>

<div class="spin-animation">
	<IconSync />
</div>

<style>
	.spin-animation {
		animation: spin 1s linear infinite;
		transform-origin: 50%;
		width: 24px;
		height: 24px;
		padding: 0;
		margin: 0;
	}
</style>
