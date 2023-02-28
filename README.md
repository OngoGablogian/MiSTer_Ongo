# Custom Database Template for the MiSTer Downloader

By following these instructions, you'll create your own [Custom Database for the MiSTer Downloader](https://github.com/MiSTer-devel/Downloader_MiSTer/blob/main/docs/custom-databases.md). This database can be integrated in MiSTer FPGA by just editing the `downloader.ini` file at the root of the SD.

Once your database is up, adding files to it is very simple. You'll only have to upload files to your repository on GitHub, and after that, your users will fetch these files directly in their devices, by just running *downloader* or *update_all*.

## How to generate your own Custom Database for the MiSTer Downloader:
1. Make sure you are logged in into your GitHub account. Or register a new account if you don't have any yet.
2. Then click on
    <a style="margin-top:100px;" href="https://github.com/theypsilon/DB-Template_MiSTer/generate">
        <img src="https://img.shields.io/badge/Use_this_template-2ea44f" 
            alt="Use this template"
            title="Create repository from this template"></a>
button to create your own public Custom Database repository on GitHub.
3. After less than 5 minutes, you're database file will be generated at `https://raw.githubusercontent.com/<YOUR GITHUB USER>/<YOUR GITHUB REPOSITORY>/db/db.json.zip` (replacing the <> fields accordingly) and will be ready to be used. For example, if your GitHub user is `jose` and your repository name is `game_wallpapers`, the url will be: `https://raw.githubusercontent.com/jose/game_wallpapers/db/db.json.zip`
4. To integrate it in a MiSTer device, add the following section to the end of to the file `downloader.ini` that should be placed at the root of the SD (if it doesn't exist, you may create it for this purpose):
```ini
[<YOUR GITHUB USER>/<YOUR GITHUB REPOSITORY>]
db_url = https://raw.githubusercontent.com/<YOUR GITHUB USER>/<YOUR GITHUB REPOSITORY>/db/db.json.zip
```
5. After that, run *downloader* or *update_all* as usual. It will try to fetch the files from your newly created database. If your database is still empty -which is your case if you followed these instructions-, obviously it won't download any file yet, but it will show up in the logs. For adding files to the database check the next section.

## How to add files to your already working Custom Database:

Once you have your database up and running (check previous section to figure out how to set it up), adding files is very straightforward.

Just upload any file to your repository by using GitHub UI (Add File > Upload files), or via git. Once the files show up in your repository, they'll also be added to your database automatically. You may see the *Actions* tab in your repository to see how the automation did its magic if you are curious.

A couple of things to consider when uploading files:

- When a user fetches the files via *downloader* or *update_all*, the downloaded file structure will mirror 1:1 the file structure you have in your repository at GitHub. This means, if you have a folder `_Cores/` containing some files in your repository, an identical `_Cores` folder will show up in MiSTer containing the exact same files.

- The files README.md, LICENSE, build_db.py, and the .github folder won't be included in your database. Just ignore them, they won't be installed in the devices.

- You may upload as many files as you want as long as they don't violate GitHub constraints (100mb is max size per file).

- You should avoid full path clashes between your files and the files from other databases so that your users don't run into issues when using multiple databases at the same time.

## How your users will integrate your Custom Database in their MiSTers:

Your users will just have to do the **step 4** of the "How to generate" section. So you should add those lines to your documentation replacing the placeholders with the correct GitHub user and repository name.

For example, assuming GitHub user is "jose" and the repository is called "game_wallpapers", your users will have to add these lines to the bottom of `downloader.ini`:

```ini
[jose/game_wallpapers]
db_url = https://raw.githubusercontent.com/jose/game_wallpapers/db/db.json.zip
```

This needs to be done just once by your users. After that, whenever they run *downloader* or *update_all* they'll also be installing your updated files.
