# Procesamiento de Nómina Batch en COBOL

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![COBOL CI](https://github.com/LexLuthorPrimero/cobol-payroll-batch-demo/actions/workflows/ci.yml/badge.svg)](https://github.com/LexLuthorPrimero/cobol-payroll-batch-demo/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Proyecto demostrativo de un proceso batch típico de Mainframe, escrito en COBOL ANSI-85 y ejecutable en Linux con GnuCOBOL.

# # Funcionalidad
Lee un archivo de empleados (EMPLOYEES.DAT), calcula el sueldo neto aplicando un descuento del 17% y genera un reporte detallado (PAYROLL-REPORT.TXT).

# # Requisitos
- GnuCOBOL (instalable vía `sudo dnf install gnucobol` en Fedora/Nobara)
- Acceso a terminal

# # Ejecución

```bash
git clone https://github.com/LexLuthorPrimero/cobol-payroll-batch-demo.git
cd cobol-payroll-batch-demo
chmod +x run_payroll.sh
./run_payroll.sh

```


# # Pruebas automatizadas
Ejecuta `./test.sh` para verificar la correcta generación del reporte. Este script también se ejecuta automáticamente en cada push mediante GitHub Actions.

# # Salida esperada (ejemplo)

```

REPORTE DE NOMINA - BATCH JOB        FECHA: 2026-04-23

ID     NOMBRE                SALARIO BRUTO  SALARIO NETO 
    1  Juan Perez                12000.00       9960.00
    2  Maria Gomez               15000.00      12450.00
    3  Carlos Lopez               9500.00       7885.00
    4  Ana Martinez              18000.00      14940.00
    5  Luis Rodriguez            11000.00       9130.00

TOTAL EMPLEADOS PROCESADOS:     5     TOTAL BRUTO: $65500.00     TOTAL NETO: $54365.00

```


# # Autor
Lucas Cañete – Estudiante de Ingeniería Informática (UBA)
