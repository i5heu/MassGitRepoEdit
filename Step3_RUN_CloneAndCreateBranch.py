import os
import git
import configparser

# Read the global configuration from repos.conf
config = configparser.ConfigParser()
config.read('Step1_EDIT_repos.conf')

# Global configuration
global_fallback_branch = config.get('DEFAULT', 'GlobalFallBackBranch')
new_branch_name = config.get('DEFAULT', 'NewBranchName')

# Directory to store cloned repositories
repos_dir = './repos'

# Ensure the directory exists
if not os.path.exists(repos_dir):
    os.makedirs(repos_dir)

# Function to read repository entries from the repos.list file
def read_repos_from_file(file_path):
    repos = []
    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if line:
                repos.append(line)
    return repos

# Get the list of repositories from the repos.list file
repo_entries = read_repos_from_file('Step2_EDIT_repos.list')

# Process each repository
for repo_entry in repo_entries:
    repo_url, branch_name = repo_entry.split()
    repo_url = repo_url.strip()
    branch_name = branch_name.strip()
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
    try:
        print(f'Checking out branch {branch_to_checkout} in {repo_name}')
        repo.git.checkout(branch_to_checkout)
    except git.exc.GitCommandError:
        print(f'Branch {branch_to_checkout} not found in {repo_name}. Checking out global fallback branch {global_fallback_branch}')
        repo.git.checkout(global_fallback_branch)

    # Create and checkout the new branch
    print(f'Creating and checking out new branch {new_branch_name} in {repo_name}')
    repo.git.checkout('-b', new_branch_name)

    # Push the new branch to the remote repository
    print(f'Pushing new branch {new_branch_name} to remote in {repo_name}')
    repo.git.push('--set-upstream', 'origin', new_branch_name)
    print(f'Repo {repo_name} done. \n')

print('All repositories processed successfully.')
