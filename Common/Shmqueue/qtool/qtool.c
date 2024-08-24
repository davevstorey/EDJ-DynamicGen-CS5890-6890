
#include <stdio.h>
#include <stdlib.h>
#include "Queue.h"

extern void FATest ();

int main (int argc, char *argv[])
{
    InitQueue (MEMMOD_SHARE);

    if (argc > 1)
    {
        ShowQueue (atoi (argv[1]));
    }
    else
    {
        ShowQueue (32);
    }
    
    FATest ();
    return 0;
}

