FROM trion/ng-cli:12.2.1 as deps

ARG DAMAP_FE_VERSION

WORKDIR /app

# Clone repository
RUN git clone -b ${DAMAP_FE_VERSION} --single-branch --depth 1 https://github.com/tuwien-csd/damap-frontend.git .

# Copy custom components to the application
COPY ./layout_components/* /app/apps/damap-frontend/src/app/components/layout/

# angular-cli is installed locally, thus we point PATH to its binary folder
ENV PATH="$PATH:/app/node_modules/@angular/cli/bin/"

# install and build the application on the builder container
RUN npm install -g "nx@<16.7.0" && \
    npm install
RUN npx nx build damap-frontend

ARG APP=damap-frontend

# create a second container running a webserver and holding the built frontend application
FROM nginxinc/nginx-unprivileged as runner

ADD nginx/* /etc/nginx/conf.d

COPY --from=deps --chown=1001:0 /app/dist/apps/damap-frontend/ /usr/share/nginx/html/
