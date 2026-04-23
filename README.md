# Proyecto: Procesamiento de Nómina Batch (COBOL + JCL)

Demostración de un proceso batch clásico de mainframe implementado con herramientas modernas y gratuitas.

## Tecnologías Utilizadas
- **COBOL** (compilado con GnuCOBOL)
- **JCL** (simulado mediante script shell)
- **Manejo de Archivos Secuenciales** (QSAM)
- **Sistema Operativo:** Linux (Probado en Fedora/Nobara)

## Objetivo de Negocio
Leer un archivo de empleados (`EMPLOYEES.DAT`), calcular el sueldo neto aplicando un descuento del 17% y generar un reporte detallado (`PAYROLL-REPORT.TXT`) con resumen de totales.

## Estructura del Proyecto

## Estado del Proyecto
![COBOL CI](https://github.com/LexLuthorPrimero/cobol-payroll-batch-demo/actions/workflows/ci.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![COBOL](https://img.shields.io/badge/COBOL-100%25-blue)

## Pruebas
El proyecto incluye un script `test.sh` que valida la correcta generación del reporte, asegurando que el proceso batch procesa exactamente 5 empleados y produce la salida esperada.
