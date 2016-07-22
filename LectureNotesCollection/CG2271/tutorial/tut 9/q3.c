
// non-recurrent example

int t;
 
void swap(int *x, int *y)
{
        t = *x;
        *x = *y;
        // hardware interrupt might invoke isr() here!
        // then next time the function comes here, value of x has been changed
        // already
        *y = t;
}
 
void isr()
{
        int x = 1, y = 2;
        swap(&x, &y);
}





// recurrent example
int t;
 
void swap(int *x, int *y)
{
        int s;
 
        s = t;  // save global variable
        t = *x;
        *x = *y;
        // hardware interrupt might invoke isr() here!
        // but it doesn't matter as long as the value of t is not changed
        *y = t;
        t = s;  // restore global variable
}
 
void isr()
{
        int x = 1, y = 2;
        swap(&x, &y);
}


