#!/bin/bash

echo "=========================================="
echo "VERIFICACIÓN COMPLETA - FASE 4 Y 5"
echo "=========================================="

echo ""
echo "1️⃣  Status de Git..."
git status | head -5

echo ""
echo "2️⃣  Últimos commits..."
git log --oneline -5

echo ""
echo "3️⃣  Docker status..."
docker ps | grep sistema-reservas

echo ""
echo "4️⃣  Tablas en BD..."
docker exec sistema-reservas-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Reservas@2024#Xk9!' -C -d SistemaReservas -Q "SELECT 'Tablas totales:', COUNT(*) FROM SistemaReservas.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'" 2>&1 | grep -E "Tablas|16"

echo ""
echo "5️⃣  Datos seed..."
docker exec sistema-reservas-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Reservas@2024#Xk9!' -C -d SistemaReservas -Q "SELECT 'Sedes:', COUNT(*) FROM Sedes; SELECT 'Alojamientos:', COUNT(*) FROM Alojamientos; SELECT 'Tarifas:', COUNT(*) FROM Tarifas;" 2>&1 | grep -E "Sedes|Alojamientos|Tarifas"

echo ""
echo "6️⃣  Compilación..."
cd src/ && dotnet build 2>&1 | tail -3

echo ""
echo "7️⃣  Archivo seed data..."
test -f database/02_SeedData.sql && echo "✅ database/02_SeedData.sql existe" || echo "⚠️  Falta database/02_SeedData.sql"

echo ""
echo "=========================================="
echo "✅ VERIFICACIÓN COMPLETADA"
echo "=========================================="