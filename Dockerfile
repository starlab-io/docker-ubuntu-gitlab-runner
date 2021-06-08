FROM starlabio/ubuntu-native-build:38
MAINTAINER Farhan Patwa <farhan.patwa@starlab.io>


# --------------------------------------------------------------------------
# Install and configure sshd.
# https://docs.docker.com/engine/examples/running_ssh_service for reference.
# --------------------------------------------------------------------------
RUN apt-get install -y openssh-server && \
    mkdir -p /run/sshd

EXPOSE 22

# ----------------------------------------
# Install GitLab CI required dependencies.
# ----------------------------------------
ARG GITLAB_RUNNER_VERSION=13.10.0

RUN curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | bash && \
    export GITLAB_RUNNER_DISABLE_SKEL=true && \
    apt-get install "gitlab-runner=${GITLAB_RUNNER_VERSION}"

RUN apt-get install -y bash ca-certificates git git-lfs && \
    git lfs install --skip-repo

# -------------------------------------------------------------------------------------
# Execute a startup script.
# https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data
# for reference.
# -------------------------------------------------------------------------------------
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

