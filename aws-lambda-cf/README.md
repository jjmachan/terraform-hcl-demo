to deploy the cloudformation stack run
```
aws cloudformation deploy \
--stack-name testservice \
--template-file cloudformation_template.yaml \
--parameter-overrides file://params.json
--capabilities CAPABILITY_IAM
```
