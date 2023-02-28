import subprocess
import urllib.request
import os
import sys
import tempfile

def main():
    log('Building database...')

    dryrun = False
    if len(sys.argv) >= 2 and sys.argv[1] == '-d':
        log('Dry run')
        dryrun = True

    github_repo = os.getenv('GITHUB_REPOSITORY', 'theypsilon/test')
    db_id = os.getenv('DB_ID', None)
    if db_id is None:
        db_id = github_repo

    if not dryrun:
        run(['git', 'config', '--global', 'user.email', 'theypsilon@gmail.com'])
        run(['git', 'config', '--global', 'user.name', 'The CI/CD Bot'])
        
        cleanup_build_py(github_repo)

    log('downloading db_operator.py')
    urllib.request.urlretrieve('https://raw.githubusercontent.com/MiSTer-devel/Distribution_MiSTer/develop/.github/db_operator.py', '/tmp/distribution_db_operator.py')

    db_url = f'https://raw.githubusercontent.com/{github_repo}/db/db.json.zip'
    base_files_url = f'https://raw.githubusercontent.com/{github_repo}/%s/'

    subprocess.run(['rm *.sh'], shell=True, stderr=subprocess.STDOUT)

    run(['python3', '-m', 'pip', 'install', 'Pillow'])

    run(['python3', '/tmp/distribution_db_operator.py', 'build', '.'], env={
        'DB_ID': db_id,
        'DB_URL': db_url,
        'DB_JSON_NAME': 'db.json',
        'BASE_FILES_URL': base_files_url,
        'FINDER_IGNORE': os.getenv('FINDER_IGNORE', '')
    })

    if not dryrun and os.path.exists('db.json') and passes_db_tests(db_id):
        log('Pushing database...')
        run(['zip', 'db.json.zip', 'db.json'])
        run(['git', 'checkout', '--orphan','db'])
        run(['git', 'reset'])
        run(['git', 'add', 'db.json.zip'])
        run(['git', 'commit', '-m','Creating database'])
        run(['git', 'push', '--force','origin', 'db'])

    return 0

def passes_db_tests(db_id):
    log('Testing database...')

    with tempfile.TemporaryDirectory() as temp_folder:
        log('downloading downloader.sh')
        urllib.request.urlretrieve('https://raw.githubusercontent.com/MiSTer-devel/Downloader_MiSTer/main/downloader.sh', temp_folder + '/downloader.sh')
        run(['chmod', '+x', 'downloader.sh'], cwd=temp_folder)

        downloader_ini_content = f"""
            [MiSTer]
            base_path = {temp_folder}/
            base_system_path = {temp_folder}/
            update_linux = false
            allow_reboot  = 0
            verbose = false
            downloader_retries = 0

            [{db_id}]
            db_url = {os.getcwd()}/db.json
        """
        log('downloader.ini content:')
        log(downloader_ini_content)
        
        with open(temp_folder + '/downloader.ini', 'w') as fini:
            fini.write(downloader_ini_content)

        run(['./downloader.sh'], cwd=temp_folder, env={'DEBUG': 'true', 'CURL_SSL': ''})
        log('The test went well.')
        
    return True

def cleanup_build_py(github_repo):  
    if github_repo.lower().strip() == 'theypsilon/db-template_mister':
        log('Skipping cleanup_build_py')
        return

    needs_commit = False
    if os.path.exists('build_db.py'):
        run(['git', 'rm', 'build_db.py'])
        needs_commit = True

    if os.path.exists('.github/build_db.py'):
        run(['git', 'rm', '.github/build_db.py'])
        needs_commit = True

    if needs_commit:
        run(['git', 'commit', '-m','BOT: Cleaning build_db.py'])
        run(['git', 'push'])

def run(commands, env=None, cwd=None):
    log(' '.join(commands))
    if env is not None: log('with env:', env)
    if cwd is not None: log('with cwd:', cwd)
    subprocess.run(commands, cwd=cwd, env=env, check=True, stderr=subprocess.STDOUT)

def log(*text): print(*text, flush=True)

if __name__ == '__main__':
    exit(main())
