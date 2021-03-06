#!/usr/bin/perl

use Env;
use DBI;
use lib "scripts";
require image_sharing;

sub select_exam {
 my ($dbName, $pid) = @_;

 @exam = image_sharing::select_exam_by_patient_id($dbName, $pid);
 if (scalar(@exam) < 4) {
  $x = scalar(@exam);
  if ($x == 0) {
   print "No Exam Record returned for PID: $pid\n";
  } else {
   print "Row for patient with PID: $pid has only $x columns.\n";
   print " We expected at least 4\n";
  }
  die "Failed A-3001-01";
 }
 return @exam;
}

sub dump_hints
{
 my $x =
 "The most likely cause of failure of this test is extracting the wrong\n" .
 " Accession Number. This test assumes the Accession Number is a copy of\n" .
 " the Filler Order Number, ORC-3.\n";

 print $x;
}


## Main starts here
 image_sharing::check_environment();
 image_sharing::clear_db("rsnadb");

 my $verbose = "";
 $verbose = "1" if (scalar(@ARGV) > 0);
 chdir("data/A-3001");
 print `perl A-3001.pl $verbose`;
 die if $?;
 chdir("../..");

 @hl7_msgs = ("A-3001-01-orm");
 foreach $msg(@hl7_msgs) {
  print "$msg\n";
  my $x = "$MESA_TARGET/bin/send_hl7 localhost 20000 data/A-3001/$msg" . ".hl7";
  print "$x\n";
  print `$x`;
  die "Could not send HL7 message to localhost" if $?;
 }

 $testMRN = "A-3001-01";
 @patient = image_sharing::select_patient_by_mrn("rsnadb", $testMRN);
 die "A-3001 select patient by MRN failed for MRN: $testMRN" if (scalar(@patient) == 0);
 @exam    = select_exam("rsnadb", $patient[0]);

 print "Start patient data test\n";
 my %patientHash;
 @localPatient = ("pid", "A-3001-01", "Clark^Wayne^", "1980-12-14", "M");
 %patientHash = image_sharing::append_patient_hash_global(@patient, %patientHash);
 %patientHash = image_sharing::append_patient_hash_local (@localPatient, %patientHash);
 $pass = image_sharing::check_patient(%patientHash);

 print "Start exam data test\n";
 my %examHash;
 @localExam = ("pid", "A-3001-01F", "Head MR", "modified-date");
 %examHash = image_sharing::append_exam_hash_global(@exam, %examHash);
 %examHash = image_sharing::append_exam_hash_local (@localExam, %examHash);
 $pass += image_sharing::check_exam(%examHash);

 if ($pass != 2) {
  dump_hints();
  die "Failed A-3001-01";
 }

 print "A-3001-01 pass\n";
