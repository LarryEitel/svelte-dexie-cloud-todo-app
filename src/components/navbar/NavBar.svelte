<script lang="ts">
	import { onMount } from 'svelte';
	import { db } from '@/db';
	import importData from '../../data/importfile.json';
	import { handleError } from '../../helpers/handleError';

	let currentUser;

	onMount(async () => {
		currentUser = await db.cloud.currentUser;
	});

	async function logout() {
		await db.cloud.logout({ force: true });
	}
</script>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
	<a class="navbar-brand" href="/">Dexie Cloud ToDo App</a>
	<button class="navbar-toggler"
		type="button"
		data-toggle="collapse"
		data-target="#navbarNavDropdown"
		aria-controls="navbarNavDropdown"
		aria-expanded="false"
		aria-label="Toggle navigation">
		<span class="navbar-toggler-icon"></span>
	</button>
	<div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">
		{#if currentUser?.isLoggedIn}
			<ul class="navbar-nav">
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle"
						href="/"
						id="navbarDropdownMenuLink"
						role="button"
						data-toggle="dropdown"
						aria-haspopup="true"
						aria-expanded="false">
						{currentUser.name}
					</a>
					<div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
						<a class="dropdown-item" href="/" on:click|preventDefault={logout}>Logout</a>
					</div>
				</li>
			</ul>
		{:else}
			<ul class="navbar-nav">
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle"
						href="/"
						id="navbarDropdownMenuLink"
						role="button"
						data-toggle="dropdown"
						aria-haspopup="true"
						aria-expanded="false">
						Sign in or create your account
					</a>
					<div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
						<h6 class="dropdown-header">Sign in a demo user</h6>
						{#each Object.keys(importData.demoUsers) as email (email)}
							<a class="dropdown-item"
								href="/"
								on:click|preventDefault={() => db.cloud.login({ grant_type: 'demo', email })}>{email}</a>
						{/each}
						<div class="dropdown-divider"></div>
						<h6 class="dropdown-header">Sign in real user</h6>
						<a class="dropdown-item" href="/" on:click|preventDefault={() => db.cloud.login()}>Sign in / sign up
							yourself
						</a>
					</div>
				</li>
			</ul>
		{/if}
	</div>
</nav>

<style>

</style>
