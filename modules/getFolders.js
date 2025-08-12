(async () => {
  const { Octokit } = await import("@octokit/rest");
  const { execSync } = require("child_process");

  // Environment variables
  const GITHUB_TOKEN = process.env.GITHUB_TOKEN; // Make sure to export this in your terminal
  const GITHUB_REPOSITORY = process.env.GITHUB_REPOSITORY; // e.g., "owner/repo"
  const GITHUB_REF_NAME = process.env.GITHUB_REF_NAME; // e.g., the branch name

  if (!GITHUB_TOKEN || !GITHUB_REPOSITORY || !GITHUB_REF_NAME) {
    console.error(
      "Please set the necessary environment variables: GITHUB_TOKEN, GITHUB_REPOSITORY, GITHUB_REF_NAME"
    );
    process.exit(1);
  }

  const octokit = new Octokit({ auth: GITHUB_TOKEN });

  try {
    const [owner, repo] = GITHUB_REPOSITORY.split("/");
    
    // Fetch the latest release
    const latestRelease = await octokit.request("GET /repos/{owner}/{repo}/releases/latest", {
      owner: owner,
      repo: repo,
      headers: {
        "X-GitHub-Api-Version": "2022-11-28",
      },
    });
    console.log(`Latest release: ${JSON.stringify(latestRelease.data)}`);

    // Pull tags locally
    execSync("git pull --tags");

    // Compare the latest release tag with the current branch
    const status = execSync(
      `git diff --name-only ${latestRelease.data.tag_name} origin/${GITHUB_REF_NAME}`,
      { encoding: "utf-8" }
    );
    console.log(status);

    // Extract module paths
    const changes = status.split("\n");
    let modules_paths = new Set();
    for (const change of changes) {
      if (change.startsWith("modules/")) {
        const library = change.split("/")[1];
        modules_paths.add(library);
      }
    }
    modules_paths = Array.from(modules_paths);
    console.log(modules_paths);
  } catch (error) {
    console.error("Error running script:", error);
  }
})();