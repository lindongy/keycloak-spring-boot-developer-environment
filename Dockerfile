ARG my_arg

FROM jboss/keycloak:15.0.2 as base

RUN echo "Copiando defaults"
COPY ./themes/ /opt/jboss/keycloak/themes/

FROM base AS ambiente-dev
ENV AMBIENTE=DESENVOLVIMENTO
RUN echo "Ambiente de desenvolvimento"
USER root
RUN sed -i 's/^parent=.*/parent=oi/g' /opt/jboss/keycloak/themes/custom-theme/login/theme.properties

FROM base AS ambiente-hml
ENV AMBIENTE=HOMOLOGACAO
RUN echo "Ambiente de homologação"
USER root
RUN sed -i 's/^parent=.*/parent=tchau/g' /opt/jboss/keycloak/themes/custom-theme/login/theme.properties

FROM ambiente-${my_arg} AS final
RUN echo "Ambiente é ${AMBIENTE}"

# ENV KEYCLOAK_LOGLEVEL=DEBUG
ENV KEYCLOAK_USER=admin
ENV KEYCLOAK_PASSWORD=admin

# ENV KEYCLOAK_IMPORT /tmp/import_realm.json
# COPY imports/realm.json /tmp/import_realm.json

# RUN mkdir -p /opt/jboss/startup-scripts/
# COPY ./startup_scripts /opt/jboss/startup-scripts
# COPY ./themes/ /opt/jboss/keycloak/themes/
# COPY ./deployments /opt/jboss/keycloak/standalone/deployments

EXPOSE 8080