<script lang="ts">
	export let className: string;
	export let title: string;
</script>

<div class="svg-icon {className}" title={title}>
	<slot></slot>
</div>

<style>
	.svg-icon {
		width: 24px;
		height: 24px;
		padding: 8px 2px 8px 2px;
		/*display: inline-block;*/
	}

	.svg-icon > div {
		width: 24px;
		height: 24px;
		padding: 0;
		margin: 0;
	}

	.svg-icon svg {
		fill: #fff
	}

</style>
