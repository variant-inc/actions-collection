module.exports = async ({ github, context }) => {
  let versions = [process.env.GitVersion_MajorMinorPatch];
  versions.forEach(async (version) => {
    try {
      console.log(`Creating v${version} release`);
      await github.rest.repos.createRelease({
        owner: context.repo.owner,
        repo: context.repo.repo,
        tag_name: `v${version}`,
        name: `v${version}`,
        generate_release_notes: true,
        make_latest: "true",
      });
    } catch (error) {
      console.log(`Updating v${version} release`);
      const release = await github.rest.repos.getReleaseByTag({
        owner: context.repo.owner,
        repo: context.repo.repo,
        tag: `v${version}`,
      });
      await github.rest.repos.updateRelease({
        owner: context.repo.owner,
        repo: context.repo.repo,
        release_id: release.data.id,
        tag_name: release.data.tag_name,
        sha: context.sha,
        force: true,
      });
      await github.rest.repos.generateReleaseNotes({
        owner: context.repo.owner,
        repo: context.repo.repo,
        tag_name: release.data.tag_name,
      });
    }
  });
  console.log("::notice::Create/Update Release complete...");
};
