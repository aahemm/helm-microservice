## Create a package from chart: 
- Update chart version in `Chart.yaml` file
- Run `helm package .` in the root of project
- Move the generated `app-$version.tgz` file to `hack/`
- Run `./generate-index.sh $version` in `hack/` and copy new lines in `hack/index.yaml` to `index.yaml`
- Upload the `.tgz` file to releases 
- Commit changes and push it to github

## Test new version of chart
- Run `helm template ./ --values ./hack/test-values/secret-file-deployment.yaml  > /tmp/helm-result.yaml` in the root of the project  
- Compare outputs: `diff /tmp/helm-result.yaml hack/test-values/expected-results/some-file.yaml`  
- For each new test result in `hack/test-values/expected-results` run this in the root of the project:
```sh
helm template ./ --values ./hack/test-values/secret-file-deployment.yaml > ./hack/test-values/expected-results/secret-file-deployment.yaml
```