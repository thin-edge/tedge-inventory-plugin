set dotenv-load

build *ARGS:
    ./ci/build.sh {{ARGS}}

publish *ARGS:
    ./ci/publish.sh {{ARGS}}

#
# Testing
#

# Install python virtual environment
venv:
  [ -d .venv ] || python3 -m venv .venv
  ./.venv/bin/pip3 install -r tests/requirements.txt

# Run tests
test *args='':
  ./.venv/bin/python3 -m robot.run --outputdir output {{args}} tests
