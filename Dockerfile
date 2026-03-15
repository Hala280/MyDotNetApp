# STAGE 1: Build the application using the heavy SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["MyDotNetApp.csproj", "./"]
RUN dotnet restore "./MyDotNetApp.csproj"

# Copy the rest of the code and publish the release version
COPY . .
RUN dotnet publish "MyDotNetApp.csproj" -c Release -o /app/publish

# STAGE 2: Run the application using the lightweight Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
EXPOSE 8080

# Copy the compiled app from Stage 1 into Stage 2
COPY --from=build /app/publish .

# Tell the container how to start
ENTRYPOINT ["dotnet", "MyDotNetApp.dll"]