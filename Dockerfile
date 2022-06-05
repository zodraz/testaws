FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["CoffeeService.csproj", "./"]
RUN dotnet restore "CoffeeService.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "CoffeeService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CoffeeService.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5023
ENV ASPNETCORE_URLS=http://+:5023

WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CoffeeService.dll"]