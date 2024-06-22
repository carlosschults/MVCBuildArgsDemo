ARG DOTNET_VERSION=8.0
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION} AS build
ARG ENVIRONMENT=Development
WORKDIR /app

COPY . .
RUN dotnet restore

COPY appsettings.${ENVIRONMENT}.json appsettings.json

RUN dotnet build -c Release -o /app/build

RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:${DOTNET_VERSION} AS runtime
ARG ENVIRONMENT=Development
ENV ASPNETCORE_ENVIRONMENT $ENVIRONMENT

WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "build-args-mvc.dll", "--environment=${ENVIRONMENT}"]
