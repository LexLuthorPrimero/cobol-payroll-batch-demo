#!/bin/bash
echo "🧪 Ejecutando prueba de validación de salida..."
# Ejecutar programa y guardar salida
cobc -x -o payroll_test PAYROLL.cob
./payroll_test > /dev/null
# Comparar reporte generado con un hash conocido (o patrón esperado)
if grep -q "TOTAL EMPLEADOS PROCESADOS: 5" PAYROLL-REPORT.TXT; then
    echo "✅ Test superado: 5 empleados procesados."
    exit 0
else
    echo "❌ Test fallido: No se encontraron 5 empleados."
    exit 1
fi
