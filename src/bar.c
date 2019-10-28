#include "bar.h"

void bar(const int x)
{
    int i;

    /* Some stupid calculations here and there. */
    for (i = 0; i < 90; i++)
    {
        if (i - x)
        {
            for (;;);
        }
    }
}
