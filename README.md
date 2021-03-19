# dakuten

Slack Slash Command
https://api.slack.com/interactivity/slash-commands

<img width="190" alt="スクリーンショット 2021-03-19 9 27 59" src="https://user-images.githubusercontent.com/10706586/111714650-7044e500-8895-11eb-9e73-8a6441606e6c.png">

## usage

```shell
# console 1
cpanm --installdeps .
./lib/dakuten.pl
...
...
# console 2
make debug
...
...
```

## deploy

sample cloud run

```shell
export PROJECT_ID=<aaa>
export APP=<aaa>
gcloud builds submit --tag gcr.io/$PROJECT_ID/$APP --timeout="1h"
gcloud run deploy --image gcr.io/$PROJECT_ID/$APP --platform managed --region asia-northeast1
```

