FROM tiryoh/mkdocs-builder:debian

# Copy only requirements to cache them in docker layer
COPY poetry.lock pyproject.toml /docs/

# Install system deps
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        libcairo2 && \
    apt-get purge -y curl && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean -y && \
    rm -rf rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /docs

# Initialize project
RUN poetry install \
    --no-interaction --no-ansi

# Add script for GitHub Actions
COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
