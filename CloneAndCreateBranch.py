import os
import git
import configparser

# Read the configuration file
config = configparser.ConfigParser()
config.read('repos.conf')

# Global configuration
global_fallback_branch = config.get('DEFAULT', 'GlobalFallBackBranch')
new_branch_name = config.get('DEFAULT', 'NewBranchName')

# Directory to store cloned repositories
repos_dir = './repos'

# Ensure the directory exists
if not os.path.exists(repos_dir):
    os.makedirs(repos_dir)

# Process each repository
for repo_url, branch_name in config.items('Repos'):
    repo_name = os.path.basename(repo_url).replace('.git', '')
    repo_path = os.path.join(repos_dir, repo_name)

    # Clone the repository
    print(f'Cloning {repo_url} into {repo_path}')
    if os.path.exists(repo_path):
        repo = git.Repo(repo_path)
    else:
        repo = git.Repo.clone_from(repo_url, repo_path)

    # Checkout the specified branch or the global fallback branch
    branch_to_checkout = branch_name if branch_name else global_fallback_branch
    print(f'Checking out branch {branch_to_checkout} in {repo_name}')
    repo.git.checkout(branch_to_checkout)

    # Create and checkout the new branch
    print(f'Creating and checking out new branch {new_branch_name} in {repo_name}')
    repo.git.checkout('-b', new_branch_name)

    # Push the new branch to the remote repository
    print(f'Pushing new branch {new_branch_name} to remote in {repo_name}')
    repo.git.push('--set-upstream', 'origin', new_branch_name)

print('All repositories processed successfully.')
