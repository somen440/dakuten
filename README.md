# dakuten

```shell
export PROJECT_ID=<aaa>
export APP=<aaa>
gcloud builds submit --tag gcr.io/$PROJECT_ID/$APP --timeout="1h"
gcloud run deploy --image gcr.io/$PROJECT_ID/$APP --platform managed --region asia-northeast1
```
