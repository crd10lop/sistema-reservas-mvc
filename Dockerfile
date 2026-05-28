FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["src/SistemaReservas.Web/SistemaReservas.Web.csproj", "SistemaReservas.Web/"]
COPY ["src/SistemaReservas.Core/SistemaReservas.Core.csproj", "SistemaReservas.Core/"]
COPY ["src/SistemaReservas.Data/SistemaReservas.Data.csproj", "SistemaReservas.Data/"]

RUN dotnet restore "SistemaReservas.Web/SistemaReservas.Web.csproj"

COPY src/ .
WORKDIR "/src/SistemaReservas.Web"
RUN dotnet build "SistemaReservas.Web.csproj" -c Release -o /app/build
RUN dotnet publish "SistemaReservas.Web.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SistemaReservas.Web.dll"]
