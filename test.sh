#!/bin/bash
cobc -x -o payroll_test PAYROLL.cob || exit 1
./payroll_test
grep -q "TOTAL EMPLEADOS PROCESADOS: *5" PAYROLL-REPORT.TXT
