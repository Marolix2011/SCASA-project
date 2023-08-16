FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["SCASA.csproj","./"]
RUN dotnet restore "SCASA.csproj"
COPY . .
RUN dotnet build "SCASA.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SCASA.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","SCASA.dll"]
