FROM microsoft/aspnetcore-build:2 as build-env

WORKDIR /build

WORKDIR /build/src/Infrastructure
COPY src/Infrastructure/*.csproj .
RUN dotnet restore 

WORKDIR /build/src/ApplicationCore
COPY src/ApplicationCore/*.csproj .
RUN dotnet restore 

WORKDIR /build/src/WebRazorPages
COPY src/WebRazorPages/*.csproj .
RUN dotnet restore 

WORKDIR /build/src/Web
COPY src/Web/*.csproj .
RUN dotnet restore 

WORKDIR /build/tests/FunctionalTests
COPY tests/FunctionalTests/*.csproj .
RUN dotnet restore 

WORKDIR /build/tests/UnitTests
COPY tests/UnitTests/*.csproj .
RUN dotnet restore 

WORKDIR /build/tests/IntegrationTests
COPY tests/IntegrationTests/*.csproj .
RUN dotnet restore 

WORKDIR /build
COPY . .
RUN dotnet build
# RUN dotnet test - or per project
# 

RUN dotnet publish src/Web/Web.csproj -o /publish

# Runtime stage
FROM microsoft/aspnetcore:2
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT ["dotnet", "Web.dll"]