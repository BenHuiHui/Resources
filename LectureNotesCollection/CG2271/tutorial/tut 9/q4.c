// Is this function re‐entrant? 

// it is recurrant because all variables are local.

int strlen(char *p_sz)
{
    int iLength;
    iLength = 0;
    while(*p_sz != ‘\0’)
    {
        ++iLength;
        ++p_sz;
    }
    return iLength;
}

