# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Sourced from https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.3.1146"

WORKDIR /app
COPY appsettings.template.json /app/appsettings.template.json
COPY run.sh /app/run.sh
COPY log4net.config /app/log4net.txt

RUN apk add unzip dos2unix bash gettext postgresql-client && \
    wget -O /app/WebApi.zip  https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.WebApi/versions/${VERSION}/content && \
    unzip /app/WebApi.zip -d /app && \
    rm -f /app/WebApi.zip && \
    cp /app/log4net.txt /app/log4net.config && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    dos2unix /app/log4net.config && \
    chmod 700 /app/*.sh ** && \
    rm -f /app/*.exe
 
EXPOSE "80"

ENTRYPOINT exec /app/run.sh
