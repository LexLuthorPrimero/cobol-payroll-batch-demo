#!/bin/bash
echo "🧪 Ejecutando prueba de validación de salida..."

# Limpiar compilaciones anteriores
rm -f payroll_test

# Compilar
cobc -x -o payroll_test PAYROLL.cob
if [ $? -ne 0 ]; then
    echo "❌ Error de compilación"
    exit 1
fi

# Ejecutar (redirigir salida estándar pero mostrar si hay errores)
./payroll_test

# Verificar que el archivo de reporte existe
if [ ! -f PAYROLL-REPORT.TXT ]; then
    echo "❌ No se generó PAYROLL-REPORT.TXT"
    exit 1
fi

# Mostrar el contenido para depuración (útil en CI)
echo "--- Contenido del reporte ---"
cat PAYROLL-REPORT.TXT
echo "-----------------------------"

# Buscar el patrón de 5 empleados (ignorando espacios extras)
if grep -q "TOTAL EMPLEADOS PROCESADOS: *5" PAYROLL-REPORT.TXT; then
    echo "✅ Test superado: 5 empleados procesados correctamente."
    exit 0
else
    echo "❌ Test fallido: No se encontró 'TOTAL EMPLEADOS PROCESADOS: 5' en el reporte."
    exit 1
fi
