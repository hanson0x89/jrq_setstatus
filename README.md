# jrq_setstatus
BASH script that outputs AutoSys job definitions and adds their last reported status via status attribute

Usage: jrq_setstatus.sh [-j job_name] [-h]

Notes:

To ensure clean stdout (in case of errors) redirect stderr to a file<br />
      (e.g. jrq_setstatus.sh -J %testjob% 2>err.log)

The valid values for use with the status attribute are noted within the script. <br />
Non-valid values should be remapped to a valid value. Similarly, valid values can be remapped to alternate valid values.

# Example output

$ ./jrq_setstatus.sh -J testjob

/* ----------------- testjob ----------------- */

insert_job: testjob      job_type: CMD <br /> 
command: true <br /> 
machine: localhost <br />
owner: autosys@localhost <br /> 
permission:  <br />
date_conditions: 0 <br />
alarm_if_fail: 1 <br />
status: SUCCESS <br />
