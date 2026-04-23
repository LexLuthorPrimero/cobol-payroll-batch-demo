#!/bin/bash
# ==============================================
# SIMULADOR DE JCL PARA ENTORNO MAINFRAME
# Este script emula la ejecución de un JOB batch
# ==============================================

echo "======================================="
echo "  JOB PAYROLL - INICIANDO EJECUCION"
echo "======================================="
echo "Sistema: $(uname -a)"
echo "Fecha: $(date)"
echo ""

# Verificar compilador
if ! command -v cobc &> /dev/null; then
    echo "ERROR: GnuCOBOL no instalado. Ejecute setup_cobol_project.sh primero."
    exit 1
fi

# Compilar
echo ">>> COMPILANDO PROGRAMA COBOL..."
cobc -x -o payroll PAYROLL.cob
if [ $? -ne 0 ]; then
    echo "ERROR: Falló compilación."
    exit 1
fi
echo ">>> Compilación exitosa."

# Ejecutar
echo ""
echo ">>> EJECUTANDO PROCESO BATCH..."
./payroll

return_code=$?
echo ""
if [ $return_code -eq 0 ]; then
    echo ">>> JOB FINALIZADO CON EXITO (RC=00)"
else
    echo ">>> ADVERTENCIA: RC=$return_code"
fi

echo ""
echo "======================================="
echo "  JOB PAYROLL - FINALIZADO"
echo "======================================="
exit $return_code
