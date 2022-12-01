/**
  @file
  @brief Generic assertion
  @details Useful in the context of writing sasjs tests.  The results of the
  test are _appended_ to the &outds. table.
  Example usage:
      %mp_assert(iftrue=(1=1),
        desc=Obviously true
      )
      %mp_assert(iftrue=(1=0),
        desc=Will fail
      )
  @param [in] iftrue= (1=1) A condition where, if true, the test is a PASS.
  Else, the test is a fail.
  @param [in] desc= (Testing observations) The user provided test description
  @param [out] outds= (work.test_results) The output dataset to contain the
  results.  If it does not exist, it will be created, with the following format:
  |TEST_DESCRIPTION:$256|TEST_RESULT:$4|TEST_COMMENTS:$256|
  |---|---|---|
  |User Provided description|PASS|Column &inds contained ALL columns|
  @version 9.2
  @author Allan Bowe
**/

%macro assert(
    iftrue=(1=1),
);
    %if %eval(%unquote(&iftrue)) %then %do;
        %put NOTE: Test Passed;
    %end;
    %else %do;
        %put %str(E)RROR: Test Failed;
        %abort;
    %end;
%mend assert;