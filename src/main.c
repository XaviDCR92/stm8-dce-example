#include "bar.h"

struct example
{
    int a;
    char b;
    int *c;
};

static void foo(struct example *const st)
{
    if (st)
    {
        if (st->c)
        {
            (*st->c)++;
        }
    }
}

_Noreturn void main(void)
{
    static struct example st;

    foo(&st);

    bar(st.a);

    for (;;);
}
