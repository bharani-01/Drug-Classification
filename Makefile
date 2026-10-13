HF_REPO ?= bharani-01/Drug-Classification

install:
	pip install --upgrade pip &&\
	pip install -r requirements.txt

format:
	black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./results/metrics.txt >> report.md
	echo "" >> report.md
	echo "## Confusion Matrix Plot" >> report.md
	echo '![Confusion Matrix](./results/model_results.png)' >> report.md
	cml comment create report.md

update-branch:
	git config --global user.name "$(USER_NAME)"
	git config --global user.email "$(USER_EMAIL)"
	git add -A
	git commit -am "Update with new results" || echo "No changes to commit"
	git push --force origin HEAD:update

hf-login:
	pip install -U "huggingface_hub[cli]"
	git pull origin update
	git switch update
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	huggingface-cli upload $(HF_REPO) ./app --repo-type=space --commit-message="Sync App files"
	huggingface-cli upload $(HF_REPO) ./model model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload $(HF_REPO) ./results metrics --repo-type=space --commit-message="Sync Metrics"

deploy: hf-login push-hub

all: install format train eval update-branch deploy
