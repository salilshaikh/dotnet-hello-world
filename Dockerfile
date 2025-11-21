
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app


COPY dotnet-hello-world.sln ./
COPY hello-world-api/ hello-world-api/

RUN dotnet restore


RUN dotnet publish hello-world-api/hello-world-api.csproj -c Release -o /out


FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

COPY --from=build /out .

ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000


ENTRYPOINT ["dotnet", "hello-world-api.dll"]
