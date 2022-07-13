FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
#copia mi csproj al container, y ejecutalo para descargar las dependencias.
COPY "MVCPrototipo.csproj" . 
RUN dotnet restore "MVCPrototipo.csproj"
#copia todo el proyecto y muevelo al container.
COPY . .
#construcción del Release para generar las dlls.
RUN dotnet build . -c Release -o /app/build

#construcción del ejecutable.
FROM build AS publish
RUN dotnet publish "MVCPrototipo.csproj" -c Release -o /app/publish

#Agrego el runtime al interior de la carpeta publish.
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MVCPrototipo.dll"]



