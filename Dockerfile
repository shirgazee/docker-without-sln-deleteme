FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["DockerWOSolutionTest.Api/DockerWOSolutionTest.Api.csproj", "DockerWOSolutionTest.Api/"]
COPY ["DockerWOSolutionTest.Data/DockerWOSolutionTest.Data.csproj", "DockerWOSolutionTest.Data/"]
COPY ["DockerWOSolutionTest.Models/DockerWOSolutionTest.Models.csproj", "DockerWOSolutionTest.Models/"]
RUN dotnet restore "DockerWOSolutionTest.Api/DockerWOSolutionTest.Api.csproj"
COPY . .
WORKDIR "/src/DockerWOSolutionTest.Api"
RUN dotnet build "DockerWOSolutionTest.Api.csproj" -o /app/build

FROM build AS publish
RUN dotnet publish "DockerWOSolutionTest.Api.csproj" -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerWOSolutionTest.Api.dll"]
