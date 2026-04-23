#!/bin/bash
echo "🧪 Ejecutando prueba de validación de salida..."
cobc -x -o payroll_test PAYROLL.cob
./payroll_test > /dev/null
if grep -q "TOTAL EMPLEADOS PROCESADOS: 5" PAYROLL-REPORT.TXT; then
    echo "✅ Test superado: 5 empleados procesados."
    exit 0
else
    echo "❌ Test fallido: No se encontraron 5 empleados."
    exit 1
fi
