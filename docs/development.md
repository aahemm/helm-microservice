To create a package from chart: 
- Update chart version in `Chart.yaml` file
- Run `helm package .` in the root of project
- Move the generated `app-$version.tgz` file to `hack/`
- Run `./generate-index.sh $version` in `hack/` and copy new lines in `hack/index.taml` to `index.yaml`
- Upload the `.tgz` file to releases 
- Commit changes and push it to github
