%macro StackDefine(
    stackName = Stack1, /* Name of the stack - use the name in */
            /* push and pop of this stack */
    dataType = n, /* Datatype n - numeric */
                  /* c - character */
    dataLength = 8, /* Length of data iitems */
    hashexp = 8, /* Hashexp for the hash - see the */
                /* documentation for the */
                /* hash object. You may want to increase */
                /* this for a stack that */
                /* will get really large */
    rc = Stack1_rc
); /* Return code for stack operations */

    /* the macro will create the following data */
    /* objects and variables */
    /* &StackName._Hash, the hash object used for the stack */
    /* &StackName._key, the hash object key variable */
    /* &StackName._data, the hash object data variable */
    /* &StackName._end, variable to hold the number of objects */
    /* in the stack */
    retain &StackName._end 0; /* empty stack has 0 items */
    length &StackName._key 8; /* key is numeric count of items in the stack */

    /* making this length 4 would save memory and work */
    /* for a large number of items in the stack */
    call missing(&StackName._key); /* explicit assignment so SAS does not complain */

    %IF &dataType EQ n %THEN %DO;
        length &StackName._data &datalength;
        retain &StackName._data 0;
    %END;
    %ELSE %DO;
        length &StackName._data $ &datalength;
        retain &StackName._data ' ';
    %END;

    declare hash &StackName._Hash(hashexp: &hashexp);
    &rc = &StackName._Hash.defineKey("&StackName._key");
    &rc = &StackName._Hash.defineData("&StackName._data");
    &rc = &StackName._Hash.defineDone();

    /* ITEM_SIZE attribute available in SAS 9.2
    itemSize = &StackName._Hash.ITEM_SIZE; */
    itemSize = 8 + &datalength;
    put "Stack &StackName. Created. Each Item will take " ItemSize " bytes.";
%mend StackDefine;



%macro StackPush(stackName = Stack1, /* Name of the stack - */
            InputData = Stack1_data, /* Variable containing value to be pushed */
            StackLength = Stack1_length, /* Returns the length of the stack */
            rc = Stack1_rc ); /* return code for stack operations */
    &StackName._end+1 ; /* new item will go in new location in the hash */
    &StackLength = &StackName._end;
    &StackName._key = &StackName._end; /* new value goes at the end */
    &StackName._data = &InputData; /* value from &InputData */
    &rc = &StackName._Hash.add();

    if &rc ne 0 then
        put "NOTE: PUSH to stack &stackName failed " &InputData= &StackName._end=;
%mend StackPush;

%macro StackPop(stackName = Stack1, /* Name of the stack - */
            OutputData = Stack1_data, /* Variable containing value to be pushed */
            StackLength = Stack1_length, /* Returns the length of the stack */
            rc = Stack1_rc ); /* return code for stack operations */
    if &StackName._end > 0 then do;
        &StackName._key = &StackName._end; /* return value comes off of the end */
        &rc = &StackName._Hash.find();

        if &rc ne 0 then
            put "NOTE: POP from stack &stackName could not find " &StackName._end=;
        &OutputData = &StackName._data; /* value into &InputData */

        /* remove the item from the hash */
        &rc = &StackName._Hash.remove();

        if &rc ne 0 then
            put "NOTE: POP from stack &stackName could not remove " &StackName._end=;
        &StackName._end = &StackName._end - 1 ; /* stack now has 1 fewer item */
        &StackLength = &StackName._end;
    end;
    else do;
        &rc = 999999;
        put "NOTE: Cannot pop empty stack &StackName into &OutputData ";
    end;
%mend StackPop;

%macro StackLength(stackName = Stack1, /* Name of the stack - */
            StackLength = Stack1_length, /* Returns the length of the stack */
            rc = Stack1_rc ); /* return code for stack operations */
    &StackLength = &StackName._end;
%mend StackLength;

%macro StackDelete(stackName = Stack1, /* Name of the stack - */
            rc = Stack1_rc /* return code for stack operations */
            );
    &rc = &StackName._Hash.delete();

    if &rc ne 0 then
        put "NOTE: Cannot delete stack &StackName ";
%mend StackDelete;

%macro StackDump(stackName = Stack1, /* Name of the stack - */
            rc = Stack1_rc ); /* return code for stack operations */
    if &StackName._end <= 0 then do;
        put // "Stack &Stackname is empty";
    end; /* &StackName._end <= 0 */
    else do;
        put // " Contents of Stack &Stackname:";

        do ixStack = 1 to &StackName._end;
            &StackName._key = ixStack;
            &rc = &StackName._Hash.find();
            put "item " ixStack "value " &StackName._data;
        end; /* do ixStack = 1 to &StackName._end */
    end; /* not &StackName._end <= 0 */
%mend StackDump;