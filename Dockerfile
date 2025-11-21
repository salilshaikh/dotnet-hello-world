# =======================
# STAGE 1 — Build (.NET 6 SDK)
# =======================
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy solution and project
COPY dotnet-hello-world.sln ./
COPY hello-world-api/ hello-world-api/

# Restore dependencies
RUN dotnet restore dotnet-hello-world.sln

# Publish the API
RUN dotnet publish hello-world-api/hello-world-api.csproj -c Release -o /out

# =======================
# STAGE 2 — Runtime (.NET 6)
# =======================
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

COPY --from=build /out .

EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

ENTRYPOINT ["dotnet", "hello-world-api.dll"]
