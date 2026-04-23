      *>***************************************************************
      *> NOMBRE DEL PROGRAMA: PAYROLL
      *> AUTOR: Lucas Cañete
      *> FECHA: Abril 2026
      *> PROPÓSITO: Procesamiento batch de nómina (Mainframe simulado)
      *> ENTRADA:  EMPLOYEES.DAT (formato secuencial, 5 registros)
      *> SALIDA:   PAYROLL-REPORT.TXT (reporte detallado + resumen)
      *> TASA DESCUENTO: 17% fijo
      *> NOTAS: Implementa buenas prácticas COBOL estructurado.
      *>        Incluye manejo de archivos con FILE STATUS.
      *>***************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYROLL.
       AUTHOR. LUCAS-CANETE.
       DATE-WRITTEN. 2026-04-23.
      *>---------------------------------------------------------------
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMPLEADOS-FILE ASSIGN TO 'EMPLOYEES.DAT'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-EMPLEADOS-STATUS.
           SELECT REPORTE-FILE ASSIGN TO 'PAYROLL-REPORT.TXT'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-REPORTE-STATUS.
      *>---------------------------------------------------------------
       DATA DIVISION.
       FILE SECTION.
       FD  EMPLEADOS-FILE.
       01  EMPLEADO-RECORD.
           05  EMP-ID          PIC 9(5).
           05  EMP-NOMBRE      PIC X(20).
           05  EMP-SALARIO     PIC 9(7)V99.

       FD  REPORTE-FILE.
       01  REPORTE-LINEA       PIC X(80).

       WORKING-STORAGE SECTION.
      *>--- Variables de estado de archivos --------------------------
       01  WS-EMPLEADOS-STATUS PIC X(2).
           88  EMPLEADOS-OK    VALUE '00'.
           88  EMPLEADOS-EOF   VALUE '10'.
       01  WS-REPORTE-STATUS   PIC X(2).
           88  REPORTE-OK      VALUE '00'.

      *>--- Contadores y acumuladores --------------------------------
       01  WS-CONTADORES.
           05  WS-EMPLEADOS-LEIDOS   PIC 9(5) VALUE 0.
           05  WS-TOTAL-NETO         PIC 9(9)V99 VALUE 0.
           05  WS-TOTAL-BRUTO        PIC 9(9)V99 VALUE 0.

      *>--- Control de archivo ---------------------------------------
       01  WS-FIN-DE-ARCHIVO   PIC X(1) VALUE 'N'.
           88  FIN-DE-ARCHIVO   VALUE 'S'.

      *>--- Variables de cálculo -------------------------------------
       01  WS-SALARIO-NETO     PIC 9(7)V99.
       01  WS-TASA-DESCUENTO   PIC V99 VALUE 0.17.
       01  WS-FECHA            PIC X(10).

      *>--- Líneas de reporte ----------------------------------------
       01  CABECERA-1.
           05  FILLER PIC X(30) VALUE 'REPORTE DE NOMINA - BATCH JOB'.
           05  FILLER PIC X(20) VALUE 'FECHA: '.
           05  CAB-FECHA PIC X(10).

       01  CABECERA-2.
           05  FILLER PIC X(6)  VALUE 'ID    '.
           05  FILLER PIC X(20) VALUE 'NOMBRE              '.
           05  FILLER PIC X(13) VALUE 'SALARIO BRUTO'.
           05  FILLER PIC X(12) VALUE 'SALARIO NETO '.

       01  DETALLE-LINEA.
           05  DET-ID          PIC Z(4)9.
           05  FILLER          PIC X(2) VALUE SPACES.
           05  DET-NOMBRE      PIC X(20).
           05  FILLER          PIC X(2) VALUE SPACES.
           05  DET-BRUTO       PIC Z(6)9.99.
           05  FILLER          PIC X(2) VALUE SPACES.
           05  DET-NETO        PIC Z(6)9.99.

       01  RESUMEN-LINEA.
           05  FILLER PIC X(30) VALUE 'TOTAL EMPLEADOS PROCESADOS: '.
           05  RES-CANTIDAD    PIC Z(4)9.
           05  FILLER PIC X(5) VALUE SPACES.
           05  FILLER PIC X(20) VALUE 'TOTAL BRUTO: $'.
           05  RES-BRUTO       PIC Z(8)9.99.
           05  FILLER PIC X(5) VALUE SPACES.
           05  FILLER PIC X(20) VALUE 'TOTAL NETO: $'.
           05  RES-NETO        PIC Z(8)9.99.

      *>--- Manejo de errores ----------------------------------------
       01  WS-MENSAJE-ERROR    PIC X(60).

      *>---------------------------------------------------------------
       PROCEDURE DIVISION.
       MAIN.
      *>--- Obtener fecha del sistema
           MOVE FUNCTION CURRENT-DATE(1:10) TO WS-FECHA

      *>--- Abrir archivos y verificar estado
           OPEN INPUT EMPLEADOS-FILE
           IF NOT EMPLEADOS-OK THEN
               DISPLAY 'ERROR: No se pudo abrir EMPLOYEES.DAT'
               DISPLAY 'FILE STATUS: ' WS-EMPLEADOS-STATUS
               STOP RUN
           END-IF

           OPEN OUTPUT REPORTE-FILE
           IF NOT REPORTE-OK THEN
               DISPLAY 'ERROR: No se pudo crear PAYROLL-REPORT.TXT'
               DISPLAY 'FILE STATUS: ' WS-REPORTE-STATUS
               CLOSE EMPLEADOS-FILE
               STOP RUN
           END-IF

      *>--- Escribir cabeceras
           MOVE WS-FECHA TO CAB-FECHA
           WRITE REPORTE-LINEA FROM CABECERA-1
           WRITE REPORTE-LINEA FROM CABECERA-2
           WRITE REPORTE-LINEA FROM SPACES

      *>--- Procesar archivo de empleados
           PERFORM UNTIL FIN-DE-ARCHIVO
               READ EMPLEADOS-FILE INTO EMPLEADO-RECORD
                   AT END
                       SET FIN-DE-ARCHIVO TO TRUE
                   NOT AT END
                       PERFORM PROCESAR-EMPLEADO
               END-READ
           END-PERFORM

      *>--- Verificar que se procesaron datos
           IF WS-EMPLEADOS-LEIDOS = 0 THEN
               MOVE 'ADVERTENCIA: El archivo de entrada está vacío'
                   TO WS-MENSAJE-ERROR
               WRITE REPORTE-LINEA FROM WS-MENSAJE-ERROR
           END-IF

      *>--- Escribir resumen
           MOVE WS-EMPLEADOS-LEIDOS TO RES-CANTIDAD
           MOVE WS-TOTAL-BRUTO TO RES-BRUTO
           MOVE WS-TOTAL-NETO TO RES-NETO
           WRITE REPORTE-LINEA FROM SPACES
           WRITE REPORTE-LINEA FROM RESUMEN-LINEA

      *>--- Cerrar archivos y finalizar
           CLOSE EMPLEADOS-FILE
                 REPORTE-FILE

           DISPLAY 'JOB PAYROLL COMPLETADO EXITOSAMENTE'
           STOP RUN.

      *>---------------------------------------------------------------
       PROCESAR-EMPLEADO.
      *>--- Validación básica del registro
           IF EMP-SALARIO <= 0 THEN
               MOVE 'ADVERTENCIA: Salario inválido para ID '
                   TO WS-MENSAJE-ERROR
               DISPLAY WS-MENSAJE-ERROR EMP-ID
               EXIT PARAGRAPH
           END-IF

           ADD 1 TO WS-EMPLEADOS-LEIDOS
           ADD EMP-SALARIO TO WS-TOTAL-BRUTO

           COMPUTE WS-SALARIO-NETO ROUNDED =
               EMP-SALARIO * (1 - WS-TASA-DESCUENTO)

           ADD WS-SALARIO-NETO TO WS-TOTAL-NETO

           MOVE EMP-ID TO DET-ID
           MOVE EMP-NOMBRE TO DET-NOMBRE
           MOVE EMP-SALARIO TO DET-BRUTO
           MOVE WS-SALARIO-NETO TO DET-NETO

           WRITE REPORTE-LINEA FROM DETALLE-LINEA
           IF NOT REPORTE-OK THEN
               DISPLAY 'ERROR al escribir en reporte'
               DISPLAY 'FILE STATUS: ' WS-REPORTE-STATUS
           END-IF.
