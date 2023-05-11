module.exports = async ({ github, context }) => {
  let versions = [
    process.env.GITVERSION_MAJORMINORPATCH,
    `${process.env.GITVERSION_MAJOR}.${process.env.GITVERSION_MINOR}`,
    `${process.env.GITVERSION_MAJOR}`,
  ];
  versions.forEach(async (version) => {
    try {
      console.log(`Creating v${version} tag`);
      await github.rest.git.createRef({
        owner: context.repo.owner,
        repo: context.repo.repo,
        ref: `refs/tags/v${version}`,
        sha: context.sha,
      });
      console.log(`Created v${version} tag`);
    } catch (error) {
      console.log(`Updating v${version} tag`);
      await github.rest.git.updateRef({
        owner: context.repo.owner,
        repo: context.repo.repo,
        ref: `tags/v${version}`,
        sha: context.sha,
        force: true,
      });
      console.log(`Updated v${version} tag`);
    }
  });
  console.log("::notice::Create/Update Tags complete...");
};
