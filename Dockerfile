# =======================
# STAGE 1 — Build (uses .NET Core 2.1 SDK)
# =======================
FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /app

COPY dotnet-hello-world.sln ./
COPY hello-world-api/ hello-world-api/

RUN dotnet restore hello-world-api/hello-world-api.csproj

RUN dotnet publish hello-world-api/hello-world-api.csproj -c Release -o /out

# =======================
# STAGE 2 — Runtime (uses .NET Core 2.1 Runtime)
# =======================
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS runtime
WORKDIR /app

COPY --from=build /out .

EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

ENTRYPOINT ["dotnet", "hello-world-api.dll"]


